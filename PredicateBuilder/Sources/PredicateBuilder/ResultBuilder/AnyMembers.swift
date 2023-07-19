import CoreData
#if(canImport(PredicateBuilderCore))
import PredicateBuilderCore
#endif

/// The `SOME` operation.
public typealias SomeMembers = AnyMembers

/// The `ANY` operation.
public struct AnyMembers<
    CollectionRoot,
    CollectionType: Collection,
    Value
>: TypedPredicate where CollectionRoot: NSManagedObject, CollectionType.Element: NSManagedObject {
    public typealias Root = CollectionRoot
    public typealias PredicateType = ComparisonPredicate<CollectionType.Element, Value>
    
    // This is less than ideal, however it seems that Swift does not currently
    // support a mechanism to "erase" a key path value's optionality. See:
    // https://forums.swift.org/t/keypath-t-u-required-but-i-only-have-keypath-t-u/15468
    private enum CollectionKeyPathType {
        case optional(KeyPath<CollectionRoot, CollectionType?>)
        case nonOptional(KeyPath<CollectionRoot, CollectionType>)
    }
    
    private let collectionKeyPath: CollectionKeyPathType
    private let wrappedPredicate: PredicateType

    public var predicate: NSPredicate {
        // TODO: See if a Core Data one-to-many relationship's KeyPath can be represented by a Swift KeyPath
        // The String-based NSExpression can reference members in a one-to-many
        // relationship by a "key path" syntax like "employees.name"
        // where a member in that syntax may be an item in a collection.
        // Attempting to reference this in Swift does not work, as the Swift
        // KeyPath attempts to operate on the Collection, rather than mapping
        // the KeyPath to its elements,
        // e.g. Attempting to query employee names:
        // \Company.employees.name yields "Array<Employee> has no member 'name'"
        //
        // The `AnyMembers` type is still preferred because it ensures that the types
        // queried and the value compared against match the types in the collection.
        let collectionKeyPathString: String
        switch collectionKeyPath {
        case .optional(let keyPath):
            collectionKeyPathString = NSExpression(forKeyPath: keyPath).keyPath
        case .nonOptional(let keyPath):
            collectionKeyPathString = NSExpression(forKeyPath: keyPath).keyPath
        }
        
        return NSComparisonPredicate(format: "ANY \(collectionKeyPathString).\(wrappedPredicate.predicateFormat)")
    }
    
    public init(
        of collectionKeyPath: KeyPath<CollectionRoot, CollectionType?>,
        _ predicate: PredicateType
    ) {
        self.collectionKeyPath = .optional(collectionKeyPath)
        self.wrappedPredicate = predicate
    }

    public init(
        of collectionKeyPath: KeyPath<CollectionRoot, CollectionType?>,
        where predicate: @escaping () -> PredicateType
    ) {
        self.collectionKeyPath = .optional(collectionKeyPath)
        self.wrappedPredicate = predicate()
    }
    
    public init(
        of collectionKeyPath: KeyPath<CollectionRoot, CollectionType>,
        _ predicate: PredicateType
    ) {
        self.collectionKeyPath = .nonOptional(collectionKeyPath)
        self.wrappedPredicate = predicate
    }
    
    public init(
        of collectionKeyPath: KeyPath<CollectionRoot, CollectionType>,
        where predicate: @escaping () -> PredicateType
    ) {
        self.collectionKeyPath = .nonOptional(collectionKeyPath)
        self.wrappedPredicate = predicate()
    }
}
