/// A macro annotation for creating a `CustomCodingKeysMacro`.
/// This macro provides a shorthand way to generate a `CodingKeys` enumeration for a structure.
/// The macro uses a dictionary where each key-value pair represents a key path to a property and
/// its respective string representation.
/// The generated `CodingKeys` enumeration conforms to `String` and `CodingKey`.
/// - Parameter _: A dictionary with `[String: String]` as key and `String` as value.
/// The dictionary represents the mapping of properties to their respective string representation.
/// The default value of this parameter is an empty dictionary.
/// - Note: This macro requires the external macro provided by "CustomCodingKeysMacros".
@attached(member, names: arbitrary)
/**
 At this point in time using `[PartialKeyPath<T>: String] = [:]` parameter type is not possible due to `Circular reference resolving attached macro` error. May be fixed in future swift updates.
 */
public macro customCodingKeys(_ : [String: String] = [:]) = #externalMacro(
    module: "CustomCodingKeysMacros",
    type: "CustomCodingKeysMacro"
)
