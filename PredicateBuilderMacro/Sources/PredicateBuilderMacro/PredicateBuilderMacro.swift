#if swift(>=5.9)
import CoreData
import PredicateBuilderCore

/// A macro which takes a generic `PredicateBuilder` and expands
/// it to a closure that declares the property-wrapped variable, builds the result,
/// and returns the final value. For example,
///
///     fetchRequest.Predicate = #PredicateBuilder<Candy> {
///         \.isSweet
///     }
///
/// expands to:
///
///     {
///        @PredicateBuilder var <uniquelyNamedVar>: AnyTypedPredicate<Spaceship> {
///            \.isSweet
///        }
///
///        return <uniquelyNamedVar>
///     }()
@freestanding(expression)
public macro PredicateBuilder<Root: NSManagedObject>(
    @PredicateBuilder<Root> body: @escaping () -> AnyTypedPredicate<Root>
) -> AnyTypedPredicate<Root> = #externalMacro(module: "PredicateBuilderMacroMacros", type: "PredicateBuilderMacro")
#endif
