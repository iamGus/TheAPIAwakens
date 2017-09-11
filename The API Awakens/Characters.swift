//
//  Characters.swift
//  The API Awakens
//
//  Created by Angus Muller on 11/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

class Characters {
    let name: String
    let born: String
    let home: String
    let heightCm: Int
    let eyes: String
    let hair: String
    
    init(name: String, born: String, home: String, heightCm: String, eyes: String, hair: String) {
        
        
        self.heightCm = Int(heightCm) ?? 0 //Try and convert string to Int otherwise value 0
        self.name = name
        self.born = born
        self.home = home
        self.eyes = eyes
        self.hair = hair
    }
}

extension Characters {
    convenience init?(json: [String: Any]) {
        
        struct Key {
            static let swapiName = "name"
            static let swapiBorn = "birth_year"
            static let swapiHome = "homeworld"
            static let swapiHeightCm = "height"
            static let swapiEyes = "eye_color"
            static let swapiHair = "hair_color"
        }
        
        guard let swapiName = json[Key.swapiName] as? String,
        let swapiBorn = json[Key.swapiBorn] as? String,
        let swapiHome = json[Key.swapiHome] as? String,
        let swapiHeight = json[Key.swapiHeightCm] as? String,
        let swapiEyes = json[Key.swapiEyes] as? String,
            let swapiHair = json[Key.swapiHair] as? String else {
                return nil
        }
        
        self.init(name: swapiName, born: swapiBorn, home: swapiHome, heightCm: swapiHeight, eyes: swapiEyes, hair: swapiHair)
    }
}

