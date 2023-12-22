import Foundation

public struct BBLogFormat {
    public let userInfoFormatOptions: JSONSerialization.WritingOptions
    public let sourceSectionInline: Bool
    public let showLevelIcon: [BBLogLevel]
    public let measurementFormatter: MeasurementFormatter
    
    /// Improves logs readability in Xcode 14 embedded console
    public let addEmptyLinePrefix: Bool

    /// Creates `BBLogFormat` instance
    /// - Parameters:
    ///   - userInfoFormatOptions:Options for output JSON data.
    ///   - sourceSectionInline: Print `Source` section in console inline
    ///   - showLevelIcon: Boolean value defines showing log level icon in console
    ///   - measurementFormatter: Formatter used for traces durations output
    public init(
        userInfoFormatOptions: JSONSerialization.WritingOptions = .prettyPrinted,
        sourceSectionInline: Bool = false,
        showLevelIcon: [BBLogLevel] = [],
        measurementFormatter: MeasurementFormatter = MeasurementFormatter(),
        addEmptyLinePrefix: Bool = false
    ) {
        self.userInfoFormatOptions = userInfoFormatOptions
        self.sourceSectionInline = sourceSectionInline
        self.showLevelIcon = showLevelIcon
        self.measurementFormatter = measurementFormatter
        self.addEmptyLinePrefix = addEmptyLinePrefix
    }
}
