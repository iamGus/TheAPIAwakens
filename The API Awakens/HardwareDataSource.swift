//
//  HardwareDataSource.swift
//  The API Awakens
//
//  Created by Angus Muller on 12/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

// Hold datasource for Starships and Vechicles

class HardwareDataSource {
    
    var data = [Hardware]()
    
    // Update data
    func update(with hardware: [Hardware]) {
        data = hardware
    }
    
    // Return string of names for picker
    func returnArrayForPicker() -> [String] {
        var arrayOfNames = [""]
        for eachHardware in data {
            arrayOfNames.append(eachHardware.name)
        }
        return arrayOfNames
    }
    
    //Return request Hardware details from picker row number
    func returnSingleCharacter(pickerRow row: Int) -> Hardware {
        return data[row-1] //row munis one as of array starting 0
    }
}
