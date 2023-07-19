import XCTest
@testable import PredicateBuilderTestData

extension XCTestCase {
    func filterShips(
        _ ships: [Spaceship] = Spaceship.fictionalShips,
        with predicate: NSPredicate
    ) -> [Spaceship] {
        ships.filter(predicate.evaluate(with:))
    }
}
