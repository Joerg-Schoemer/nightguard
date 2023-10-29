//
//  CarbsTreatment.swift
//  nightguard
//
//  Created by Dirk Hermanns on 14.02.21.
//  Copyright © 2021 private. All rights reserved.
//

import Foundation

// Treatment that happens whenever a meal bolus is delivered
class MealBolusTreatment : Treatment {
    
    public let carbs : Int
    public let insulin : Double
    
    public init(id : String, timestamp: Double, carbs : Int, insulin : Double) {
        
        self.carbs = carbs
        self.insulin = insulin
        
        super.init(id: id, timestamp: timestamp)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case timestamp
        case carbs
        case insulin
    }
    
    /*
        Code to deserialize Treatment content. The error handling is needed in case that old serialized
        data leads to an error.
    */
    required init(coder decoder: NSCoder) {

        self.carbs = decoder.decodeInteger(forKey: "carbs")
        self.insulin = decoder.decodeDouble(forKey: "insulin")
        
        super.init(coder: decoder)
    }
    
    /*
     Code to serialize the treatment to store them in UserDefaults.
     */
    override func encode(with aCoder: NSCoder) {
        
        super.encode(with: aCoder)
        
        aCoder.encode(self.carbs, forKey: "carbs")
        aCoder.encode(self.insulin, forKey: "insulin")
    }
    
    // MARK:- Codable interface implementation
    
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.carbs = try container.decode(Int.self, forKey: .carbs)
        self.insulin = try container.decode(Double.self, forKey: .insulin)
        
        try super.init(from: decoder)
    }
    
    /// Encodes this value into the given encoder.
    ///
    /// If the value fails to encode anything, `encoder` will encode an empty
    /// keyed container in its place.
    ///
    /// This function throws an error if any values are invalid for the given
    /// encoder's format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.carbs, forKey: .carbs)
        try container.encode(self.insulin, forKey: .insulin)
    }
}
