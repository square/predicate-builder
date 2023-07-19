#if swift(>=5.9)
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import PredicateBuilderMacroMacros

let testMacros: [String: Macro.Type] = [
    "PredicateBuilder": PredicateBuilderMacro.self
]

final class PredicateBuilderMacroTests: XCTestCase {
    
    func test_givenValidMacro_thenMacroIsExpanded() {
        assertMacroExpansion(
            #"""
            #PredicateBuilder<Spaceship> {
                \Spaceship.isReal
            }
            """#,
            expandedSource:
            #"""
            {
                @PredicateBuilder<Spaceship> var predicate: AnyTypedPredicate<Spaceship> {
                    \Spaceship.isReal
                }
                return predicate
            }()
            """#,
            macros: testMacros
        )
    }
    
    func test_givenMacroWithNoSpecialization_thenCompilerErrorIsEmitted() {
        assertMacroExpansion(
            #"""
            #PredicateBuilder {
                \Spaceship.isReal
            }
            """#,
            expandedSource: "",
            diagnostics: [
               DiagnosticSpec(
                message: "#PredicateBuilder must be specialized with a generic type",
                line: 1,
                column: 1
               )
            ],
            macros: testMacros
        )
    }
}
#endif
