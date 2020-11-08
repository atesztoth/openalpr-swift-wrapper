//
//  OpenALPR.swift
//
//  Home of the wrapper class for my wrapper. Yeah. Wrapperception.
//
//  Created by Tóth Attila on 2020. 11. 03..
//

import Foundation

#if canImport(Darwin)
import Darwin
import OpenAlprMac
#else
import Glibc
import OpenAlprLinux
#endif

@propertyWrapper
struct OneOrMore {
    private var number: Int
    init() { number = 1 }
    var wrappedValue: Int {
        get { number }
        set {
            guard (newValue >= 1) else {
                print("The supplied value must be 1 or greater.")
                return
            }
            number = newValue
        }
    }
}

open class OpenALPR {
    
    // MARK: - Properties
    
    @OneOrMore public var maxRecognisablePlateCount {
        didSet {
            SetTopN(alprInstance, Int32(maxRecognisablePlateCount))
            print("Max recognisable plate number has been canged from \(oldValue) to \(maxRecognisablePlateCount)")
        }
    }
    
    private var countryCode: String
    private var configFile: String
    private var runtimeFilesLocation: String
    private var alprInstance: Alpr
    
    // MARK: - Initializer
    
    init(countryCode: String, configFile: String, runtimeFilesLocation: String) {
        self.countryCode = countryCode
        self.configFile = configFile
        self.runtimeFilesLocation = runtimeFilesLocation
        
        var country = self.countryCode.usableCString
        var configFile = self.configFile.usableCString
        var runtimeFiles = self.runtimeFilesLocation.usableCString
        
        alprInstance = AlprInit(&country, &configFile, &runtimeFiles)
        SetTopN(alprInstance, 1)
    }
    
    // MARK: - Methods
    
    func recogniseBy(filePath: String) throws -> RecognitionResult {
        var cFilePath = filePath.usableCString
        let results = RecognizeByFilePath(alprInstance, &cFilePath)!
        let stringResults = String(cString: results).data(using: .utf8)!
        return try JSONDecoder().decode(RecognitionResult.self, from: stringResults)
    }

    
    func recogniseBy(data: Data) throws -> RecognitionResult {
        var int8ImageBytes = data.reduce(into: []) { $0.append($1) } .map { Int8(bitPattern: $0) }
        let uint8Pointer = UnsafeMutablePointer<Int8>.allocate(capacity: int8ImageBytes.count)
        uint8Pointer.initialize(from: &int8ImageBytes, count: int8ImageBytes.count)

        let results = RecognizeByBlob(self.alprInstance, uint8Pointer, Int32(int8ImageBytes.count * MemoryLayout<UInt8>.size))
        
        let stringResults = String(cString: results!).data(using: .utf8)!
        return try JSONDecoder().decode(RecognitionResult.self, from: stringResults)
    }
}
