import Foundation

extension BlackBox {
    public class FSLogger: BBLoggerProtocol {
        private let fullpath: URL
        private let logLevels: [BBLogLevel]
        
        public init(path: URL,
                    name: String,
                    logLevels: [BBLogLevel]) {
            self.fullpath = path.appendingPathComponent(name)
            self.logLevels = logLevels
        }
        
        public func log(
            _ error: BlackBox.Error
        ) {
            guard logLevels.contains(error.logLevel) else { return }
            
            let message = String(reflecting: error.error)
            
            log(message,
                userInfo: error.errorUserInfo,
                file: error.file,
                function: error.function,
                logLevel: error.logLevel)
        }
        
        public func log(
            _ event: BlackBox.Event
        ) {
            guard logLevels.contains(event.logLevel) else { return }
            
            log(event.message,
                userInfo: event.userInfo,
                file: event.file,
                function: event.function,
                logLevel: event.logLevel)
        }
        
        public func logStart(
            _ event: BlackBox.Event
        ) {
            guard logLevels.contains(event.logLevel) else { return }
            
            let formattedMessage = "\(BBEventType.start.description): \(event.message)"
            
            log(formattedMessage,
                userInfo: event.userInfo,
                file: event.file,
                function: event.function,
                logLevel: event.logLevel)
        }
        
        public func logEnd(
            startEvent: BlackBox.Event,
            endEvent: BlackBox.Event
        ) {
            guard logLevels.contains(startEvent.logLevel) else { return }
            
            let formattedMessage = "\(BBEventType.end.description): \(endEvent.message)"
            
            log(formattedMessage,
                userInfo: endEvent.userInfo,
                file: endEvent.file,
                function: endEvent.function,
                logLevel: endEvent.logLevel)
        }
    }
}

extension BlackBox.FSLogger {
    private func log(_ message: String,
                     userInfo: CustomDebugStringConvertible?,
                     file: StaticString,
                     function: StaticString,
                     logLevel: BBLogLevel) {
        let userInfo = userInfo?.bbLogDescription ?? "nil"
        
        let title = logLevel.icon + " " + String(describing: Date())
        let subtitle = file.bbFilename + ", " + function.description
        
        let content = message
        
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
