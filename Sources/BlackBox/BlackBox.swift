import Foundation

public class BlackBox {
    /// Instance that holds loggers
    ///
    /// Create instance with desired loggers and replace this one
    public static var instance = BlackBox.default
    
    private let loggers: [BBLoggerProtocol]
    
    /// Creates `BlackBox` instance
    /// - Parameters:
    ///   - loggers: Instances to receive logs from `BlackBox`
    public init(loggers: [BBLoggerProtocol]) {
        self.loggers = loggers
    }
}

// MARK: - Static
extension BlackBox {
    /// Logs plain message
    /// - Parameters:
    ///   - message: Message to log
    ///   - userInfo: Additional info you'd like to see alongside log
    ///   - serviceInfo: to be deleted
    ///   - level: level of log
    ///   - category: Category of log. E.g. View Lifecycle.
    ///   - parentEvent: Parent log of current log. May be useful for traces.
    ///   - fileID: The fileID where the logs occurs. Containts module name and filename. The default is the fileID of the function where you call log.
    ///   - function: The function where the logs occurs. The default is the function name from where you call log.
    ///   - line: The line where the logs occurs. The default is the line in function from where you call log.
    public static func log(
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
        BlackBox.instance.log(
            message,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            level: level,
            category: category,
            parentEvent: parentEvent,
            fileID: fileID,
            function: function,
            line: line
        )
    }
    
    /// Logs error messages
    /// - Parameters:
    ///   - error: Error to log
    ///   - serviceInfo: to be deleted
    ///   - category: Category of log. E.g. View Lifecycle.
    ///   - parentEvent: Parent log of current log. May be useful for traces.
    ///   - fileID: The fileID where the logs occurs. Containts module name and filename. The default is the fileID of the function where you call log.
    ///   - function: The function where the logs occurs. The default is the function name from where you call log.
    ///   - line: The line where the logs occurs. The default is the line in function from where you call log.
    public static func log(
        _ error: Swift.Error,
        serviceInfo: BBServiceInfo? = nil,
        category: String? = nil,
        parentEvent: GenericEvent? = nil,
        fileID: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.log(
            error,
            serviceInfo: serviceInfo,
            category: category,
            parentEvent: parentEvent,
            fileID: fileID,
            function: function,
            line: line
        )
    }

    // MARK: - Measurements
    /// Logs measurement start
    /// - Parameters:
    ///   - message: Measurement name
    ///   - userInfo: Additional info you'd like to see alongside log
    ///   - serviceInfo: to be deleted
    ///   - level: level of log
    ///   - category: Category of log. E.g. View Lifecycle.
    ///   - parentEvent: Parent log of current log. May be useful for traces.
    ///   - fileID: The fileID where the logs occurs. Containts module name and filename. The default is the fileID of the function where you call log.
    ///   - function: The function where the logs occurs. The default is the function name from where you call log.
    ///   - line: The line where the logs occurs. The default is the line in function from where you call log.
    /// - Returns: Started measurement
    public static func logStart(
        _ message: StaticString,
        userInfo: BBUserInfo? = nil,
        serviceInfo: BBServiceInfo? = nil,
        level: BBLogLevel = .debug,
        category: String? = nil,
        parentEvent: GenericEvent? = nil,
        fileID: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) -> StartEvent {
        BlackBox.instance.logStart(
            message,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            level: level,
            category: category,
            parentEvent: parentEvent,
            fileID: fileID,
            function: function,
            line: line
        )
    }
    
    /// Logs measurement start
    /// - Parameter event: measurement start event
    public static func logStart(
        _ event: StartEvent
    ) {
        BlackBox.instance.logStart(event)
    }
    
    /// Logs measurement end
    /// - Parameters:
    ///   - startEvent: Measurement start event
    ///   - message: Alternate message to log instead of ``StartEvent`` message.
    ///   - userInfo: Additional info you'd like to see alongside log
    ///   - serviceInfo: to be deleted
    ///   - category: Category of log. E.g. View Lifecycle.
    ///   - parentEvent: Parent log of current log. May be useful for traces.
    ///   - fileID: The fileID where the logs occurs. Containts module name and filename. The default is the fileID of the function where you call log.
    ///   - function: The function where the logs occurs. The default is the function name from where you call log.
    ///   - line: The line where the logs occurs. The default is the line in function from where you call log.
    public static func logEnd(
        _ event: StartEvent,
        message: StaticString? = nil,
        userInfo: BBUserInfo? = nil,
        serviceInfo: BBServiceInfo? = nil,
        category: String? = nil,
        fileID: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        BlackBox.instance.logEnd(
            event,
            message: message,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            category: category,
            fileID: fileID,
            function: function,
            line: line
        )
    }
    
    /// Logs measurement end
    /// - Parameter event: measurement end event
    public static func logEnd(
        _ event: EndEvent
    ) {
        BlackBox.instance.logEnd(event)
    }
}

// MARK: - Instance
extension BlackBox {
    func log(
        _ message: StaticString,
        userInfo: BBUserInfo?,
        serviceInfo: BBServiceInfo?,
        level: BBLogLevel,
        category: String?,
        parentEvent: GenericEvent?,
        fileID: StaticString,
        function: StaticString,
        line: UInt
    ) {
        let source = GenericEvent.Source(
            fileID: fileID,
            function: function,
            line: line
        )
        let event = BlackBox.GenericEvent(
            message.description,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            level: level,
            category: category,
            parentEvent: parentEvent,
            source: source
        )
        
        loggers.forEach { $0.log(event) }
    }
    
    func log(
        _ error: Error,
        serviceInfo: BBServiceInfo?,
        category: String?,
        parentEvent: GenericEvent?,
        fileID: StaticString,
        function: StaticString,
        line: UInt
    ) {
        let source = GenericEvent.Source(
            fileID: fileID,
            function: function,
            line: line
        )
        let event = BlackBox.ErrorEvent(
            error: error,
            serviceInfo: serviceInfo,
            category: category,
            parentEvent: parentEvent,
            source: source
        )
        
        loggers.forEach { $0.log(event) }
    }
    
    func logStart(
        _ message: StaticString,
        userInfo: BBUserInfo?,
        serviceInfo: BBServiceInfo?,
        level: BBLogLevel,
        category: String?,
        parentEvent: GenericEvent?,
        fileID: StaticString,
        function: StaticString,
        line: UInt
    ) -> BlackBox.StartEvent {
        let source = GenericEvent.Source(
            fileID: fileID,
            function: function,
            line: line
        )
        let event = StartEvent(
            message,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            level: level,
            category: category,
            parentEvent: parentEvent,
            source: source
        )
        
        logStart(event)
        
        return event
    }
    
    func logStart(
        _ event: BlackBox.StartEvent
    ) {
        loggers.forEach { $0.logStart(event) }
    }
    
    func logEnd(
        _ startEvent: BlackBox.StartEvent,
        message: StaticString?,
        userInfo: BBUserInfo?,
        serviceInfo: BBServiceInfo?,
        category: String?,
        fileID: StaticString,
        function: StaticString,
        line: UInt
    ) {
        let source = GenericEvent.Source(
            fileID: fileID,
            function: function,
            line: line
        )
        let event = EndEvent(
            message: message,
            startEvent: startEvent,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            level: startEvent.level,
            category: category,
            source: source
        )
        
        logEnd(event)
    }
    
    func logEnd(
        _ event: BlackBox.EndEvent
    ) {
        loggers.forEach { $0.logEnd(event) }
    }
}

extension BlackBox {
    static let `default` = BlackBox(loggers: BlackBox.defaultLoggers)
    
    public static var defaultLoggers: [BBLoggerProtocol] {
        [
            OSLogger(levels: .allCases),
            OSSignpostLogger(levels: .allCases)
        ]
    }
}
