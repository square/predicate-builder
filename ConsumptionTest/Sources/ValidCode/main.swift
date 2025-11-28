import CoreData
import PredicateBuilder

// MARK: - Valid Code Tests
// These should compile successfully when using the public API

class Test: NSManagedObject {
    @NSManaged var name: String
}

@main
struct ValidCode {
    static func main() {
        // Test macro usage - if this compiles, the macro is available via public API
        let _: NSPredicate = #PredicateBuilder<Test> {
            \.name == "hello"
        }

        // Test result builder usage - if this compiles, the builder is available via public API
        @PredicateBuilder<Test>
        var _unused: NSPredicate {
            \.name == "hello"
        }
    }
}
