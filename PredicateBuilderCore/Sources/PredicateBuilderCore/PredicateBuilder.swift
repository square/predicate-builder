import CoreData

/// - Tag: PredicateBuilder
@resultBuilder
public struct PredicateBuilder<Root: NSManagedObject> {
    
    // MARK: - Basic Blocks & Block Composition
    // buildPartialBlock allows blocks to be composed of multiple expressions.
    // Under the hood, the result builder transform will turn components in a
    // block into a series of calls to buildPartialBlock, combining components
    // from top to bottom.
    //
    // See more: https://github.com/apple/swift-evolution/blob/main/proposals/0348-buildpartialblock.md#proposed-solution
    
    public static func buildPartialBlock(
        first: AnyTypedPredicate<Root>
    ) -> [AnyTypedPredicate<Root>] {
        [first]
    }
    
    public static func buildPartialBlock(
        first: [AnyTypedPredicate<Root>]
    ) -> [AnyTypedPredicate<Root>] {
        first
    }
    
    public static func buildPartialBlock(
        accumulated: [AnyTypedPredicate<Root>],
        next: AnyTypedPredicate<Root>
    ) -> [AnyTypedPredicate<Root>] {
        var result = accumulated
        result.append(next)
        return result
    }
    
    public static func buildPartialBlock(
        accumulated: [AnyTypedPredicate<Root>],
        next: [AnyTypedPredicate<Root>]
    ) -> [AnyTypedPredicate<Root>] {
        var result = accumulated
        result.append(contentsOf: next)
        return result
    }
    
    // MARK: - Expressions
    
    // buildExpression(_:) allows the builder to lift other expression types into
    // the Component type needed to construct the final result. It exists primarily
    // to disambiguate between KeyPath<Root, Bool> sugar and the comparison operators,
    // allowing both to be represented in the DSL.
    public static func buildExpression<PredicateType: TypedPredicate>(
        _ predicate: PredicateType
    ) -> [AnyTypedPredicate<Root>] where PredicateType.Root == Root {
        [ predicate.eraseToAnyTypedPredicate() ]
    }
    
    // Since ``ComparisonPredicate`` is directly constrained to our Root type, this
    // buildExpression implementation allows the result builder to infer the root
    // type very easily--speeding up expresssion evaluation times and allowing for
    // expressive syntax like dropping the leading type name
    public static func buildExpression<Value>(
        _ predicate: ComparisonPredicate<Root, Value>
    ) -> [AnyTypedPredicate<Root>] {
        [ predicate.eraseToAnyTypedPredicate() ]
    }
    
    // MARK: - Control Flow
    
    // MARK: if, else, switch partial results
    
    public static func buildEither(
        first component: [AnyTypedPredicate<Root>]
    ) -> [AnyTypedPredicate<Root>] {
        component
    }
    public static func buildEither(
        second component: [AnyTypedPredicate<Root>]
    ) -> [AnyTypedPredicate<Root>] {
        component.map { $0.eraseToAnyTypedPredicate() }
    }
    
    // MARK: Standalone if partial result
    // buildOptional(_:) builds a block if its outer control flow succeeds. For example,
    //
    // if true {
    //     component // <-- this line is returned since the check succeeded
    // }
    //
    // If the condition evaluates to false, `nil` is returned.
    public static func buildOptional(
        _ component: [AnyTypedPredicate<Root>]?
    ) -> [AnyTypedPredicate<Root>] {
        if let component {
            return component.map { $0.eraseToAnyTypedPredicate() }
        }
        
        return []
    }
    
    // MARK: Array partial results
    public static func buildArray(
        _ components: [[AnyTypedPredicate<Root>]]
    ) -> [AnyTypedPredicate<Root>] {
        components
            .flatMap { $0 }
            .map { $0.eraseToAnyTypedPredicate() }
    }
    
    // MARK: - Final Results
    // The predicate builder supports two final result types:
    // an array of AnyTypedPredicate, or an NSPredicate. The array is utilized
    // by the DSL builder types such as And, Or, Not, etc. to combine their
    // subpredicates
    
    public static func buildFinalResult(
        _ components: [AnyTypedPredicate<Root>]
    ) -> [AnyTypedPredicate<Root>] {
        components.map { AnyTypedPredicate<Root>(format: $0.predicate.predicateFormat) }
    }
    
    public static func buildFinalResult(
        _ components: [AnyTypedPredicate<Root>]
    ) -> AnyTypedPredicate<Root> {
        CompoundPredicate(type: .and, subpredicates: components.map(\.predicate))
            .eraseToAnyTypedPredicate()
    }
}

// MARK: - Sugar for keypaths with a Boolean value

extension PredicateBuilder {
    public static func buildExpression(
        _ keyPath: KeyPath<Root, Bool>
    ) -> [AnyTypedPredicate<Root>] {
        [ComparisonPredicate<Root, Bool>(keyPath, .equalTo, true).eraseToAnyTypedPredicate()]
    }
}

// MARK: - Unavailable + custom error messages
extension PredicateBuilder {
    @available(*, unavailable, message:
    """
    Generic parameter 'Root' cannot be inferred.
    
    Swift is trying to infer 'Root' to be of type 'NSmanagedObject', which would
    break the builder's type safety. Please provide the compiler more context to
    restore the correct type inference.
    """)
    public static func buildExpression<PredicateType: TypedPredicate>(
        _ predicate: PredicateType
    ) -> [AnyTypedPredicate<Root>] where Root == NSManagedObject {
        fatalError("The compiler should not have allowed \(#function) to be called!")
    }
}

#if swift(>=5.9)
@available(iOS 17.0, macOS 14.0, *)
extension PredicateBuilder {
    @available(*, unavailable, message:
    """
    Cannot use Foundation.Predicate type in PredicateBuilder.
    
    The Predicate type does not guarantee enough type safety when converting to NSPredicate. Please
    use one of the Predicate types provided by the PredicateBuilder instead.
    """)
    public static func buildExpression(
        _ foundationPredicate: Foundation.Predicate<Root>
    ) -> [AnyTypedPredicate<Root>]  {
        []
    }
}
#endif
