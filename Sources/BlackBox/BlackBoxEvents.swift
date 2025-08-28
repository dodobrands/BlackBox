import Foundation

public typealias BBUserInfo = [String: Any]
public typealias BBServiceInfo = Any

extension BlackBox {
    /// Any log event
    public class GenericEvent: Equatable {
        /// Unique event ID
        public let id: UUID
        /// Timestamp when event occurred
        public let timestamp: Date
        /// Event message. May be formatted for some events.
        public let message: String
        /// Additional info. Place data you'd like to log here.
        public let userInfo: BBUserInfo?
        /// Place any additional data here. For example, per-event instructions for your custom loggers.
        public let serviceInfo: BBServiceInfo?
        /// Level of log
        public let level: BBLogLevel
        /// Category of log. E.g. View Lifecycle.
        public let category: String?
        /// Parent log of current log. May be useful for traces.
        public let parentEvent: GenericEvent?
        /// From where log originated
        public let source: Source

        public init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            _ message: String,
            userInfo: BBUserInfo? = nil,
            serviceInfo: BBServiceInfo? = nil,
            level: BBLogLevel = .debug,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            source: Source
        ) {
            self.id = id
            self.timestamp = timestamp
            self.message = message
            self.userInfo = userInfo
            self.serviceInfo = serviceInfo
            self.level = level
            self.category = category
            self.parentEvent = parentEvent
            self.source = source
        }
        
        public convenience init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            _ message: String,
            userInfo: BBUserInfo? = nil,
            serviceInfo: BBServiceInfo? = nil,
            level: BBLogLevel = .debug,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            fileID: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.init(
                id: id,
                timestamp: timestamp,
                message,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                level: level,
                category: category,
                parentEvent: parentEvent,
                source: .init(
                    fileID: fileID,
                    function: function,
                    line: line
                )
            )
        }
        
        public static func == (lhs: BlackBox.GenericEvent, rhs: BlackBox.GenericEvent) -> Bool {
            lhs.id == rhs.id
        }
    }
}

extension BlackBox {
    /// Error event
    public class ErrorEvent: GenericEvent {
        /// Original logged error
        public let error: Swift.Error
        
        public init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            error: Swift.Error,
            serviceInfo: BBServiceInfo? = nil,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            source: Source
        ) {
            self.error = error
            func domainWithoutModuleName(_ module: String) -> String {
                let nsError = error as NSError
                return nsError.domain
                    .deletingPrefix(source.module)
                    .deletingPrefix(".")
            }
            
            func nameWithoutUserInfo() -> String {
                let name = String(describing: error)
                guard let split = name.split(separator: "(").first else { return name }
                return String(split)
            }

            let message = [
                domainWithoutModuleName(source.module),
                nameWithoutUserInfo()
            ].joined(separator: ".")
            
            super.init(
                id: id,
                timestamp: timestamp,
                message,
                userInfo: (error as? CustomNSError)?.errorUserInfo,
                serviceInfo: serviceInfo,
                level: error.level,
                category: category,
                parentEvent: parentEvent,
                source: source
            )
        }
        
        public convenience init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            error: Swift.Error,
            serviceInfo: BBServiceInfo? = nil,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            fileID: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.init(
                id: id,
                timestamp: timestamp,
                error: error,
                serviceInfo: serviceInfo,
                category: category,
                parentEvent: parentEvent,
                source: .init(
                    fileID: fileID,
                    function: function,
                    line: line
                )
            )
        }
    }
}

extension BlackBox {
    /// Measurement start event
    public class StartEvent: GenericEvent {
        /// Original unformatted message
        public let rawMessage: StaticString
        
        public init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            _ message: StaticString,
            userInfo: BBUserInfo? = nil,
            serviceInfo: BBServiceInfo? = nil,
            level: BBLogLevel = .debug,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            source: Source
        ) {
            self.rawMessage = message
            super.init(
                id: id,
                timestamp: timestamp,
                "Start: \(message)",
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                level: level,
                category: category,
                parentEvent: parentEvent,
                source: source
            )
        }
        
        public convenience init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            _ message: StaticString,
            userInfo: BBUserInfo? = nil,
            serviceInfo: BBServiceInfo? = nil,
            level: BBLogLevel = .debug,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            fileID: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.init(
                id: id,
                timestamp: timestamp,
                message,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                level: level,
                category: category,
                parentEvent: parentEvent,
                source: .init(
                    fileID: fileID,
                    function: function,
                    line: line
                )
            )
        }
    }
}

extension BlackBox {
    /// Measurement end event
    public class EndEvent: GenericEvent {
        /// Original unformatted message
        public let rawMessage: StaticString
        
        /// Start event
        public let startEvent: StartEvent
        
        /// Duration between end event and start event
        public let duration: TimeInterval
        
        public init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            message: StaticString? = nil,
            startEvent: StartEvent,
            userInfo: BBUserInfo? = nil,
            serviceInfo: BBServiceInfo? = nil,
            level: BBLogLevel = .debug,
            category: String? = nil,
            source: Source
        ) {
            self.rawMessage = message ?? startEvent.rawMessage
            self.startEvent = startEvent
            self.duration = timestamp.timeIntervalSince(startEvent.timestamp)
            
            let message = "End: \(rawMessage)"
            super.init(
                id: id,
                timestamp: timestamp,
                message,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                level: level,
                category: category,
                parentEvent: startEvent,
                source: source
            )
        }
        
        public convenience init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            message: StaticString? = nil,
            startEvent: StartEvent,
            userInfo: BBUserInfo? = nil,
            serviceInfo: BBServiceInfo? = nil,
            level: BBLogLevel = .debug,
            category: String? = nil,
            fileID: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.init(
                id: id,
                timestamp: timestamp,
                message: message,
                startEvent: startEvent,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                level: level,
                category: category,
                source: .init(
                    fileID: fileID,
                    function: function,
                    line: line
                )
            )
        }
    }
}

fileprivate extension String {
    var filename: String {
        URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    var module: String {
        firstIndex(of: "/").flatMap { String(self[self.startIndex ..< $0]) } ?? ""
    }
}

public extension BlackBox.GenericEvent {
    /// Event source
    struct Source {
        /// Unmodified file id
        public let fileID: StaticString
        /// Module
        public let module: String
        /// File name
        public let filename: String
        /// Function name
        public let function: StaticString
        /// Number of line
        public let line: UInt
        
        public init(
            fileID: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.fileID = fileID
            self.module = fileID.description.module
            self.filename = fileID.description.filename
            self.function = function
            self.line = line
        }
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
}

extension BlackBox.GenericEvent {
    public var isTrace: Bool {
        self is BlackBox.StartEvent || self is BlackBox.EndEvent
    }
}
