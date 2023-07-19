import CoreData
#if(canImport(PredicateBuilderCore))
import PredicateBuilderCore
#endif

/// A predicate type that applies a logical operation to a set of other predicates.
public protocol LogicalPredicate: TypedPredicate where Root: NSManagedObject {
    typealias LogicalOperation = NSCompoundPredicate.LogicalType
    
    var values: [AnyTypedPredicate<Root>] { get }
    var operation: LogicalOperation { get }
    
    init(values: [AnyTypedPredicate<Root>])
}

public extension LogicalPredicate {
    init<PredicateType: TypedPredicate>(
        @PredicateBuilder<Root> values: @escaping () -> [PredicateType]
    ) where PredicateType.Root == Root {
        self.init(values: values().map { $0.eraseToAnyTypedPredicate() })
    }
    
    var predicate: NSPredicate {
        CompoundPredicate<Root>(type: operation, subpredicates: values.map(\.predicate))
    }
}
