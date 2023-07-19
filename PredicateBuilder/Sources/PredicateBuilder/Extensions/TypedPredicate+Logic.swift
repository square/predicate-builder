#if canImport(PredicateBuilderCore)
import PredicateBuilderCore
#endif

extension TypedPredicate {
    public func and<Other: TypedPredicate>(
        @PredicateBuilder<Root> otherPredicate: @escaping () -> Other
    ) -> And<Root> where Other.Root == Root {
        and(otherPredicate())
    }
    
    public func and<Other: TypedPredicate>(
        _ otherPredicate: Other
    ) -> And<Root> where Other.Root == Root {
        And {
            self
            otherPredicate
        }
    }
    
    public func or<Other: TypedPredicate>(
        @PredicateBuilder<Root> otherPredicate: @escaping () -> Other
    ) -> Or<Root> where Other.Root == Root {
        or(otherPredicate())
    }
    
    public func or<Other: TypedPredicate>(
        _ otherPredicate: Other
    ) -> Or<Root> where Other.Root == Root {
        Or {
            self
            otherPredicate
        }
    }
}
