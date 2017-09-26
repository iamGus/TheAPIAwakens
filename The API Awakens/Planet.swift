//
//  Planet.swift
//  The API Awakens
//
//  Created by Angus Muller on 25/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

//This is not used, was intending to create a Planet type and init planet JSON through this class but decided not needed.

import Foundation

class Planet {
    let planetName: String
    
    init(planetName: String) {
        self.planetName = planetName
    }
}

extension Planet {
    convenience init?(json: [String: Any]) {
        
        struct Key {
            static let swapiPlanetName = "name"
        }
        
        guard let swapiPlanetName = json[Key.swapiPlanetName] as? String else {
            return nil
        }
        
        if swapiPlanetName == "" {
            return nil
        }
        
        self.init(planetName: swapiPlanetName)
        
    }
    
}
