# CompilationTests

This package contains code that, when the PredicateBuilder is working as-intended, should not compile. It exists separately from the package's tests since the code needs to not compile in order to be correct. 

## Why is this needed?
Swift is smart. When the type constraints specified by the result builder are not tight enough, Swift will infer the generic type of the predicate builder to be of type `NSObject`. Normally, type inference is wonderful, but in this case, we want to ensure that we constrain things more tightly. This is because NSPredicate crashes at runtime when predicates aren't constructed correctly--and this library aims to define away those problem areas using Swift's type system
