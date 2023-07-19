import CoreData
import XCTest
@testable import PredicateBuilder
@testable import PredicateBuilderCore
@testable import PredicateBuilderTestData

final class CompositionTests: XCTestCase {
    
    func test_givenSomePredicates_whenCombinedIntoNewPredicate_thenResultIsCombinationOfPredicates() {
        @PredicateBuilder<Spaceship> var lhs: some TypedPredicate<Spaceship> {
            \.name == "Death Star"
        }
        
        @PredicateBuilder<Spaceship> var rhs: some TypedPredicate<Spaceship> {
            \Spaceship.fleetMembers == []
        }
        
        @PredicateBuilder<Spaceship> var result: NSPredicate {
            And {
                lhs
                rhs
            }
        }
        
        XCTAssertEqual(result.predicateFormat, #"name == "Death Star" AND fleetMembers == {}"#)
    }
    
    func test_givenAnyTypedPredicates_whenCombinedIntoNewPredicate_thenResultIsCombinationOfPredicates() {
        @PredicateBuilder<Spaceship> var lhs: AnyTypedPredicate<Spaceship> {
            \.name == "Death Star"
        }
        
        @PredicateBuilder<Spaceship> var rhs: AnyTypedPredicate<Spaceship> {
            \Spaceship.fleetMembers == []
        }
        
        @PredicateBuilder<Spaceship> var result: NSPredicate {
            And {
                lhs
                rhs
            }
        }
        
        XCTAssertEqual(result.predicateFormat, #"name == "Death Star" AND fleetMembers == {}"#)
    }
}
