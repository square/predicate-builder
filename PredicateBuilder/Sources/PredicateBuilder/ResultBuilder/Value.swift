import CoreData
#if(canImport(PredicateBuilderCore))
import PredicateBuilderCore
#endif

/// A type that wraps a key path such that predicate operations may be performed on it.
///
/// Allows you to add modifiers since Swift's key path syntax otherwise will not let you call functions on a key path:
/// ```swift
/// Value(\Coffee.brandName)
///     .starts(with: "La")
///     .withOptions(.caseInsensitive)
/// ```
public struct Value<Root: NSManagedObject, WrappedValue> {
    public let keyPath: KeyPath<Root, WrappedValue>

    public init(_ keyPath: KeyPath<Root, WrappedValue>) {
        self.keyPath = keyPath
    }
    
    private func compare(
        _ value: WrappedValue?,
        using comparisonOperator: NSComparisonPredicate.Operator,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        ComparisonPredicate(keyPath, comparisonOperator, value, options: options)
    }
}

// MARK: - Basic Operators
// MARK: Equatable Operators
extension Value where WrappedValue: Equatable {
    var isNil: ComparisonPredicate<Root, WrappedValue> {
        ComparisonPredicate(keyPath, .equalTo, nil)
    }
    
    public func equals(
        _ value: WrappedValue?,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        compare(value, using: .equalTo, options: options)
    }
    
    public func notEqualTo(
        _ value: WrappedValue?,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        compare(value, using: .notEqualTo, options: options)
    }
}

// MARK: Comparable Operators
extension Value where WrappedValue: Comparable {
    public func lessThan(
        _ value: WrappedValue,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        compare(value, using: .lessThan, options: options)
    }
    
    public func lessThanOrEqualTo(
        _ value: WrappedValue,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        compare(value, using: .lessThanOrEqualTo, options: options)
    }
    
    public func greaterThan(
        _ value: WrappedValue,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        compare(value, using: .greaterThan, options: options)
    }
    
    public func greaterThanOrEqualTo(
        _ value: WrappedValue,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        compare(value, using: .greaterThanOrEqualTo, options: options)
    }
    
    public func between(
        _ range: ClosedRange<WrappedValue>,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        // NSComparisonPredicate represents ranges with an array in which the
        // first element represents the lower bound, and the second element
        // represents the upper bound, so we must convert our range appropriately
        let comparisonArray = [ range.lowerBound, range.upperBound ]
        return ComparisonPredicate(keyPath, .between, comparisonArray, options: options)
    }
}

// MARK: String Comparison Operators
extension Value where WrappedValue == String {
    /// `?` and `*` are allowed as wildcard characters. See the [Predicate Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795-215891) for more info,
    public func like(
        _ comparisonString: String,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        compare(comparisonString, using: .like, options: options)
    }
    
    /// Returns a predicate that evaluates to `true` when the evaluated `String` value starts with `possiblePrefix`
    public func begins(
        with possiblePrefix: String,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        compare(possiblePrefix, using: .beginsWith, options: options)
    }

    /// Returns a predicate that evaluates to `true` when the evaluated `String` value starts with `possiblePrefix`
    public func starts(
        with possiblePrefix: String,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        begins(with: possiblePrefix, options: options)
    }
    
    /// Returns a predicate that evaluates to `true` when the evaluated `String` value contains the `other` `String`
    public func contains(
        _ other: String,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        compare(other, using: .contains, options: options)
    }
    
    /// Returns a predicate that evaluates to `true` when the evaluated `String` value ends with the `other` `String`
    public func ends(
        with other: String,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        compare(other, using: .endsWith, options: options)
    }
}

extension Value where WrappedValue == String? {
    /// Returns a predicate with the `LIKE` String comparison.
    ///
    /// `?` and `*` are allowed as wildcard characters. See the [Predicate Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795-215891) for more info,
    public func like(
        _ comparisonString: String?,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        compare(comparisonString, using: .like, options: options)
    }
    
    /// Returns a predicate that evaluates to `true` when the evaluated `String` value starts with `possiblePrefix`
    public func begins(
        with possiblePrefix: String?,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        compare(possiblePrefix, using: .beginsWith, options: options)
    }
    
    /// Returns a predicate that evaluates to `true` when the evaluated `String` value starts with `possiblePrefix`
    public func starts(
        with possiblePrefix: String?,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        begins(with: possiblePrefix, options: options)
    }
    
    /// Returns a predicate that evaluates to `true` when the evaluated `String` value contains the `other` `String`
    public func contains(
        _ other: String?,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        compare(other, using: .contains, options: options)
    }
    
    /// Returns a predicate that evaluates to `true` when the evaluated `String` value ends with the `other` `String`
    public func ends(
        with other: String?,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        compare(other, using: .endsWith, options: options)
    }
}

// MARK: Aggregate Operations
extension Value {
    /// Returns a predicate that will evaluate to `true` if the value is contained in the given collection.
    public func `in`<CollectionType: Collection>(
        _ collection: CollectionType,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> where CollectionType.Element == WrappedValue {
        ComparisonPredicate(keyPath, .in, collection, options: options)
    }
    
    /// Returns a predicate that will evaluate to `true` if the value is contained in the given dictionary's values.
    ///
    /// This is a special case in Core Data: See the [Predicate Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795-215832) for more details.
    public func `in`<Key>(
        _ dictionary: Dictionary<Key, WrappedValue>,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, WrappedValue> {
        ComparisonPredicate(keyPath, .in, dictionary, options: options)
    }
}
