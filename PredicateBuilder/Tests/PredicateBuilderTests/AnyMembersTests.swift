import XCTest
@testable import PredicateBuilder
@testable import PredicateBuilderCore
@testable import PredicateBuilderTestData

final class AnyMembersTests: XCTestCase {
    let motherShip: Spaceship = Spaceship(
        name: "Mother ship",
        cost: 0,
        fleetMembers: [.tardis, .deathStar, .tieFighter]
    )
    lazy var fleet: [Spaceship] = [
        .tieFighter,
        .deathStar,
        .tardis,
        motherShip
    ]

    // Note: The `AnyMembers` type can be tricky to think of in an array context
    // vs. a Core Data context. In these tests, we are filtering an NSArray given
    // a predicate, and we are testing `AnyMembers` on a Spaceship's properties
    // properties, not the "fleet" collection itself.
    func test_givenAnyPredicate_whenAnyCollectionMembersSatisfyPredicate_thenReturnAllCollectionMembers() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            AnyMembers(of: \Spaceship.fleetMembers) {
                \.name == "TIE fighter"
            }
        }

        let result = filterShips(fleet, with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"ANY fleetMembers.name == "TIE fighter""#)
        XCTAssertEqual(result, [.deathStar, motherShip])
    }

    func test_givenAnyPredicate_whenNoCollectionMembersSatisfyPredicate_thenReturnNoMembers() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            AnyMembers(of: \Spaceship.fleetMembers, \.isReal == true)
        }

        let result = filterShips(fleet, with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"ANY fleetMembers.isReal == 1"#)
        XCTAssertTrue(result.isEmpty)
    }

    func test_givenAnyPredicateWithNonOptionalCollection_whenAnyCollectionMembersSatisfyPredicate_thenReturnAllCollectionMembers() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            AnyMembers(of: \Spaceship.fleetMembers) {
                \.name == "Death Star"
            }
        }

        let result = filterShips(fleet, with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"ANY fleetMembers.name == "Death Star""#)
        XCTAssertEqual(result, [motherShip])
    }

    func test_givenAnyPredicateWithNonOptionalCollection_whenNoCollectionMembersSatisfyPredicate_thenReturnNoMembers() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            AnyMembers(of: \Spaceship.enemies) {
                \.name == "A goofy spaceship name"
            }
        }

        let result = filterShips(fleet, with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"ANY enemies.name == "A goofy spaceship name""#)
        XCTAssertTrue(result.isEmpty)
    }
}
