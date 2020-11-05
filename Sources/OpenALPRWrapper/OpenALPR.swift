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


struct RegionsOfInterest: Codable {
    let x: UInt
    let y: UInt
    let width: UInt
    let height: UInt
}

struct Coorindate: Codable {
    let x: UInt
    let y: UInt
}

struct Candidate: Codable {
    let plate: String
    let confidence: Double
    let matchesTemplate: UInt
    
    enum CustomMappingKey: String, CodingKey {
        case matchesTemplate = "matches_template"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomMappingKey.self)
        matchesTemplate = try container.decode(UInt.self, forKey: .matchesTemplate)
    }
}

struct PlateResult: Codable {
    let plate: String
    let confidence: Double
    let matchesTemplate: UInt
    let plateIndex: UInt
    let region: String
    let regionConfidence: UInt
    let processingTimeMs: Double
    let requestedTopN: UInt8
    let coordinates: [Coorindate]
    
    enum CustomMappingKey: String, CodingKey {
        case matchesTemplate = "matches_template"
        case plateIndex = "plate_index"
        case regionConfidence = "region_confidence"
        case processingTimeMs = "processing_time_ms"
        case requestedTopN = "requested_topn"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomMappingKey.self)
        matchesTemplate = try container.decode(UInt.self, forKey: .matchesTemplate)
        plateIndex = try container.decode(UInt.self, forKey: .plateIndex)
        regionConfidence = try container.decode(UInt.self, forKey: .regionConfidence)
        processingTimeMs = try container.decode(Double.self, forKey: .processingTimeMs)
        requestedTopN = try container.decode(UInt8.self, forKey: .requestedTopN)
    }
}


struct RecognitionResult: Codable {
    let version: UInt
    let dataType: String
    let epochTime: UInt
    let imgWidth: UInt
    let imgHeight: UInt
    let processingTimeMs: Double
    let regionsOfInterest: [RegionsOfInterest]
    let results: [PlateResult]
    
    enum CustomMappingKey: String, CodingKey {
        case dataType = "data_type"
        case epochTime = "epoch_time"
        case imgWidth = "img_width"
        case imgHeight = "img_height"
        case processingTimeMs = "processing_time_ms"
        case regionsOfInterest = "regions_of_interest"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomMappingKey.self)
        dataType = try container.decode(String.self, forKey: .dataType)
        epochTime = try container.decode(UInt.self, forKey: .epochTime)
        imgWidth = try container.decode(UInt.self, forKey: .imgWidth)
        imgHeight = try container.decode(UInt.self, forKey: .imgHeight)
        processingTimeMs = try container.decode(Double.self, forKey: .processingTimeMs)
        regionsOfInterest = try container.decode([RegionsOfInterest].self, forKey: .regionsOfInterest)
    }
}

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

class OpenALPR {
    
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
    
    func recogniseBy(filePath: String) -> RecognitionResult {
        var cFilePath = filePath.usableCString
        let results = RecognizeByFilePath(alprInstance, &cFilePath)!
//        return String(cString: results)
        // TODO:
        return try RecognitionResult(from: String(cString: results) as! Decoder)
    }

    
    func recogniseBy(data: Data) -> String {
        var int8ImageBytes = data.reduce(into: []) { $0.append($1) } .map { Int8(bitPattern: $0) }
        let uint8Pointer = UnsafeMutablePointer<Int8>.allocate(capacity: int8ImageBytes.count)
        uint8Pointer.initialize(from: &int8ImageBytes, count: int8ImageBytes.count)

        let results = RecognizeByBlob(self.alprInstance, uint8Pointer, Int32(int8ImageBytes.count * MemoryLayout<UInt8>.size))
        
        return String(cString: results!)
    }
}
