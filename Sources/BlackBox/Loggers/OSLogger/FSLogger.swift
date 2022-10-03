import Foundation

extension BlackBox {
    /// Redirects logs to text file
    public class FSLogger: BBLoggerProtocol {
        private let fullpath: URL
        private let levels: [BBLogLevel]
        private let queue: DispatchQueue
        
        /// Creates FS logger
        /// - Parameters:
        ///   - path: path to file where logs are added, without filename
        ///   - name: filename
        ///   - levels: levels to log
        ///   - queue: queue for logs to be prepared and stored at
        public init(
            path: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!,
            name: String = "BlackBox_log",
            levels: [BBLogLevel],
            queue: DispatchQueue = DispatchQueue(label: String(describing: FSLogger.self))
        ) {
            self.fullpath = path.appendingPathComponent(name)
            self.levels = levels
            self.queue = queue
        }
        
        public func log(_ event: BlackBox.ErrorEvent) {
            fsLogAsync(event)
        }
        
        public func log(_ event: BlackBox.GenericEvent) {
            fsLogAsync(event)
        }
        
        public func logStart(_ event: BlackBox.StartEvent) {
            fsLogAsync(event)
        }
        
        public func logEnd(_ event: BlackBox.EndEvent) {
            fsLogAsync(event)
        }
    }
}

extension BlackBox.FSLogger {
    private func fsLogAsync(_ event: BlackBox.GenericEvent) {
        queue.async {
            self.fsLog(event)
        }
    }
    
    private func fsLog(_ event: BlackBox.GenericEvent) {
        guard levels.contains(event.level) else { return }
        
        let userInfo = event.userInfo?.bbLogDescription ?? "nil"
        
        let title = event.level.icon + " " + String(describing: Date())
        let subtitle = event.source.filename + ", " + event.source.function.description
        
        let content = event.message
        
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
