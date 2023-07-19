import CoreData
#if(canImport(PredicateBuilderCore))
import PredicateBuilderCore
#endif

/// The `NOT` operation.
public struct Not<RootType: NSManagedObject>: LogicalPredicate {
    public typealias Root = RootType
    
    public let values: [AnyTypedPredicate<Root>]
    public let operation: LogicalOperation = .not
    
    public init(values: [AnyTypedPredicate<Root>]) {
        self.values = values
    }
}
