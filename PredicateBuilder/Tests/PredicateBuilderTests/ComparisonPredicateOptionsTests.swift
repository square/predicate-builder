import XCTest
@testable import PredicateBuilder
@testable import PredicateBuilderCore
@testable import PredicateBuilderTestData

final class ComparisonPredicateOptionsTests: XCTestCase {
    
    func test_givenNoOptions_thenPredicateContainsNoOptions() {
        let predicate = Value(\Spaceship.name).equals("test", options: [])
        XCTAssertEqual(predicate.predicateFormat, #"name == "test""#)
    }
    
    func test_givenCaseInsensitiveOption_thenPredicateContainsOptions() {
        let predicate = Value(\Spaceship.name).equals("test", options: .caseInsensitive)
        XCTAssertEqual(predicate.predicateFormat, #"name ==[c] "test""#)
    }
    
    func test_givenDiacriticInsensitiveOption_thenPredicateContainsOptions() {
        let predicate = Value(\Spaceship.name).equals("test", options: .diacriticInsensitive)
        XCTAssertEqual(predicate.predicateFormat, #"name ==[d] "test""#)
    }
    
    func test_givenCaseAndDiacriticInsensitiveOption_thenPredicateContainsOptions() {
        [
            ComparisonPredicateOptions.cd,
            [.c, .d],
            [.d, .c],
            [.caseInsensitive, .diacriticInsensitive],
            [.diacriticInsensitive, .caseInsensitive]
        ].forEach { options in
            let predicate = Value(\Spaceship.name)
                .equals("test")
                .withOptions(options)
            XCTAssertEqual(predicate.predicateFormat, #"name ==[cd] "test""#)
        }
    }
}
