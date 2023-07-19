import CoreData
#if(canImport(PredicateBuilderCore))
import PredicateBuilderCore
#endif

/// The `NONE` operation. Equivalent to `NOT(ANY ...)`
public typealias NoMembers = None

/// The `NONE` operation. Equivalent to `NOT(ANY ...)`
public struct None<
    CollectionRoot,
    CollectionType: Collection,
    Value
>: TypedPredicate where CollectionRoot: NSManagedObject, CollectionType.Element: NSManagedObject {
    public typealias Root = CollectionRoot
    public typealias PredicateType = ComparisonPredicate<CollectionType.Element, Value>
    public let predicate: NSPredicate

    public init(
        of collectionKeyPath: KeyPath<CollectionRoot, CollectionType?>,
        _ wrappedPredicate: PredicateType
    ) {
        self.init(collectionKeyPath, wrappedPredicate: wrappedPredicate)
    }

    public init(
        of collectionKeyPath: KeyPath<CollectionRoot, CollectionType?>,
        where wrappedPredicate: @escaping () -> PredicateType
    ) {
        self.init(collectionKeyPath, wrappedPredicate: wrappedPredicate())
    }

    public init(
        of collectionKeyPath: KeyPath<CollectionRoot, CollectionType>,
        _ wrappedPredicate: PredicateType
    ) {
        self.init(collectionKeyPath, wrappedPredicate: wrappedPredicate)
    }

    public init(
        of collectionKeyPath: KeyPath<CollectionRoot, CollectionType>,
        where wrappedPredicate: @escaping () -> PredicateType
    ) {
        self.init(collectionKeyPath, wrappedPredicate: wrappedPredicate())
    }

    // Until Swift supports a mechanism to "erase" a key path value's optionality,
    // We have to handle key paths to optional and non-optional values explicitly.
    // See: https://forums.swift.org/t/keypath-t-u-required-but-i-only-have-keypath-t-u/15468

    private init<KeyPathRoot, KeyPathValue>(
        _ keyPath: KeyPath<KeyPathRoot, KeyPathValue>,
        wrappedPredicate: PredicateType
    ) {
        let keyPathString = NSExpression(forKeyPath: keyPath).keyPath
        let formatString = wrappedPredicate.predicateFormat
        self.predicate = NSComparisonPredicate(format: "NONE \(keyPathString).\(formatString)")
    }
}
