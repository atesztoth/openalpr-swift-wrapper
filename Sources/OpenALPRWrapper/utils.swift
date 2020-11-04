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
