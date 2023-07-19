import CoreData
#if(canImport(PredicateBuilderCore))
import PredicateBuilderCore
#endif

/// The `OR` operation.
public struct Or<RootType: NSManagedObject>: LogicalPredicate {
    public typealias Root = RootType
    
    public let values: [AnyTypedPredicate<Root>]
    public let operation: LogicalOperation = .or
    
    public init(values: [AnyTypedPredicate<Root>]) {
        self.values = values
    }
}
