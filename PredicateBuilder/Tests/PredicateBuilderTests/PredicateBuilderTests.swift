import XCTest
@testable import PredicateBuilder
@testable import PredicateBuilderCore
@testable import PredicateBuilderTestData

final class PredicateBuilderTests: XCTestCase {

    func test_buildBlockBuildsPredicate() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            \Spaceship.name == "test"
        }
        
        XCTAssertEqual(predicate.predicateFormat, #"name == "test""#)
    }
    
    func test_givenBooleanKeyPath_whenNoOperatorOrModifierIsPresent_thenBuildEqualityPredicate() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            \Spaceship.isReal
        }
        
        XCTAssertEqual(predicate.predicateFormat, "isReal == 1")
    }
    
    func test_givenLogicalBranchInBuilder_thenBuildCorrectPredicateForBranch() {
        var boolean = true

        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            if boolean {
                \Spaceship.isReal
            } else {
                \Spaceship.isReal == false
            }
        }

        XCTAssertEqual(predicate.predicateFormat, "isReal == 1")

        boolean = false
        XCTAssertEqual(predicate.predicateFormat, "isReal == 0")
    }
    
    func test_givenOptional_whenValueIsNil_thenBuildEmptyPredicate() {
        let optional: Bool? = nil

        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            if optional != nil {
                \Spaceship.isReal
            }
        }

        // The predicate is empty, so it evaluates to true
        XCTAssertEqual(predicate.predicateFormat, "TRUEPREDICATE")
    }
    
    func test_givenPredicate_whenBuildOptionalFails_thenPartialResultIsEmpty() {
        let optional: Bool? = nil

        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            if optional != nil {
                \Spaceship.name == "will never be evaluated"
            }

            \Spaceship.isReal
        }

        // The result of the failed `if let optional` evaluates to an empty
        // result, so it is omitted from the final predicate
        XCTAssertEqual(predicate.predicateFormat, "isReal == 1")
    }
    
    func test_givenOptional_whenValueIsPresent_thenBuildPredicate() {
        let optional: Bool? = true

        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            if optional == true {
                \Spaceship.isReal
            }
        }

        XCTAssertEqual(predicate.predicateFormat, "isReal == 1")
    }
    
    func test_givenBuilder_whenArrayOfPredicatesIsDeclared_thenBuildCompoundPredicateAndingSubpredicates() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            for i in (0..<3).map(Int32.init) {
                \Spaceship.cost > i
            }

            \Spaceship.isReal
        }

        XCTAssertEqual(
            predicate.predicateFormat,
            "cost > 0 AND cost > 1 AND cost > 2 AND isReal == 1"
        )
    }
    
    func test_givenBuilder_whenArrayOfPredicatesIsDeclaredAndCompoundPartialResultFollows_thenBuildCompoundPredicateAndingSubpredicates() {
        @PredicateBuilder<Spaceship> var predicate: NSPredicate {
            for i in (0..<3).map(Int32.init) {
                \Spaceship.cost > i
            }

            Or {
                \Spaceship.isReal == true
                \Spaceship.name == "test"
            }
        }

        XCTAssertEqual(
            predicate.predicateFormat,
            #"cost > 0 AND cost > 1 AND cost > 2 AND (isReal == 1 OR name == "test")"#
        )
    }
}
