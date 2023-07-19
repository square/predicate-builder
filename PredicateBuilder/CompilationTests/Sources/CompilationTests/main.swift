import Foundation
import PredicateBuilderCore

@PredicateBuilder<NSString> var valid: NSPredicate {
    \NSString.boolValue == true
}

@PredicateBuilder<NSInteger> var shouldNotCompile: NSPredicate {
    \NSString.boolValue == true
}
