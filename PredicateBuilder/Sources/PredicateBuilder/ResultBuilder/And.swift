import CoreData
#if(canImport(PredicateBuilderCore))
import PredicateBuilderCore
#endif

/// The `AND` operation.
public struct And<RootType: NSManagedObject>: LogicalPredicate {
    public typealias Root = RootType
    
    public let values: [AnyTypedPredicate<Root>]
    public let operation: LogicalOperation = .and

    public init(values: [AnyTypedPredicate<Root>]) {
        self.values = values
    }
}
