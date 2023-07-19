#if swift(>=5.9)
import CoreData
import PredicateBuilderMacro
import PredicateBuilderCore
import PredicateBuilderTestData

let fetchRequest = NSFetchRequest<Spaceship>()

// Valid, but verbose. Takes 2 steps: declaration and assignment.
@PredicateBuilder<Spaceship> var verboselyDeclaredPredicate: AnyTypedPredicate<Spaceship> {
    \.isReal
}
fetchRequest.predicate = verboselyDeclaredPredicate

print("Verbose builder predicate format string: '\(fetchRequest.predicate!.predicateFormat)'")


// Macr-ohmygosh.
fetchRequest.predicate = #PredicateBuilder<Spaceship> {
    \.isReal
}

print("Macro predicate format string: '\(fetchRequest.predicate!.predicateFormat)'")


// Custom Compiler Error: #PredicateBuilder must be specialized with a generic type
//fetchRequest.predicate = #PredicateBuilder {
//    \Spaceship.name == "TARDIS"
//}
#endif
