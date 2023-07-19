import XCTest
@testable import PredicateBuilder
@testable import PredicateBuilderCore
@testable import PredicateBuilderTestData

final class ValueTests: XCTestCase {
    
    // MARK: - Basic operator tests
    
    func test_givenNilModifer_whenValueIsNil_thenReturnTrue() {
        @PredicateBuilder<Spaceship> var isNilPredicate: NSPredicate {
            Value(\Spaceship.shipDescription).isNil
        }
        
        let filteredShips = filterShips(with: isNilPredicate)
        XCTAssertEqual(filteredShips.count, 1)
        XCTAssertEqual(filteredShips.first, .deathStar)
    }
    
    // MARK: Equality tests
    
    func test_givenEqualsModifier_whenValuesAreEqual_thenReturnTrue() {
        @PredicateBuilder<Spaceship> var equalsPredicate: NSPredicate {
            Value(\Spaceship.cost).equals(1_000_000_000)
                .and(Value(\Spaceship.name).equals("Death Star"))
                .and(Value(\Spaceship.shipDescription).equals(nil))
        }

        // Should we test the behavior, or both the behavior and the
        // resulting strings created by the builder?
        XCTAssertEqual(
            equalsPredicate.predicateFormat,
            #"cost == 1000000000 AND name == "Death Star" AND shipDescription == nil"#
        )

        let filteredShips = filterShips(with: equalsPredicate)
        XCTAssertEqual(filteredShips.count, 1)
    }
    
    func test_givenEqualsModifier_whenValuesAreNotEqual_thenReturnFalse() {
        let equalsPredicate = Value(\Spaceship.cost).equals(-500)
        let filteredShips = filterShips(with: equalsPredicate)
        XCTAssertEqual(filteredShips.count, 0)
    }
    
    func test_givenNotEqualsModifier_whenValuesAreNotEqual_thenReturnTrue() {
        let notEqualsPredicate = Value(\Spaceship.cost).notEqualTo(-500)
        let filteredShips = filterShips(with: notEqualsPredicate)
        XCTAssertEqual(filteredShips.count, Spaceship.fictionalShips.count)
    }
    
    func test_givenNotEqualsModifier_whenValuesAreEqual_thenReturnFalse() {
        @PredicateBuilder<Spaceship> var notEqualsPredicate: NSPredicate {
            And {
                Value(\Spaceship.cost).notEqualTo(Spaceship.tardis.cost)
                Value(\Spaceship.name).notEqualTo("Death Star")
            }
        }
        let filteredShips = filterShips(with: notEqualsPredicate)
        XCTAssertEqual(filteredShips.count, 0)
    }
    
    // MARK: - Compound operator tests
    
    func test_givenLessThanModifier_whenValueIsLessThanRightHandSide_thenReturnTrue() {
        let predicate = Value(\Spaceship.cost).lessThan(Spaceship.tardis.cost + 1)
        let filteredShips = filterShips(with: predicate)
        XCTAssertEqual(filteredShips.count, 1)
        XCTAssertEqual([Spaceship.tardis], filteredShips)
    }
    
    func test_givenLessThanOrEqualToModifier_whenValueIsLessThanOrEqualToRightHandSide_thenReturnTrue() {
        let predicate = Value(\Spaceship.cost).lessThanOrEqualTo(Spaceship.tardis.cost)
        let filteredShips = filterShips(with: predicate)
        XCTAssertEqual(filteredShips.count, 1)
        XCTAssertEqual([Spaceship.tardis], filteredShips)
    }
    
    func test_givenGreaterThanModifier_whenValueIsGreaterThanRightHandSide_thenReturnTrue() {
        let predicate = Value(\Spaceship.cost).greaterThan(Spaceship.tardis.cost - 1)
        let filteredShips = filterShips(with: predicate)
        XCTAssertEqual(filteredShips.count, 2)
        XCTAssertEqual([.deathStar, .tardis], filteredShips)
    }
    
    func test_givenGreaterThanOrEqualToModifier_whenValueIsGreaterThanOrEqualToRightHandSide_thenReturnTrue() {
        let predicate = Value(\Spaceship.cost).greaterThanOrEqualTo(Spaceship.tardis.cost)
        let filteredShips = filterShips(with: predicate)
        XCTAssertEqual(filteredShips.count, 2)
        XCTAssertEqual([.deathStar, .tardis], filteredShips)
    }
    
    func test_givenBetweenModifier_whenValueIsBetween_thenReturnTrue() {
        let betweenPredicate = Value(\Spaceship.cost).between(0...150)
        let filteredShips = filterShips(with: betweenPredicate)
        XCTAssertEqual(filteredShips.count, 1)
    }
    
    func test_givenBetweenModifier_whenValueIsNotBetween_thenReturnFalse() {
        let betweenPredicate = Value(\Spaceship.cost).between(-1...1)
        let filteredShips = filterShips(with: betweenPredicate)
        XCTAssertEqual(filteredShips.count, 0)
    }
    
    func test_givenInModifier_whenValueIsContainedInArray_thenReturnTrue() {
        let predicate = Value(\Spaceship.name).in(["Apollo", "Saturn", "Tardis"])
        let filteredShips = filterShips(with: predicate)
        XCTAssertEqual(filteredShips.count, 1)
    }
    
    func test_givenInModifier_whenValueIsContainedInDictionaryValues_thenReturnTrue() {
        let predicate = Value(\Spaceship.name).in([0: "Apollo", 1: "Saturn", 2: "Tardis"])
        let filteredShips = filterShips(with: predicate)
        XCTAssertEqual(filteredShips.count, 1)
    }
    
    func test_givenInModifier_whenValueIsNotInCollection_thenReturnFalse() {
        let predicate = Value(\Spaceship.name).in(["Apollo", "Saturn"])
        let filteredShips = filterShips(with: predicate)
        XCTAssertEqual(filteredShips.count, 0)
    }
    
    // MARK: - String comparison tests
    // MARK: Like tests
    
    func test_givenLikeModifier_whenValueIsExactlyLike_thenReturnTrue() {
        let likePredicate = Value(\Spaceship.name).like("Death Star")
        let filteredShips = filterShips(with: likePredicate)
        XCTAssertEqual(filteredShips.count, 1)
    }
    
    func test_givenLikeModifier_whenValueIsLike_thenReturnTrue() {
        let likePredicate = Value(\Spaceship.name).like("Death *")
        let filteredShips = filterShips(with: likePredicate)
        XCTAssertEqual(filteredShips.count, 1)
    }
    
    func test_givenOptionalLikeModifier_whenValueIsLike_thenReturnTrue() {
        let likePredicate = Value(\Spaceship.shipDescription).like("Time *")
        let filteredShips = filterShips(with: likePredicate)
        XCTAssertEqual(filteredShips.count, 1)
    }
    
    // NULL and nil never match anything except when testing NULL == NULL
    func test_givenLikeModifier_whenValueIsNil_thenReturnFalse() {
        let likePredicate = Value(\Spaceship.shipDescription).like(nil)
        let filteredShips = filterShips(with: likePredicate)
        XCTAssertEqual(filteredShips.count, 0)
    }
    
    func test_givenLikeModifier_whenValueIsCaseInsensitiveLike_thenReturnTrue() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            Value(\Spaceship.name)
                .like("TARDIS")
                .withOptions(.caseInsensitive)
        }
        let filteredShips = filterShips(with: predicate)
        XCTAssertEqual(filteredShips.count, 1)
    }
    
    // MARK: Starts/Begins with tests
    
    func test_givenBeginsWithModifier_whenValueBeginsWithPrefix_thenReturnTrue() {
        let predicate = Value(\Spaceship.name).starts(with: "T")
        let result = filterShips(with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"name BEGINSWITH "T""#)
        XCTAssertEqual(result.count, 1)
    }
    
    func test_givenBeginsWithModifier_whenValueDoesNotBeginWithPrefix_thenReturnFalse() {
        let predicate = Value(\Spaceship.name).begins(with: "😂")
        let result = filterShips(with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"name BEGINSWITH "😂""#)
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_givenOptionalBeginsWithModifier_whenValueBeginsWithPrefix_thenReturnTrue() {
        let predicate = Value(\Spaceship.shipDescription).starts(with: "T")
        let result = filterShips(with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"shipDescription BEGINSWITH "T""#)
        XCTAssertEqual(result.count, 1)
    }
    
    func test_givenOptionalBeginsWithModifier_whenValueDoesNotBeginWithPrefix_thenReturnFalse() {
        let predicate = Value(\Spaceship.shipDescription).begins(with: "😂")
        let result = filterShips(with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"shipDescription BEGINSWITH "😂""#)
        XCTAssertTrue(result.isEmpty)
    }
    
    // MARK: Contains tests
    
    func test_givenOptionalContainsModifier_whenValueContainsOtherValue_thenReturnTrue() {
        let predicate = Value(\Spaceship.shipDescription).contains("t")
        let result = filterShips(with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"shipDescription CONTAINS "t""#)
        XCTAssertEqual(result.count, 1)
    }
    
    func test_givenOptionalContainsModifier_whenValueDoesNotContainOtherValue_thenReturnFalse() {
        let predicate = Value(\Spaceship.shipDescription).contains("🚀")
        let result = filterShips(with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"shipDescription CONTAINS "🚀""#)
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_givenContainsModifier_whenValueContainsOtherValue_thenReturnTrue() {
        let predicate = Value(\Spaceship.name).contains("T")
        let result = filterShips(with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"name CONTAINS "T""#)
        XCTAssertEqual(result.count, 1)
    }
    
    func test_givenContainsModifier_whenValueDoesNotContainOtherValue_thenReturnFalse() {
        let predicate = Value(\Spaceship.name).contains("🚀")
        let result = filterShips(with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"name CONTAINS "🚀""#)
        XCTAssertTrue(result.isEmpty)
    }
    
    // MARK: Ends with tests
    
    func test_givenOptionalEndsWithWithModifier_whenValueContainsOtherValue_thenReturnTrue() {
        let predicate = Value(\Spaceship.shipDescription).ends(with: "e")
        let result = filterShips(with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"shipDescription ENDSWITH "e""#)
        XCTAssertEqual(result.count, 1)
    }
    
    func test_givenOptionalEndsWithModifier_whenValueDoesNotContainOtherValue_thenReturnFalse() {
        let predicate = Value(\Spaceship.shipDescription).ends(with: "🚀")
        let result = filterShips(with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"shipDescription ENDSWITH "🚀""#)
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_givenEndsWithModifier_whenValueContainsOtherValue_thenReturnTrue() {
        let predicate = Value(\Spaceship.name).ends(with: "s")
        let result = filterShips(with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"name ENDSWITH "s""#)
        XCTAssertEqual(result.count, 1)
    }
    
    func test_givenEndsWithModifier_whenValueDoesNotContainOtherValue_thenReturnFalse() {
        let predicate = Value(\Spaceship.name).ends(with: "🚀")
        let result = filterShips(with: predicate)
        XCTAssertEqual(predicate.predicateFormat, #"name ENDSWITH "🚀""#)
        XCTAssertTrue(result.isEmpty)
    }
}
