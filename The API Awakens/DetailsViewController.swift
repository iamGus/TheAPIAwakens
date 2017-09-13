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
    
    @IBOutlet weak var starWarsTypeLabel: UILabel!
    @IBOutlet weak var TypeNameLabel: UILabel!
    //The five headings and results outlets
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label1Results: UILabel!
    @IBOutlet weak var heading2Label: UILabel!
    @IBOutlet weak var heading2ResultsLabel: UILabel!
    @IBOutlet weak var heading3Label: UILabel!
    @IBOutlet weak var heading3ResultsLabel: UILabel!
    @IBOutlet weak var heading4Label: UILabel!
    @IBOutlet weak var heading4ResultsLabel: UILabel!
    @IBOutlet weak var heading5Label: UILabel!
    @IBOutlet weak var heading5ResultsLabel: UILabel!
    
    
    

    
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
        
        //Changes label Headings depending on starWarsType Chosen
        changeLabelHeadings()
        
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
        //Check that a StarWars type ahs been passed from ViewController (not nil)
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
    
    //MARK: - Set label headings text - e.g. when page loads settings headings to character headings or to Hardware headings
    func changeLabelHeadings() {
        guard let starWarsTypeSelected = starWarsTypeSelected else {
            return //ERROR NO TYPE SELECTED
        }
        
        if starWarsTypeSelected == .character {
            starWarsTypeLabel.text = "Characters"
            label1.text = "Born"
            heading2Label.text = "Home"
            heading3Label.text = "Height"
            heading4Label.text = "Eyes"
            heading5Label.text = "Hair"
        } else {
            // Check if Starship or Vehicles and set top heading type
            if starWarsTypeSelected == .starship {
                starWarsTypeLabel.text = "Starships"
            } else {
                starWarsTypeLabel.text = "Vehicles"
            }
            // Set all other headings
            label1.text = "Make"
            heading2Label.text = "Cost"
            heading3Label.text = "Length"
            heading4Label.text = "Class"
            heading5Label.text = "Crew"
        }
    }
    
    // MARK: - updating labels
    func updateLabels(pickerRow row: Int) {
        guard let starWarsTypeSelected = starWarsTypeSelected else {
            return //ERROR NO TYPE SELECTED
        }
        if starWarsTypeSelected == .character {
            let singleCharacterDetails = charactersDataSource.returnSingleCharacter(pickerRow: row)
            TypeNameLabel.text = singleCharacterDetails.name
            label1Results.text = singleCharacterDetails.born
            heading2ResultsLabel.text = singleCharacterDetails.home
            heading3ResultsLabel.text = "\(singleCharacterDetails.heightCm)m"
            heading4ResultsLabel.text = singleCharacterDetails.eyes
            heading5ResultsLabel.text = singleCharacterDetails.hair
            
        } else {
            
            let singleHardwareDetails = hardwareDataSource.returnSingleCharacter(pickerRow: row)
            TypeNameLabel.text = singleHardwareDetails.name
            label1Results.text = singleHardwareDetails.make
            heading2ResultsLabel.text = String(singleHardwareDetails.cost)
            heading3ResultsLabel.text = "\(singleHardwareDetails.lengthMeters)m"
            heading4ResultsLabel.text = singleHardwareDetails.hardwareClass
            heading5ResultsLabel.text = String(singleHardwareDetails.crew)
        }
        
        
        
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
        if row > 0 {
        updateLabels(pickerRow: row)
        }
        return// Add code in here to update details section
    }

}
