import Foundation

public struct BBLogFormat {
    /// Used for formatting JSONs to String
    public let userInfoFormatOptions: JSONSerialization.WritingOptions
    
    /// Defines how information about log source is formatter: multiline or one-line.
    /// > Examples:
    /// ```
    /// // False
    /// [Source]
    /// OSLoggerTests:246
    /// test_whenLogFormatApplied_showingLevelIcon()
    /// ```
    /// ```
    /// // True
    /// [Source] OSLoggerTests:246 test_whenLogFormatApplied_showingLevelIcon()
    /// ```
    public let sourceSectionInline: Bool
    
    /// Messages with this levels should get appropriate ``BBLogIcon`` icon in message. 
    /// 
    /// Icon position depends on formatter rules.
    public let levelsWithIcons: [BBLogLevel]
    
    /// Used for formatting traces duration
    public let measurementFormatter: MeasurementFormatter
    
    /// Improves logs readability in Xcode 14 embedded console
    /// > Examples:
    /// `False`
    /// ```
    /// Hello there
    /// ```
    /// 
    /// `True`
    /// ```
    /// 
    /// 🛠 Hello there
    /// ```
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
        levelsWithIcons: [BBLogLevel] = [],
        measurementFormatter: MeasurementFormatter = MeasurementFormatter(),
        addEmptyLinePrefix: Bool = false
    ) {
        self.userInfoFormatOptions = userInfoFormatOptions
        self.sourceSectionInline = sourceSectionInline
        self.levelsWithIcons = levelsWithIcons
        self.measurementFormatter = measurementFormatter
        self.addEmptyLinePrefix = addEmptyLinePrefix
    }
}
