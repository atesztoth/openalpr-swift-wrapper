//
//  Utils.swift
//
//  Place for smaller helper/utility functions.
//
//  Created by Tóth Attila on 2020. 11. 03..
//

import Foundation

func toCString(str: String) -> [CChar] {
    return str.cString(using: String.Encoding.utf8)!
}

func stringToPointer(str: String) -> UnsafeMutablePointer<UInt8> {
    var messageCString = str.utf8CString
    return messageCString.withUnsafeMutableBytes {
        return $0.baseAddress!.bindMemory(to: UInt8.self, capacity: $0.count)
    }
}
