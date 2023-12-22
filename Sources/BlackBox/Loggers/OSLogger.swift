import Foundation
import os

/// Redirects logs to Console.app and to Xcode console
public class OSLogger: BBLoggerProtocol {
    let levels: [BBLogLevel]
    let logFormat: BBLogFormat
    
    public init(
        levels: [BBLogLevel],
        logFormat: BBLogFormat = BBLogFormat()
    ){
        self.levels = levels
        self.logFormat = logFormat
    }
    
    public func log(_ event: BlackBox.GenericEvent) {
        osLog(event: event)
    }
    
    public func log(_ event: BlackBox.ErrorEvent) {
        osLog(event: event)
    }
    
    public func logStart(_ event: BlackBox.StartEvent) {
        osLog(event: event)
    }
    
    public func logEnd(_ event: BlackBox.EndEvent) {
        osLog(event: event)
    }
    
    private func osLog(event: BlackBox.GenericEvent) {
        guard levels.contains(event.level) else { return }
        
        let data = LogData(from: event, logFormat: logFormat)
        
        osLog(data)
    }
    
    func osLog(_ data: LogData) {
        let log = OSLog(
            subsystem: data.subsystem,
            category: data.category
        )
        
        os_log(
            data.logType,
            log: log,
            "%{public}@", data.message
        )
    }
}

extension OSLogger {
    struct LogData {
        let logType: OSLogType
        let subsystem: String
        let category: String
        let message: String
        
        init(
            logType: OSLogType,
            subsystem: String,
            category: String,
            message: String
        ) {
            self.logType = logType
            self.subsystem = subsystem
            self.category = category
            self.message = message
        }
        
        init(from event: BlackBox.GenericEvent, logFormat: BBLogFormat) {
            let subsystem = event.source.module
            let category = event.category ?? ""
            
            self.init(
                logType: OSLogType(event.level),
                subsystem: subsystem,
                category: category,
                message: Self.message(from: event, logFormat: logFormat)
            )
        }
        
        private static func message(from event: BlackBox.GenericEvent, logFormat: BBLogFormat) -> String {
            func source(from event: BlackBox.GenericEvent) -> String {
                let fileWithLine = [event.source.filename, String(event.source.line)].joined(separator: ":")
                
                return [
                    "[Source]",
                    fileWithLine,
                    event.source.function.description
                ].joined(separator: logFormat.sourceSectionInline ? " " : "\n")
            }
            
            func userInfo(from event: BlackBox.GenericEvent) -> String? {
                guard let userInfo = event.userInfo else { return nil }
                
                return [
                    "[User Info]",
                    userInfo.bbLogDescription(with: logFormat.userInfoFormatOptions)
                ].joined(separator: "\n")
            }
            
            let emptyLinePrefix: String? = logFormat.addEmptyLinePrefix ? "\n" : nil
            let iconPrefix: String? = logFormat.showLevelIcon ? event.level.icon + " " : nil
            
            let prefix = [emptyLinePrefix, iconPrefix].compactMap { $0 }.joined()
            
            let message = prefix + event.messageWithFormattedDuration(using: logFormat.measurementFormatter)
            
            return [
                message,
                source(from: event),
                userInfo(from: event)
            ]
                .compactMap { $0 }
                .joined(separator: "\n\n")
        }
    }
}

extension OSLogType {
    init(_ level: BBLogLevel) {
        switch level {
        case .debug:
            self = .default // .debug won't be shown in Console.app, so switching to .default instead
        case .info:
            self = .info
        case .warning:
            self = .error
        case .error:
            self = .fault
        }
    }
}

extension BlackBox.GenericEvent {
    public func messageWithFormattedDuration(using formatter: MeasurementFormatter) -> String {
        [
            message, 
            formattedDuration(using: formatter)
        ]
            .compactMap { $0 }
            .joined(separator: ", duration: ")
    }
    public func formattedDuration(using formatter: MeasurementFormatter) -> String? {
        guard let endEvent = self as? BlackBox.EndEvent else { return nil }
        let duration = endEvent.duration
        
        let fallback = { return "\(duration) s" }
        
        if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            let measurement = Measurement(
                value: duration,
                unit: UnitDuration.seconds
            )
            return formatter.string(for: measurement) ?? fallback()
        } else {
            return fallback()
        }
    }
}
