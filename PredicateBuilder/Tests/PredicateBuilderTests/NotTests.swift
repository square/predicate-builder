import XCTest
@testable import PredicateBuilder
@testable import PredicateBuilderCore
@testable import PredicateBuilderTestData

final class NotTests: XCTestCase {

    func test_givenFalse_whenNotPredicateIsApplied_thenReturnTrue() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            Not {
                \Spaceship.isReal == true
            }
        }

        let result = filterShips(Spaceship.fictionalShips, with: predicate)
        XCTAssertEqual(predicate.predicateFormat, "NOT isReal == 1")
        XCTAssertEqual(result, Spaceship.fictionalShips)
    }

    func test_givenTrue_whenNotPredicateIsApplied_thenReturnFalse() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            Not {
                \Spaceship.isReal == false
            }
        }

        let result = filterShips(with: predicate)
        XCTAssertEqual(predicate.predicateFormat, "NOT isReal == 0")
        XCTAssertTrue(result.isEmpty)
    }

    func test_givenCompoundPredicate_whenNotPredicateIsApplied_thenNotWrapsEntireCompoundPredicate() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            Not {
                Or {
                    \Spaceship.isReal == false
                    \Spaceship.name == "The Reaver Ship"
                }
            }
        }

        let result = filterShips(with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"NOT (isReal == 0 OR name == "The Reaver Ship")"#)
        XCTAssertTrue(result.isEmpty)
    }
}
