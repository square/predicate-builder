import XCTest
@testable import PredicateBuilder
@testable import PredicateBuilderTestData

final class CollectionTests: XCTestCase {
    
    func test_givenContainsModifier_whenCollectionContainsWithPredicate_thenReturnTrue() {
        let targetSpaceshipNames = [ "Apollo 11", "Death Star" ]
        let predicate: NSPredicate = targetSpaceshipNames.contains(\Spaceship.name)
        let result: [Spaceship] = filterShips(with: predicate)
        
        XCTAssertEqual([.deathStar], result)
    }
    
    func test_givenContainsModifier_whenCollectionDoesNotContainWithPredicate_thenReturnFalse() {
        let targetSpaceshipNames = [ "Apollo 11", "Apollo 12" ]
        let predicate: NSPredicate = targetSpaceshipNames.contains(\Spaceship.name)
        let result: [Spaceship] = Spaceship.fictionalShips.filter(predicate.evaluate(with:))
        
        XCTAssertTrue(result.isEmpty)
    }
}
