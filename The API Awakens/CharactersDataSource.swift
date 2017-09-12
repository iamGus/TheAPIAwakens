//
//  CharactersDataSource.swift
//  The API Awakens
//
//  Created by Angus Muller on 12/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

class CharactersDataSource {
    
    private var data = [Characters]()
    
    func update(with characters: [Characters]) {
        data = characters
    }
}

