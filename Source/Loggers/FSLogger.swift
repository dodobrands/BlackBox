//
//  FSLogger.swift
//  DodoPizza
//
//  Created by Алексей Берёзка on 25.05.2020.
//  Copyright © 2020 Dodo Pizza. All rights reserved.
//

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
        
        public func log(_ error: Error,
                        file: StaticString,
                        function: StaticString,
                        line: UInt) {
            let message = String(reflecting: error)
            log(message,
                userInfo: nil,
                file: file,
                function: function,
                logLevel: .error)
        }
        
        public func log(_ message: String,
                        userInfo: CustomDebugStringConvertible?,
                        logLevel: BBLogLevel,
                        eventType: BBEventType?,
                        file: StaticString,
                        function: StaticString,
                        line: UInt) {
            log(message,
                userInfo: userInfo,
                file: file,
                function: function,
                logLevel: logLevel)
        }
    }
}

extension BlackBox.FSLogger {
    private func log(_ message: String,
                     userInfo: CustomDebugStringConvertible?,
                     file: StaticString,
                     function: StaticString,
                     logLevel: BBLogLevel) {
        guard logLevels.contains(logLevel) else { return }
        
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

extension BBLogLevel {
    var icon: String {
        switch self {
        case .debug:
            return "🛠"
        case .error:
            return "❌"
        case .warning:
            return "⚠️"
        case .info:
            return "ℹ️"
        case .default:
            return "📝"
        }
    }
}
