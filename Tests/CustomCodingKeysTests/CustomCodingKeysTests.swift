import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(CustomCodingKeysMacros)
import CustomCodingKeysMacros

let testMacros: [String: Macro.Type] = [
    "customCodingKeys": CustomCodingKeysMacro.self
]
#endif

final class CustomCodingKeysTests: XCTestCase {
    
    func testCodingKeysWithPartialKeyPaths() throws {
#if canImport(CustomCodingKeysMacros)
        let sf: SourceFileSyntax = #"""
        @customCodingKeys([
        \Something.newUser: "new_user",
        \Something.bar: "Value",
        \Something.foo: "fo_o"
        ])
        public struct Something: Codable {
            let foo: String
            let bar: Int
            let newUser: String
        }
        """#
        
        let expectation = """
        
        public struct Something: Codable {
            let foo: String
            let bar: Int
            let newUser: String
        
            enum CodingKeys: String, CodingKey {
                case foo = "fo_o"
                case bar = "Value"
                case newUser = "new_user"
            }
        }
        """

        let context = BasicMacroExpansionContext(
            sourceFiles: [
                sf: .init(
                    moduleName: "TestModule",
                    fullFilePath: "test.swift"
                )
            ]
        )

        let transformed = sf.expand(macros: testMacros, in: context)
        XCTAssertEqual(transformed.formatted().description, expectation)
#else
throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testCodingKeysWithoutPartialKeyPaths() throws {
#if canImport(CustomCodingKeysMacros)
        let sf: SourceFileSyntax = #"""
        @customCodingKeys()
        public struct Something: Codable {
            let foo: String
            let bar: Int
            let newUser: String
        }
        """#
        
        let expectation = """
        
        public struct Something: Codable {
            let foo: String
            let bar: Int
            let newUser: String
        
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
                case newUser
            }
        }
        """

        let context = BasicMacroExpansionContext(
            sourceFiles: [
                sf: .init(
                    moduleName: "TestModule",
                    fullFilePath: "test.swift"
                )
            ]
        )

        let transformed = sf.expand(macros: testMacros, in: context)
        XCTAssertEqual(transformed.formatted().description, expectation)
#else
throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
