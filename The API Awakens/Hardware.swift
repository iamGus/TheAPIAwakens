//
//  Hardware.swift
//  The API Awakens
//
//  Created by Angus Muller on 11/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

enum HardwareType {
    case starship
    case vehicles
}

class Hardware {
    let name: String
    let type: HardwareType
    let make: String
    let cost: Int
    let lengthMeters: Int
    let hardwareClass: String
    let crew: Int
    
    init(name: String, type: HardwareType, make: String, cost: String, hardwareClass: String, crew: String, lengthMeters: String) {
        
        //Try and convert string to Int otherwise value 0
        self.cost = Int(cost) ?? 0
        self.crew = Int(crew) ?? 0
        self.lengthMeters = Int(lengthMeters) ?? 0
        
        self.name = name
        self.type = type
        self.make = make
        self.hardwareClass = hardwareClass
        
    }
}

extension Hardware {
    convenience init?(json: [String: Any], hardwareType: HardwareType) {
        
        struct Key {
            static let swapiName = "name"
            static let swapiMake = "manufacturer"
            static let swapiCost = "cost_in_credits"
            static let swapiLengthM = "length"
            
            static let hhh = hardwareType
            //Determin if class is 
            static let swapiClass = { () -> String in 
                switch hhh {
                case .starship: "ddd"
                case .vehicles: "ddd"
                }
            }()
            static let swapiCrew = "crew"
        }
        
        
        guard let swapiName = json[Key.swapiName] as? String,
            let swapiMake = json[Key.swapiMake] as? String,
            let swapiCost = json[Key.swapiCost] as? String,
            let swapiLengthM = json[Key.swapiLengthM] as? String,
            let swapiCrew = json[Key.swapiCrew] as? String,
        
            let swapiHair = json[Key.swapiHair] as? String else {
                return nil
        }
        
        self.init(name: swapiName, born: swapiBorn, home: swapiHome, heightCm: swapiHeight, eyes: swapiEyes, hair: swapiHair)
    }
}
