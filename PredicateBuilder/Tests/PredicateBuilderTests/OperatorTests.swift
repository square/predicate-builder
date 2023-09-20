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
    
    // MARK: - Comparison to nil
    
    func test_givenOperator_whenKeyPathValueIsOptional_thenPredicateExpressionIsValid() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            \Spaceship.fleetMembers == nil
            \Spaceship.fleetMembers != nil
        }
        
        XCTAssertEqual(predicate.predicateFormat, "fleetMembers == nil AND fleetMembers != nil")
    }
    
    // This case is distinct to the one above due to the way Foundation's format
    // string parser represents "nil" and an `Any?` holding an `Optional<Wrapped>.none`
    func test_givenBuilder_whenComparisonIsToOptionalNone_thenBuilderBridgesNilToPredicateString() {
        let nilShips: Set<Spaceship>? = nil
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            \Spaceship.fleetMembers == nilShips
            \Spaceship.fleetMembers != nilShips
        }
        XCTAssertEqual(predicate.predicateFormat, "fleetMembers == nil AND fleetMembers != nil")
    }
}
