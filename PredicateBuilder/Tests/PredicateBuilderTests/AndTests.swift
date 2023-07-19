import XCTest
@testable import PredicateBuilder
@testable import PredicateBuilderCore
@testable import PredicateBuilderTestData

final class AndTests: XCTestCase {
    
    func test_givenAndPredicate_whenAllValuesAreTrue_thenReturnTrue() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            And {
                \Spaceship.name == Spaceship.tardis.name
                \Spaceship.shipDescription == Spaceship.tardis.shipDescription
                \Spaceship.cost == Spaceship.tardis.cost
            }
        }
        let result = filterShips(with: predicate)
        XCTAssertEqual([.tardis], result)
    }
    
    func test_givenAndPredicate_whenAnyValueIsNotTrue_thenReturnFalse() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            And {
                \Spaceship.name == Spaceship.tardis.name
                \Spaceship.name == "no spaceship has this name"
            }
        }
        let result = filterShips(with: predicate)
        XCTAssertTrue(result.isEmpty)
    }
}
