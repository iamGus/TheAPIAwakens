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
    let home: String
    let heightMeters: Double
    var heightFeet: Double {
        let convertTometers = heightMeters * 3.2808 // convert meters to feet
        return Double(round(100*convertTometers)/100)//round to two didgets precision
    }
    let eyes: String
    let hair: String
    
    init(name: String, born: String, home: String, heightCm: String, eyes: String, hair: String) {
        
      
       let converttometers = Double(heightCm) ?? 0.0 //Try and convert string to Double otherwise value 0
        self.heightMeters = converttometers / 100 // Convert value to meters
        
        //Changing home data from url to planet name
        //V2 addition: note below could be done differently by calling API and storing planet so that if planet allready been called before it does not make another network request but uses already downlaoded data.
        switch home {
            case "https://swapi.co/api/planets/1/": self.home = "Tatooine"
            case "https://swapi.co/api/planets/8/": self.home = "Naboo"
            case "https://swapi.co/api/planets/2/": self.home = "Alderaan"
            case "https://swapi.co/api/planets/20/": self.home = "Stewjon"
            default: self.home = "Unknown"
        }
        
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



