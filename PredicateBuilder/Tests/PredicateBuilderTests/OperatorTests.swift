import XCTest
@testable import PredicateBuilder
@testable import PredicateBuilderCore
@testable import PredicateBuilderTestData

final class OperatorTests: XCTestCase {
    
    // MARK: - Equality Operators
    
    func test_equalityOperator() {
        let predicate = \Spaceship.cost == 42
        XCTAssertEqual(predicate.predicateFormat, "cost == 42")
    }
    
    func test_InequalityOperator() {
        let predicate = \Spaceship.cost != 42
        XCTAssertEqual(predicate.predicateFormat, "cost != 42")
    }
    
    func test_LessThanOperator() {
        let predicate = \Spaceship.cost < 42
        XCTAssertEqual(predicate.predicateFormat, "cost < 42")
    }
    
    func test_LessThanOrEqualToOperator() {
        let predicate = \Spaceship.cost <= 42
        XCTAssertEqual(predicate.predicateFormat, "cost <= 42")
    }
    
    func test_greaterThanOperator() {
        let predicate = \Spaceship.cost > 42
        XCTAssertEqual(predicate.predicateFormat, "cost > 42")
    }
    
    func test_greatherThanOrEqualToOperator() {
        let predicate = \Spaceship.cost >= 42
        XCTAssertEqual(predicate.predicateFormat, "cost >= 42")
    }
    
    // MARK: - Compound Operators
    
    func test_AndOperator() {
        let predicate = \Spaceship.name == "The Heart of Gold" && \Spaceship.cost > 0
        XCTAssertEqual(
            predicate.predicateFormat,
            #"name == "The Heart of Gold" AND cost > 0"#
        )
    }
    
    func test_OrOperator() {
        let predicate = \Spaceship.name == "The Heart of Gold" || \Spaceship.cost > 0
        XCTAssertEqual(
            predicate.predicateFormat,
            #"name == "The Heart of Gold" OR cost > 0"#
        )
    }
    
    func test_notOperator() {
        let predicate = !(\Spaceship.cost > 0)
        XCTAssertEqual(predicate.predicateFormat, "NOT cost > 0")
    }
}
