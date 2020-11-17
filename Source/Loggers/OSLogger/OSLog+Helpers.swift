//
//  OSLog.swift
//  DFoundation
//
//  Created by Mikhail Rubanov on 20.05.2020.
//

import os

@available(iOS 12.0, *)
extension OSLog {
    public convenience init(file: StaticString, category: String?) {
        self.init(subsystem: file.bbFilename, category: category ?? "")
    }
}
