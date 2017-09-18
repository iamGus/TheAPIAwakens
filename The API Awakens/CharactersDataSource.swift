//
//  CharactersDataSource.swift
//  The API Awakens
//
//  Created by Angus Muller on 12/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

// Hold dataSource for lifeforms and robots!

class CharactersDataSource {
    
    private var data = [Characters]()
    
    // Update data
    func update(with characters: [Characters]) {
        data = characters
    }
    
    // Return string of names for picker
    func returnArrayForPicker() -> [String] {
        var arrayOfNames = [""]
        for eachCharacter in data {
            arrayOfNames.append(eachCharacter.name)
        }
        return arrayOfNames
    }
    
    // Return name and size for quick facts
    func nameAndSizeForFacts() -> [String: Double] {
        var nameAndSize = [String: Double]()
        for eachCharacter in data {
            nameAndSize[eachCharacter.name] = eachCharacter.heightMeters
        }
        return nameAndSize
    }
    
    //Return single Character details from picker row number
    func returnSingleCharacter(pickerRow row: Int) -> Characters {
        return data[row-1] //row munis one as of array starting 0
    }
    
    //Return
}

