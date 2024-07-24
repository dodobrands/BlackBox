import Foundation

/// Redirects logs to text file
/// > Warning: Doesn't support filesize limits, use at your own risk.
public class FSLogger: BBLoggerProtocol {
    private let fullpath: URL
    private let levels: [BBLogLevel]
    private let queue: DispatchQueue?
    private let logFormat: BBLogFormat
    
    /// Creates FS logger
    /// - Parameters:
    ///   - path: path to directory where log file will be stored
    ///   - name: filename
    ///   - levels: levels to log
    ///   - queue: queue for logs to be prepared and stored at
    public init(
        path: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!,
        name: String = "BlackBox_FSLogger",
        levels: [BBLogLevel],
        queue: DispatchQueue? = DispatchQueue(label: String(describing: FSLogger.self)),
        logFormat: BBLogFormat = BBLogFormat()
    ) {
        self.fullpath = path.appendingPathComponent(name)
        self.levels = levels
        self.queue = queue
        self.logFormat = logFormat
    }
    
    public func log(_ event: BlackBox.GenericEvent) {
        fsLogAsyncOrSync(event)
    }
    
    public func log(_ event: BlackBox.ErrorEvent) {
        fsLogAsyncOrSync(event)
    }
    
    public func logStart(_ event: BlackBox.StartEvent) {
        fsLogAsyncOrSync(event)
    }
    
    public func logEnd(_ event: BlackBox.EndEvent) {
        fsLogAsyncOrSync(event)
    }
}

extension FSLogger {
    private func fsLogAsyncOrSync(_ event: BlackBox.GenericEvent) {
        if let queue {
            queue.async {
                self.fsLog(event)
            }
        } else {
            fsLog(event)
        }
    }
    
    private func fsLog(_ event: BlackBox.GenericEvent) {
        guard levels.contains(event.level) else { return }
        
        let userInfo = event.userInfo?.bbLogDescription(with: logFormat.userInfoFormatOptions) ?? "nil"
        
        let title = event.level.icon + " " + String(describing: Date())
        let subtitle = event.source.filename + ", " + event.source.function.description
        
        let content = event.messageWithFormattedDuration(using: logFormat.measurementFormatter)
        
        let footer = "[User Info]:" + "\n" + userInfo
        
        let messageToLog = title + "\n" + subtitle + "\n\n" + content + "\n\n" + footer + "\n\n\n"
        
        log(messageToLog)
    }
    
    private func log(_ string: String) {
        if let handle = try? FileHandle(forWritingTo: fullpath) {
            handle.seekToEndOfFile()
            handle.write(string.data(using: .utf8)!)
            handle.closeFile()
        } else {
            try? string.data(using: .utf8)?.write(to: fullpath)
        }
    }
}
