//
//  Helper.swift
//  The API Awakens
//
//  Created by Angus Muller on 15/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

// Helper methods for Details View Controller

class Helper {
    
    // Quick facts bar setup
    func quickFactsSetup(with dictionary: [String: Double]) -> (smallest: String, largest: String){
        var smallest = ""
        var largest = ""
        for (key, value) in dictionary {
            if value == dictionary.values.min() {
                smallest = key
            } else if value == dictionary.values.max() {
                largest = key
            } else {
                
            }
        }
        
        return (smallest, largest)
    }
    
    //Exchange rate converter
    func exchangeConverter(exchangeRate rate: Double, credits:Int) -> String {
        let convertNumber = Double(credits) * rate
        return String(format: "$%.0f", convertNumber)
    }
}

