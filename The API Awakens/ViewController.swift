//
//  ViewController.swift
//  The API Awakens
//
//  Created by Angus Muller on 11/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var charactersLabel: UIButton!
    @IBOutlet weak var vehiclesLabel: UIButton!
    @IBOutlet weak var starshipsLabel: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
   
    // When segue detected find out which segue and set detailsViewController StarWarsType up
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if let destViewController = segue.destination as? DetailsViewController {
            if segue.identifier == "characters" {
                destViewController.starWarsTypeSelected = .character
            } else if segue.identifier == "vehicles" {
                destViewController.starWarsTypeSelected = .vehicles
            } else if segue.identifier == "starships" {
                destViewController.starWarsTypeSelected = .starship
            }
        }
    }
    
    
    //Unwind details beck button to home view controller
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
      
    }

}

