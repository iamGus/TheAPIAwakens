//
//  DetailsViewController.swift
//  The API Awakens
//
//  Created by Angus Muller on 12/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    let client = SwapiAPIClient()
    let starWarsTypeSelected: StarWarsEndpoint = .starship
    let hardwareDataSource = HardwareDataSource()
    let charactersDataSource = CharactersDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        client.getData(type: starWarsTypeSelected) { [weak self] starWarsType, error in
            if let error = error {
                print(error)
            } else {
                if let starWarsHardware = starWarsType as? [Hardware] {
                    self?.hardwareDataSource.update(with: starWarsHardware)
                    for each in starWarsHardware {
                        print("\(each.name) has a class of \(each.hardwareClass)")
                    }
                } else if let starWarsCharacters = starWarsType as? [Characters] {
                    for each in starWarsCharacters {
                        print("\(each.name) has a age of \(each.born)")
                    }
                } else {
                    // not in correct StarWars type
                }
            }
        }
    }




}
