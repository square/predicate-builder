import XCTest
@testable import PredicateBuilder
@testable import PredicateBuilderCore
@testable import PredicateBuilderTestData

final class NoMembersTests: XCTestCase {
    let motherShip: Spaceship = Spaceship(
        name: "Mother ship",
        cost: 0,
        fleetMembers: [.tardis, .deathStar, .tieFighter],
        enemies: [.xWing]
    )
    lazy var fleet: [Spaceship] = [
        .tieFighter,
        .deathStar,
        .tardis,
        motherShip
    ]

    func test_givenNoMembersPredicate_whenAnyCollectionMembersSatisfyPredicate_thenReturnFalse() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            NoMembers(of: \Spaceship.fleetMembers) {
                \.name == "TIE fighter"
            }
        }

        XCTAssertEqual(predicate.predicateFormat, #"NOT ANY fleetMembers.name == "TIE fighter""#)

        let nonePredicate = NSPredicate(
            format: #"NONE fleetMembers.name == %@"#,
            "TIE fighter"
        )
        let nonePredicateResult = filterShips(fleet, with: nonePredicate)
        let noMembersResult = filterShips(fleet, with: predicate)

        XCTAssertEqual(noMembersResult, nonePredicateResult)
    }

    func test_givenNoMembersPredicate_whenNoCollectionMembersSatisfyPredicate_thenReturnTrue() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            NoMembers(of: \Spaceship.fleetMembers, \.isReal == true)
        }

        XCTAssertEqual(predicate.predicateFormat, #"NOT ANY fleetMembers.isReal == 1"#)


        let nonePredicate = NSPredicate(format: #"NONE fleetMembers.isReal == TRUE"#)
        let nonePredicateResult = filterShips(fleet, with: nonePredicate)
        let noMembersResult = filterShips(fleet, with: predicate)

        XCTAssertEqual(noMembersResult, nonePredicateResult)
    }

    func test_givenOptionalNoMembersPredicate_whenAnyCollectionMembersSatisfyPredicate_thenReturnFalse() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            NoMembers(of: \Spaceship.enemies) {
                \.name == "X-Wing"
            }
        }

        XCTAssertEqual(predicate.predicateFormat, #"NOT ANY enemies.name == "X-Wing""#)

        let nonePredicate = NSPredicate(
            format: "NONE enemies.name == %@",
            "X-Wing"
        )
        let nonePredicateResult = filterShips(fleet, with: nonePredicate)
        let noMembersResult = filterShips(fleet, with: predicate)

        XCTAssertEqual(noMembersResult, nonePredicateResult)
    }
}
