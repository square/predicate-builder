import CoreData

// MARK: - Basic Operators
// See: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795-215891

public extension KeyPath where Root: NSManagedObject, Value: Equatable {
    static func == (
        keyPath: KeyPath<Root, Value>,
        value: Value?
    ) -> ComparisonPredicate<Root, Value> {
        compare(keyPath, value, using: .equalTo)
    }
    
    static func != (
        keyPath: KeyPath<Root, Value>,
        value: Value?
    ) -> ComparisonPredicate<Root, Value> {
        compare(keyPath, value, using: .notEqualTo)
    }
}

public extension KeyPath where Root: NSManagedObject, Value: Comparable {
    static func < (
        keyPath: KeyPath<Root, Value>,
        value: Value
    ) -> ComparisonPredicate<Root, Value> {
        compare(keyPath, value, using: .lessThan)
    }
    
    static func <= (
        keyPath: KeyPath<Root, Value>,
        value: Value
    ) -> ComparisonPredicate<Root, Value> {
        compare(keyPath, value, using: .lessThanOrEqualTo)
    }
    
    static func > (
        keyPath: KeyPath<Root, Value>,
        value: Value
    ) -> ComparisonPredicate<Root, Value> {
        compare(keyPath, value, using: .greaterThan)
    }
    
    static func >= (
        keyPath: KeyPath<Root, Value>,
        value: Value
    ) -> ComparisonPredicate<Root, Value> {
        compare(keyPath, value, using: .greaterThanOrEqualTo)
    }
}

private func compare<Value, Root, KeyPathType>(
    _ keyPath: KeyPathType,
    _ value: Value?,
    using comparisonOperator: NSComparisonPredicate.Operator
) -> ComparisonPredicate<Root, Value> where Root: NSManagedObject, KeyPathType: KeyPath<Root, Value> {
    ComparisonPredicate(keyPath, comparisonOperator, value, options: [])
}

// MARK: - Compound Operators

public extension TypedPredicate {
    static func && <RHSType>(
        lhs: Self,
        rhs: RHSType
    ) -> CompoundPredicate<Root> where RHSType: TypedPredicate, Root == RHSType.Root {
        evaluate([lhs, rhs], using: .and)
    }
    
    static func || <RHSType>(
        lhs: Self,
        rhs: RHSType
    ) -> CompoundPredicate<Root> where RHSType: TypedPredicate, Root == RHSType.Root {
        evaluate([lhs, rhs], using: .or)
    }
    
    static prefix func ! (predicate: Self) -> CompoundPredicate<Root> {
        evaluate([predicate], using: .not)
    }
    
    private static func evaluate(
        _ array: [any TypedPredicate],
        using logicalOperator: NSCompoundPredicate.LogicalType
    ) -> CompoundPredicate<Root> {
        CompoundPredicate(type: logicalOperator, subpredicates: array.map(\.predicate))
    }
}


// MARK: - Availability hints
// These overloads contain more helpful error messages than the ones the compiler
// generates by default.

public extension KeyPath where Root: NSManagedObject, Value: Equatable {
    @available(*, unavailable, message: "Cannot compare right hand operand type that does not match key path's `Value` type")
    static func == <IncomparableValue>(
        keyPath: KeyPath<Root, Value>,
        value: IncomparableValue
    ) -> ComparisonPredicate<Root, Value> {
        fatalError("The compiler should not have allowed \(#function) to be called!")
    }
    
    @available(*, unavailable, message: "Cannot compare right hand operand type that does not match key path's `Value` type")
    static func != <IncomparableValue>(
        keyPath: KeyPath<Root, Value>,
        value: IncomparableValue
    ) -> ComparisonPredicate<Root, Value> {
        fatalError("The compiler should not have allowed \(#function) to be called!")
    }
}

public extension KeyPath where Root: NSManagedObject, Value: Comparable {
    
    @available(*, unavailable, message: "Cannot compare right hand operand type that does not match key path's `Value` type")
    static func < <IncomparableValue>(
        keyPath: KeyPath<Root, Value>,
        value: IncomparableValue
    ) -> ComparisonPredicate<Root, Value> {
        fatalError("The compiler should not have allowed \(#function) to be called!")
    }
    
    @available(*, unavailable, message: "Cannot compare right hand operand type that does not match key path's `Value` type")
    static func <= <IncomparableValue>(
        keyPath: KeyPath<Root, Value>,
        value: IncomparableValue
    ) -> ComparisonPredicate<Root, Value> {
        fatalError("The compiler should not have allowed \(#function) to be called!")
    }
    
    @available(*, unavailable, message: "Cannot compare right hand operand type that does not match key path's `Value` type")
    static func > <IncomparableValue>(
        keyPath: KeyPath<Root, Value>,
        value: IncomparableValue
    ) -> ComparisonPredicate<Root, Value> {
        fatalError("The compiler should not have allowed \(#function) to be called!")
    }
    
    @available(*, unavailable, message: "Cannot compare right hand operand type that does not match key path's `Value` type")
    static func >= <IncomparableValue>(
        keyPath: KeyPath<Root, Value>,
        value: IncomparableValue
    ) -> ComparisonPredicate<Root, Value> {
        fatalError("The compiler should not have allowed \(#function) to be called!")
    }
}
