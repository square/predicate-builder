import CoreData

/// A type that stores a predicate and the object type it on which it will be evaluated
///
/// Useful for composing predicates from other predicates:
///
/// ```swift
/// @PredicateBuilder var isNitro: some TypedPredicate<Coffee> {
///      \.isNitro
/// }
///
/// @PredicateBuilder var isIced: some TypedPredicate<Coffee> {
///      \.isIced
/// }
///
/// @PredicateBuilder var isCold: some TypedPredicate<Coffee> {
///      isNitro || isIced
/// }
///  ```
public protocol TypedPredicate<Root> {
    associatedtype Root: NSManagedObject
    var predicate: NSPredicate { get }
}


public extension TypedPredicate {
    func eraseToAnyTypedPredicate() -> AnyTypedPredicate<Root> {
        AnyTypedPredicate<Root>(format: predicate.predicateFormat)
    }
}

// MARK: - TypedPredicate Implementations

/// A type-erased predicate and the type on which it will be evaluated.
public final class AnyTypedPredicate<RootType: NSManagedObject>: NSPredicate, TypedPredicate {
    public typealias Root = RootType
    
    public var predicate: NSPredicate {
        self
    }
}

/// A specialized predicate that evaluates logical combinations of other predicates.
///
/// Used for `AND`, `OR`, and `NOT` operations.
public final class CompoundPredicate<RootType: NSManagedObject>: NSCompoundPredicate, TypedPredicate {
    public typealias Root = RootType
    
    public var predicate: NSPredicate {
        self
    }
}

/// A specialized predicate for comparing multiple expressions.
public final class ComparisonPredicate<RootType: NSManagedObject, Value>: NSComparisonPredicate, TypedPredicate {
    public typealias Root = RootType
    
    public var predicate: NSPredicate {
        self
    }
    
    // This is less than ideal, however it seems that Swift does not currently
    // support a mechanism to "erase" a key path value's optionality. See:
    // https://forums.swift.org/t/keypath-t-u-required-but-i-only-have-keypath-t-u/15468
    private enum KeyPathType {
        case optional(KeyPath<Root, Value?>)
        case nonOptional(KeyPath<Root, Value>)
    }
    
    private let keyPath: KeyPathType
    private let comparisonOperator: NSComparisonPredicate.Operator
    private let value: Any?
    private let modifier: Modifier
    
    /// Creates a predicate formed by comparing the given key path's value, an operator, and a value for
    /// the right-hand-side of the comparison.
    ///
    /// You should not form predicates using this method directly.
    /// Use the [`@PredicateBuilder`](x-source-tag://PredicateBuilder) result builder instead.
    public convenience init(
        _ keyPath: KeyPath<Root, Value>,
        _ comparisonOperator: NSComparisonPredicate.Operator,
        _ value: Any?,
        modifier: NSComparisonPredicate.Modifier = .direct,
        options: ComparisonPredicateOptions = []
    ) {
        self.init(
            keyPath: .nonOptional(keyPath),
            comparisonOperator: comparisonOperator,
            value: value,
            modifier: modifier,
            options: options
        )
    }
    
    /// Creates a predicate formed by comparing the given key path's value, an operator, and an optional value for
    /// the right-hand-side of the comparison.
    ///
    /// You should not form predicates using this method directly.
    /// Use the [`@PredicateBuilder`](x-source-tag://PredicateBuilder) result builder instead.
    public convenience init(
        keyPath: KeyPath<Root, Value?>,
        _ comparisonOperator: NSComparisonPredicate.Operator,
        _ value: Any?,
        modifier: NSComparisonPredicate.Modifier = .direct,
        options: ComparisonPredicateOptions = []
    ) {
        self.init(
            keyPath: .optional(keyPath),
            comparisonOperator: comparisonOperator,
            value: value,
            modifier: modifier,
            options: options
        )
    }
    
    private init(
        keyPath: KeyPathType,
        comparisonOperator: NSComparisonPredicate.Operator,
        value: Any?,
        modifier: NSComparisonPredicate.Modifier = .direct,
        options: ComparisonPredicateOptions = []
    ) {
        self.keyPath = keyPath
        self.comparisonOperator = comparisonOperator
        self.value = value
        self.modifier = modifier
        
        let leftExpression: NSExpression
        switch keyPath {
        case .optional(let keyPathToOptionalValue):
            leftExpression = \Root.self == keyPathToOptionalValue
            ? NSExpression.expressionForEvaluatedObject()
            : NSExpression(forKeyPath: keyPathToOptionalValue)
        case .nonOptional(let keyPathToNonOptionalValue):
            leftExpression = \Root.self == keyPathToNonOptionalValue
            ? NSExpression.expressionForEvaluatedObject()
            : NSExpression(forKeyPath: keyPathToNonOptionalValue)
        }
        
        var rightExpression = NSExpression(forConstantValue: value)
        if rightExpression.constantValue == nil || rightExpression.constantValue is NSNull  {
            // For some reason, NSExpression(forConstantValue:) interprets Swift's
            // `nil` properly in the expression language, but bridges an `Any?` holding
            // Optional<Wrapped>.none to `NSNull`, which is represented as "<null>"
            // in the format string.
            //
            // Apparently, "<null>" is not a valid format string in the predicate
            // expression language. Here, we normalize the `NSNull` representation
            // to one which the predicate format string parser can understand.
            rightExpression = NSExpression(format: "nil")
        }
        
        super.init(
            leftExpression: leftExpression,
            rightExpression: rightExpression,
            modifier: modifier,
            type: comparisonOperator,
            options: Options(rawValue: options.rawValue)
        )
    }
    
    /// Sets the comparison options such as case-sensitivity on the predicate.
    ///
    /// - returns: a `ComparisonPredicate` with the comparison options set to the value you supply.
    public func withOptions(_ options: ComparisonPredicateOptions) -> ComparisonPredicate<Root, Value> {
        ComparisonPredicate(
            keyPath: keyPath,
            comparisonOperator: comparisonOperator,
            value: value,
            modifier: modifier,
            options: options
        )
    }
    
    @available(*, unavailable, message: "init(coder:) has not been implemented")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Comparison Predicate Options

/// Constants that describe the possible types of string comparison for comparison predicates.
/// Mirrors NSComparisonPredicate.Options
public struct ComparisonPredicateOptions: OptionSet {
    public typealias RawValue = NSComparisonPredicate.Options.RawValue
    public let rawValue: RawValue
    
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    public init(_ options: NSComparisonPredicate.Options) {
        self.init(rawValue: options.rawValue)
    }
    
    public static let caseInsensitive: ComparisonPredicateOptions = .init(.caseInsensitive)
    public static let diacriticInsensitive: ComparisonPredicateOptions = .init(.diacriticInsensitive)
    public static let c: ComparisonPredicateOptions = .init(.caseInsensitive)
    public static let d: ComparisonPredicateOptions = .init(.diacriticInsensitive)
    public static let cd: ComparisonPredicateOptions = .init([.c, .d])
}
