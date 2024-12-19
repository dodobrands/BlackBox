import Foundation

public struct BBLogFormat {
    public struct Icons {
        public let debug: String?
        public let info: String?
        public let warning: String?
        public let error: String?
        
        public init(
            debug: String? = nil,
            info: String? = nil,
            warning: String? = nil,
            error: String? = nil
        ) {
            self.debug = debug
            self.info = info
            self.warning = warning
            self.error = error
        }
        
        func icon(for level: BBLogLevel) -> String? {
            switch level {
            case .debug: return debug
            case .info: return info
            case .warning: return warning
            case .error: return error
            }
        }
        
        public static var withDefaultIcons: Icons {
            Icons(debug: "🛠", info: "ℹ️", warning: "⚠️", error: "❌")
        }
    }
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
    @available(*, deprecated, message: "Use levelsIcons")
    public let levelsWithIcons: [BBLogLevel]
    
    public let levelsIcons: Icons
    
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
    ///   - levelsWithIcons: Logs with this levels should have appropriate level icon
    ///   - levelsIcons: Icons for each log level
    ///   - measurementFormatter: Formatter used for traces durations output
    ///   - addEmptyLinePrefix: Logger should add empty line prefix before message
    public init(
        userInfoFormatOptions: JSONSerialization.WritingOptions = .prettyPrinted,
        sourceSectionInline: Bool = false,
        levelsWithIcons: [BBLogLevel] = [],
        levelsIcons: Icons = Icons(),
        measurementFormatter: MeasurementFormatter = MeasurementFormatter(),
        addEmptyLinePrefix: Bool = false
    ) {
        self.userInfoFormatOptions = userInfoFormatOptions
        self.sourceSectionInline = sourceSectionInline
        self.levelsWithIcons = levelsWithIcons
        self.levelsIcons = levelsIcons
        self.measurementFormatter = measurementFormatter
        self.addEmptyLinePrefix = addEmptyLinePrefix
    }
}

extension BBLogFormat {
    public func icon(for level: BBLogLevel) -> String? {
        if levelsWithIcons.contains(level) {
            return level.icon
        } else if let icon = levelsIcons.icon(for: level) {
            return icon
        } else {
            return nil
        }
    }
}
