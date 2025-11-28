import Foundation
import PredicateBuilder

// MARK: - Invalid Code Tests
// These should NOT compile - they test type checking behavior
// This file is intentionally invalid and should cause compilation to fail

@main
struct InvalidCode {
    static func main() {
        @PredicateBuilder<NSString> var valid: NSPredicate {
            \NSString.boolValue == true
        }

        @PredicateBuilder<NSInteger> var shouldNotCompile: NSPredicate {
            \NSString.boolValue == true  // Wrong type - should fail compilation
        }
    }
}

