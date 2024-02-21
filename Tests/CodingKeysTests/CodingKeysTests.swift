import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosTestSupport

import XCTest

import CodingKeysMacros

final class CodingKeysTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "CodingKeysMacro": CodingKeysMacro.self
    ]

    func testCodingKeysWithPartialKeyPaths() throws {

        let sf: SourceFileSyntax = #"""
        @CodingKeysMacro([
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
    }
    
    func testCodingKeysWithoutPartialKeyPaths() throws {

        let sf: SourceFileSyntax = #"""
        @CodingKeysMacro()
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
        
            enum CodingKeys: String, CodingKey, CaseIterable {
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
    }
}
