import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct CustomCodingKeysPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CustomCodingKeysMacro.self
    ]
}
