import CoreData
#if(canImport(PredicateBuilderCore))
import PredicateBuilderCore
#endif

extension Collection {
    /// Returns a predicate that returns `true` when the collection contains the value referred to
    /// by the `keyPath`.
    ///
    /// - parameter keyPath: the key path of the root type to compare pointing to the value to compare
    /// - returns: A `ComparisonPredicate` using the `IN` operator.
    public func contains<Root: NSManagedObject, Value>(
        _ keyPath: KeyPath<Root, Value>,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, Value> where Value == Element
    {
        ComparisonPredicate(keyPath, .in, self, options: options)
    }
    
    /// Returns a predicate that returns `true` when the collection contains the value referred to
    /// by the `keyPath`.
    ///
    /// - parameter keyPath: the key path of the root type to compare pointing to an optional value to compare
    /// - returns: A `ComparisonPredicate` using the `IN` operator.
    public func contains<Root: NSManagedObject, Value>(
        _ keyPath: KeyPath<Root, Value?>,
        options: ComparisonPredicateOptions = []
    ) -> ComparisonPredicate<Root, Value?> where Value == Element
    {
        ComparisonPredicate(keyPath, .in, self, options: options)
    }
}
