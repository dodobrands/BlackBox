//
//  BBHelpers.swift
//  DFoundation
//
//  Created by Алексей Берёзка on 31.07.2020.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    var bbLogDescription: String {
        guard JSONSerialization.isValidJSONObject(self),
            let jsonData = try? JSONSerialization.data(withJSONObject: self,
                                                       options: .prettyPrinted),
            let jsonString = String(data: jsonData, encoding: .utf8)
            else { return String(describing: self) }
        
        return jsonString
    }
}

extension CustomDebugStringConvertible {
    var bbLogDescription: String {
        if let json = self as? [String: Any] {
            return json.bbLogDescription
        }
        
        return String(describing: self)
    }
}

public extension StaticString {
    var bbFilename: String {
        return URL(fileURLWithPath: description).deletingPathExtension().lastPathComponent
    }
}

public extension UInt64 {
    static var random: Self {
        random(in: Self.min...Self.max)
    }
}
