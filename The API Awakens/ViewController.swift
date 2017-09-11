//
//  ViewController.swift
//  The API Awakens
//
//  Created by Angus Muller on 11/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

let client = SwapiAPIClient()

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        client.getData(type: .character) { [weak self] artist, error in
            if let error = error {
                print(error)
            } else {
                
                for each in artist {
                    print("\(each.name) has a height of \(each.heightCm)")
                }
            }
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

