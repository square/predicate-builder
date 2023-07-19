import XCTest
@testable import PredicateBuilder
@testable import PredicateBuilderCore
@testable import PredicateBuilderTestData

final class OrTests: XCTestCase {
    
    func test_givenOrPredicate_whenAnyValueIsTrue_thenReturnTrue() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            Or {
                \Spaceship.name == Spaceship.tardis.name
                \Spaceship.name == "no spaceship has this name"
            }
        }
        
        let result = filterShips(with: predicate)
        XCTAssertEqual([.tardis], result)
    }
    
    func test_givenOrPredicate_whenAllValuesAreFalse_thenReturnFalse() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            Or {
                \Spaceship.name == "klsadfjals;dfhaksd;f"
                \Spaceship.name == "no spaceship has this name"
            }
        }
        let result = filterShips(with: predicate)
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_givenConvenienceOr_thenPredicateMatches() {
        @PredicateBuilder<Spaceship> var blockBuilder: NSPredicate {
            Or {
                \Spaceship.name == "thOR's ship"
                \Spaceship.isReal
            }
        }
        
        @PredicateBuilder<Spaceship> var methodBuilder: NSPredicate {
            Value(\Spaceship.name).equals("thOR's ship")
                .or(Value(\Spaceship.isReal).equals(true))
        }
        
        XCTAssertEqual(blockBuilder.predicateFormat, methodBuilder.predicateFormat)
    }
}
