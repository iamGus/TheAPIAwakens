//
//  CharactersDataSource.swift
//  The API Awakens
//
//  Created by Angus Muller on 12/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

// Hold dataSource for lifefoms and robots!

class CharactersDataSource {
    
    private var data = [Characters]()
    
    // Update data
    func update(with characters: [Characters]) {
        data = characters
    }
    
    // Return string of names for picker
    func returnArrayForPicker() -> [String] {
        var arrayOfNames = [""]
        for eachHardware in data {
            arrayOfNames.append(eachHardware.name)
        }
        return arrayOfNames
    }
}

