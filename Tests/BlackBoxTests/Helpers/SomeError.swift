//
//  SomeError.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import Foundation

enum SomeError: Error, Equatable, CustomNSError {
    case someCase
    case otherCase(value: Int)
    
    var errorUserInfo: [String : Any] {
        switch self {
        case .someCase:
            return [:]
        case .otherCase(let value):
            return ["value": value]
        }
    }
}
