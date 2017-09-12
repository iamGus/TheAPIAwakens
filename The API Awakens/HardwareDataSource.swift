//
//  HardwareDataSource.swift
//  The API Awakens
//
//  Created by Angus Muller on 12/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

class HardwareDataSource {
    
    private var data = [Hardware]()
    
    func update(with hardware: [Hardware]) {
        data = hardware
    }
}
