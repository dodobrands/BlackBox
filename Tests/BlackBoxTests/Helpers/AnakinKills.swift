//
//  AnakinKills.swift
//  
//
//  Created by Aleksey Berezka on 13.10.2022.
//

import Foundation

enum AnakinKills: Error, Equatable, CustomNSError {
    case maceWindu
    case younglings(count: Int)
    
    var errorUserInfo: [String : Any] {
        switch self {
        case .maceWindu:
            return [:]
        case .younglings(let count):
            return ["count": count]
        }
    }
}
