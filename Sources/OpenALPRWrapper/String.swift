//
//  File.swift
//  
//
//  Created by Tóth Attila on 2020. 11. 03..
//

import Foundation


extension String {
    var usableCString: [CChar] {
        return toCString(str: self)
    }
}
