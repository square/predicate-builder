#if swift(>=5.9)
import XCTest
@testable import PredicateBuilder
@testable import PredicateBuilderCore
@testable import PredicateBuilderTestData
@testable import PredicateBuilderMacro

final class MacroTests: XCTestCase {
    
    func test_givenSimpleMacroAndBuilderPredicate_whenBodiesMatch_thenPredicatesAreEqual() {
        let macroPredicate = #PredicateBuilder<Spaceship> {
            \.isReal
        }
        
        @PredicateBuilder<Spaceship> var builderPredicate: AnyTypedPredicate<Spaceship> {
            \.isReal
        }
        
        XCTAssertEqual(macroPredicate.predicateFormat, builderPredicate.predicateFormat)
    }
    
    func test_givenCompoundMacroAndBuilderPredicate_whenBodiesMatch_thenPredicatesAreEqual() {
        let macroPredicate = #PredicateBuilder<Spaceship> {
            And {
                \.isReal
                \.name == "name"
            }
        }
        
        @PredicateBuilder<Spaceship> var builderPredicate: AnyTypedPredicate<Spaceship> {
            And {
                \.isReal
                \.name == "name"
            }
        }
        
        XCTAssertEqual(macroPredicate.predicateFormat, builderPredicate.predicateFormat)
    }
    
    func test_sameAsBelowButWithBuilder() {
        @PredicateBuilder<Spaceship> var isRealPredicate: AnyTypedPredicate<Spaceship> {
            \.isReal
        }
        
        @PredicateBuilder<Spaceship> var isCostlyPredicate: AnyTypedPredicate<Spaceship> {
            \.cost > 100
        }
        
        @PredicateBuilder<Spaceship> var combinedPredicate: AnyTypedPredicate<Spaceship> {
            And {
                isRealPredicate
                isCostlyPredicate
            }
        }
        
        XCTAssertEqual(combinedPredicate.predicateFormat, "isReal == 1 AND cost > 100")
    }
    
    // TODO this test will only pass when run in conjunction with another test
    // that uses the macro. I believe this an Xcode bug with some sort of shared
    // mutable state used in the macro expansion that gets cleaned up across test
    // runs. I plan to keep an eye on it.
    func test_givenMacroPredicates_whenCombined_thenFinalResultIsCorrect() {
        let isRealPredicate: AnyTypedPredicate<Spaceship> = #PredicateBuilder<Spaceship> {
            \.isReal
        }
    
        let isCostlyPredicate: AnyTypedPredicate<Spaceship> = #PredicateBuilder<Spaceship> {
            \.cost > 100
        }
        
        let combinedPredicate: AnyTypedPredicate<Spaceship> = #PredicateBuilder<Spaceship> {
            And {
                isRealPredicate
                isCostlyPredicate
            }
        }
        
        XCTAssertEqual(combinedPredicate.predicateFormat, "isReal == 1 AND cost > 100")
    }
    
}
#endif
