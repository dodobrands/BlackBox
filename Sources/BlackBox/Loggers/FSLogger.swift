import Foundation

extension BlackBox {
    public class FSLogger: BBLoggerProtocol {
        private let fullpath: URL
        private let logLevels: [BBLogLevel]
        
        public init(path: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!,
                    name: String = "BlackBox_log",
                    logLevels: [BBLogLevel]) {
            self.fullpath = path.appendingPathComponent(name)
            self.logLevels = logLevels
        }
        
        public func log(_ event: BlackBox.ErrorEvent) {
            fsLog(event)
        }
        
        public func log(_ event: BlackBox.GenericEvent) {
            fsLog(event)
        }
        
        public func logStart(_ event: BlackBox.StartEvent) {
            fsLog(event)
        }
        
        public func logEnd(_ event: BlackBox.EndEvent) {
            fsLog(event)
        }
    }
}

extension BlackBox.FSLogger {
    private func fsLog(_ event: BlackBox.GenericEvent) {
        guard logLevels.contains(event.logLevel) else { return }
        
        let userInfo = event.userInfo?.bbLogDescription ?? "nil"
        
        let title = event.logLevel.icon + " " + String(describing: Date())
        let subtitle = event.filename + ", " + event.function.description
        
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
