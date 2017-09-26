//
//  Characters.swift
//  The API Awakens
//
//  Created by Angus Muller on 11/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

// Class model to contain Star Wars lifeforms and robots!

class Characters {
    let name: String
    let born: String
    let homeUrl: URLRequest
    var homeName: String = "Unknown"
    let heightMeters: Double
    var heightFeet: Double {
        let convertTometers = heightMeters * 3.2808 // convert meters to feet
        return Double(round(100*convertTometers)/100) // round to two didgets precision
    }
    let eyes: String
    let hair: String
    
    init(name: String, born: String, homeUrl: URL, heightCm: String, eyes: String, hair: String) {
        
      //Convert height cm to meter
       let convertToDouble = Double(heightCm) ?? 0.0 //Try and convert string to Double otherwise value 0
        let convertToMeters = convertToDouble / 100 // Convert value cm to meters
        self.heightMeters = Double(round(100*convertToMeters)/100) // take away decimal 
        
      
        self.homeUrl = URLRequest(url: homeUrl)
        self.name = name
        self.born = born
        self.eyes = eyes
        self.hair = hair
    }
}

// To put json file through to make into Characters type
extension Characters: StarWarsTypes {
    convenience init?(json: [String: Any]) {
        
        struct Key {
            static let swapiName = "name"
            static let swapiBorn = "birth_year"
            static let swapiHome = "homeworld"
            static let swapiHeightCm = "height"
            static let swapiEyes = "eye_color"
            static let swapiHair = "hair_color"
        }
        
        // Check keys from json exist
        guard let swapiName = json[Key.swapiName] as? String,
        let swapiBorn = json[Key.swapiBorn] as? String,
        let swapiHome = json[Key.swapiHome] as? String,
        let swapiHeight = json[Key.swapiHeightCm] as? String,
        let swapiEyes = json[Key.swapiEyes] as? String,
        let swapiHair = json[Key.swapiHair] as? String else {
                return nil
        }
        
        // Check values from json contain data
        if swapiName == "" || swapiBorn == "" || swapiHome == "" || swapiHeight == "" || swapiEyes == "" || swapiHair == "" {
            return nil
        }
        
        // Check that string of planet url can be converted to URL
        guard let homeUrl = URL(string: swapiHome) else {
        return nil
        }
        
        self.init(name: swapiName, born: swapiBorn, homeUrl: homeUrl, heightCm: swapiHeight, eyes: swapiEyes, hair: swapiHair)
    }
}



