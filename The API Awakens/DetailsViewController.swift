//
//  DetailsViewController.swift
//  The API Awakens
//
//  Created by Angus Muller on 12/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Outlets
    @IBOutlet weak var pickerView: UIPickerView!

    
    // Property setup
    let client = SwapiAPIClient()
    var starWarsTypeSelected: StarWarsEndpoint?
    var hardwareDataSource = HardwareDataSource()
    let charactersDataSource = CharactersDataSource()
    let numberOfPickerColumns = 1
    
    // Picker properties
    var pickerData: [String] = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Calls API and puts data into datasource
        GetDataAndUpdateDataSource()
    
    }

   
    // Helper Methods
    
    // Hardware setups to do once datasource updated, run by GetDataAndUpdateDataSource()
    func hardwareSetups() {
        
        //SetupPicker
        pickerData = hardwareDataSource.returnArrayForPicker()
        //Assign delegate and datasource for picker
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    // Characters setup to do once datasource updated, run by GetDataAndUpdateDataSource()
    func charactersSetups() {
        
        //SetupPicker
        pickerData = charactersDataSource.returnArrayForPicker()
        //Assign delegate and datasource for picker
        pickerView.delegate = self
        pickerView.dataSource = self
    }
   
    
    // MARK: - Calls API and puts data into datasource
    func GetDataAndUpdateDataSource() {
        guard let starWarsTypeSelected = starWarsTypeSelected else {
            return print("No type selected") //NEED BETTER ERROR HANDLING
        }
        client.getData(type: starWarsTypeSelected) { [weak self] starWarsType, error in
            if let error = error {
                print(error) // NEED MORE ERROR POPUPS
            } else if starWarsType.isEmpty {
                print("Array is empty") // NEED ERROR POPUPS
                } else {
                if let starWarsHardware = starWarsType as? [Hardware] {
                    self?.hardwareDataSource.update(with: starWarsHardware)
                    self?.hardwareSetups()
                    //for each in starWarsHardware {
                    //    print("\(each.name) has a class of \(each.hardwareClass)")
                    //}
                } else if let starWarsCharacters = starWarsType as? [Characters] {
                    self?.charactersDataSource.update(with: starWarsCharacters)
                    self?.charactersSetups()
                    //for each in starWarsCharacters {
                    //    print("\(each.name) has a age of \(each.born)")
                    //}
                } else {
                    // not in correct StarWars type
                    // NEED ERROR POPUPS
                }
            }
        }
    }
    
    
    @IBAction func backButton() {
    }
    
 

 // MARK: - Picker view Data Sources and delegates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfPickerColumns
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return // Add code in here to update details section
    }

}
