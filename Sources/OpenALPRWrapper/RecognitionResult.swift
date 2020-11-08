
import Foundation

public struct RegionsOfInterest: Codable {
    let x: UInt
    let y: UInt
    let width: UInt
    let height: UInt
}

public struct Coorindate: Codable {
    let x: UInt
    let y: UInt
}

public struct Candidate: Codable {
    let plate: String
    let confidence: Double
    let matchesTemplate: UInt
    
    enum CustomMappingKey: String, CodingKey {
        case matchesTemplate = "matches_template"
        case confidence = "confidence"
        case plate = "plate"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomMappingKey.self)
        matchesTemplate = try container.decode(UInt.self, forKey: .matchesTemplate)
        confidence = try container.decode(Double.self, forKey: .confidence)
        plate = try container.decode(String.self, forKey: .plate)
    }
}

public struct PlateResult: Codable {
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
        case plate = "plate"
        case confidence = "confidence"
        case matchesTemplate = "matches_template"
        case plateIndex = "plate_index"
        case region = "region"
        case regionConfidence = "region_confidence"
        case processingTimeMs = "processing_time_ms"
        case requestedTopN = "requested_topn"
        case coordinates = "coordinates"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomMappingKey.self)
        plate = try container.decode(String.self, forKey: .plate)
        confidence = try container.decode(Double.self, forKey: .confidence)
        matchesTemplate = try container.decode(UInt.self, forKey: .matchesTemplate)
        plateIndex = try container.decode(UInt.self, forKey: .plateIndex)
        region = try container.decode(String.self, forKey: .region)
        regionConfidence = try container.decode(UInt.self, forKey: .regionConfidence)
        processingTimeMs = try container.decode(Double.self, forKey: .processingTimeMs)
        requestedTopN = try container.decode(UInt8.self, forKey: .requestedTopN)
        coordinates = try container.decode([Coorindate].self, forKey: .coordinates)
    }
}


public struct RecognitionResult: Codable {
    let version: UInt
    let dataType: String
    let epochTime: UInt
    let imgWidth: UInt
    let imgHeight: UInt
    let processingTimeMs: Double
    let regionsOfInterest: [RegionsOfInterest]
    let results: [PlateResult]
    
    enum CustomMappingKey: String, CodingKey {
        case version = "version"
        case dataType = "data_type"
        case epochTime = "epoch_time"
        case imgWidth = "img_width"
        case imgHeight = "img_height"
        case processingTimeMs = "processing_time_ms"
        case regionsOfInterest = "regions_of_interest"
        case results = "results"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomMappingKey.self)
        version = try container.decode(UInt.self, forKey: .version)
        dataType = try container.decode(String.self, forKey: .dataType)
        epochTime = try container.decode(UInt.self, forKey: .epochTime)
        imgWidth = try container.decode(UInt.self, forKey: .imgWidth)
        imgHeight = try container.decode(UInt.self, forKey: .imgHeight)
        processingTimeMs = try container.decode(Double.self, forKey: .processingTimeMs)
        regionsOfInterest = try container.decode([RegionsOfInterest].self, forKey: .regionsOfInterest)
        results = try container.decode([PlateResult].self, forKey: .results)
    }
}
