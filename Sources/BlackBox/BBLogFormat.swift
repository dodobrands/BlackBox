import Foundation

public struct BBLogFormat {
    let userInfoFormatOptions: JSONSerialization.WritingOptions
    let sourceSectionInline: Bool
    let showLevelIcon: Bool

    /// Creates `BBLogFormat` instance
    /// - Parameters:
    ///   - userInfoFormatOptions:Options for output JSON data.
    ///   - sourceSectionInline: Print `Source` section in console inline
    ///   - showLevelIcon: Boolean value defines showing log level icon in console
    public init(
        userInfoFormatOptions: JSONSerialization.WritingOptions,
        sourceSectionInline: Bool,
        showLevelIcon: Bool
    ) {
        self.userInfoFormatOptions = userInfoFormatOptions
        self.sourceSectionInline = sourceSectionInline
        self.showLevelIcon = showLevelIcon
    }

    public static let `default` = BBLogFormat(userInfoFormatOptions: .prettyPrinted,
                                              sourceSectionInline: false,
                                              showLevelIcon: false)
}
