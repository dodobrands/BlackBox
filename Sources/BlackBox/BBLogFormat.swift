import Foundation

public struct BBLogFormat {
    let userInfoFormatOptions: JSONSerialization.WritingOptions
    let sourceSectionInline: Bool
    let showLevelIcon: Bool
    let measurementFormatter: MeasurementFormatter

    /// Creates `BBLogFormat` instance
    /// - Parameters:
    ///   - userInfoFormatOptions:Options for output JSON data.
    ///   - sourceSectionInline: Print `Source` section in console inline
    ///   - showLevelIcon: Boolean value defines showing log level icon in console
    ///   - measurementFormatter: Formatter used for traces durations output
    public init(
        userInfoFormatOptions: JSONSerialization.WritingOptions = .prettyPrinted,
        sourceSectionInline: Bool = false,
        showLevelIcon: Bool = false,
        measurementFormatter: MeasurementFormatter = MeasurementFormatter()
    ) {
        self.userInfoFormatOptions = userInfoFormatOptions
        self.sourceSectionInline = sourceSectionInline
        self.showLevelIcon = showLevelIcon
        self.measurementFormatter = measurementFormatter
    }
}
