#if swift(>=5.9)
import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct PredicateBuilderMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        PredicateBuilderMacro.self
    ]
}

enum PredicateBuilderMacroDiagnostic: String, DiagnosticMessage {
    case noSpecialization
    
    var severity: DiagnosticSeverity { .error }
    
    var message: String {
        switch self {
        case .noSpecialization:
            return "#PredicateBuilder must be specialized with a generic type"
        }
    }
    
    var diagnosticID: MessageID {
        MessageID(domain: "PredicateBuilderMacros", id: rawValue)
    }
}

/// A macro which takes a generic `PredicateBuilder` and expands
/// it to a closure that declares the property-wrapped variable, builds the result,
/// and returns the final value.
public struct PredicateBuilderMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let genericArguments = node.genericArguments,
              let genericType = genericArguments.arguments.first else {
            let noSpecializationError = Diagnostic(
                node: Syntax(node),
                message: PredicateBuilderMacroDiagnostic.noSpecialization
            )
            context.diagnose(noSpecializationError)
            return ""
        }
        
        // Diagnostics are not needed for too many specializations because the
        // type system catches that error when the macro expands
        
        let buildBlockBody: CodeBlockItemListSyntax =
            if let statements = node.trailingClosure?.statements {
                statements
            } else {
                // Allow an empty closure body--the PredicateBuilder's error handling
                // already correctly handles empty bodies
                CodeBlockItemListSyntax([])
            }
        
        // I'm not sure why `buildBlockBody` comes with the leading trivia "\n",
        // but we trim it here so that the expansion looks better to our fellow debuggers.
        let trimmedBody = buildBlockBody.trimmed
        return """
        {
            @PredicateBuilder<\(genericType)> var predicate: AnyTypedPredicate<\(genericType)> {
                \(trimmedBody)
            }
            return predicate
        }()
        """
    }
}
#endif
