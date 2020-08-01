//
//  OSLog.swift
//  DFoundation
//
//  Created by Mikhail Rubanov on 20.05.2020.
//

import os

@available(iOS 12.0, *)
extension OSLog {
    static func logger(for file: StaticString) -> OSLog {
        return logger(subsystem: Bundle.main.bundleIdentifier!, file: file)
    }
    
    private static func logger(subsystem: String, file: StaticString) -> OSLog {
        return OSLog(subsystem: subsystem, category: file.bbFilename)
    }
}
