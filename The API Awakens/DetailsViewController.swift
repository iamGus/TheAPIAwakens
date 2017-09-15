//
//  DetailsViewController.swift
//  The API Awakens
//
//  Created by Angus Muller on 12/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, dataEnteredDelegate {
    
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
    
    @IBOutlet weak var quickFactsSmallestLabel: UILabel!
    @IBOutlet weak var quickFactsLargestLabel: UILabel!
    
    //English and Metric outlets
    @IBOutlet weak var metricLabel: UIButton!
    @IBOutlet weak var englishLabel: UIButton!
    @IBOutlet weak var heading3ResultsFeetLabel: UILabel!

    // Credit and USD button outlets
    @IBOutlet weak var creditsButtonLabel: UIButton!
    @IBOutlet weak var usdButtonLabel: UIButton!
    @IBOutlet weak var heading2ResultsUSDLabel: UILabel!
    
    
    // Property setup
    let client = SwapiAPIClient()
    var starWarsTypeSelected: StarWarsEndpoint?
    var hardwareDataSource = HardwareDataSource()
    let charactersDataSource = CharactersDataSource()
    let numberOfPickerColumns = 1
    
    // Picker properties
    var pickerData: [String] = [String]()
    
    // Value from Exchange popup
    var valueSentFromPopup: Double?
    
    // Value of current cost of corrent selected hardware
    var currentHardwareCostUnits: Int?
    

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
        
        //Pass hardware data to Quick Facts function
        let dataForQuickFacts = hardwareDataSource.nameAndSizeForFacts()
        quickFactsSetup(with: dataForQuickFacts)
        
        //Assign delegate and datasource for picker
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    // Characters setup to do once datasource updated, run by GetDataAndUpdateDataSource()
    func charactersSetups() {
        
        //SetupPicker
        pickerData = charactersDataSource.returnArrayForPicker()
        
        //Pass character data to Quick Facts function
        let dataForQuickFacts = charactersDataSource.nameAndSizeForFacts()
        quickFactsSetup(with: dataForQuickFacts)
        
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
            currencyButtons(isHidden: true) // hide currency buttons as not needed
            sizeButtons(isHidden: true)
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
            currencyButtons(isHidden: true)
            sizeButtons(isHidden: true)
        }
    }
    
    // MARK: - updating labels when a row is selected in picker
    func updateLabels(pickerRow row: Int) {
        guard let starWarsTypeSelected = starWarsTypeSelected else {
            return //ERROR NO TYPE SELECTED
        }
        if starWarsTypeSelected == .character {
            
            let singleCharacterDetails = charactersDataSource.returnSingleCharacter(pickerRow: row)
            TypeNameLabel.text = singleCharacterDetails.name
            label1Results.text = singleCharacterDetails.born
            heading2ResultsLabel.text = singleCharacterDetails.home
            heading3ResultsLabel.text = "\(singleCharacterDetails.heightMeters)m"
            heading4ResultsLabel.text = singleCharacterDetails.eyes
            heading5ResultsLabel.text = singleCharacterDetails.hair
            heading3ResultsFeetLabel.text = "\(singleCharacterDetails.heightFeet)ft"
            sizeButtons(isHidden: false)
            
        } else {
            
            let singleHardwareDetails = hardwareDataSource.returnSingleCharacter(pickerRow: row)
                //Check if cost is 0, if it is then update label to be "Unknown", otherwise return cost
                if singleHardwareDetails.cost == 0 {
                   heading2ResultsLabel.text = "Unknown"
                    heading2ResultsUSDLabel.text = "Unknown"
                    //Hide Unit and USD buttons
                    currencyButtons(isHidden: true)

                } else { //Show cost
                    heading2ResultsLabel.text = String(singleHardwareDetails.cost)
                    currencyButtons(isHidden: false)
                    //Checkig if value in exchange rate from popup, if so means user is currently switch to usd so make sure this label has usd conversion
                    if let exchangeRateValueFromPopup = valueSentFromPopup {
                        heading2ResultsUSDLabel.text = "\(exchangeRateValueFromPopup * Double(singleHardwareDetails.cost))"
                    }
                }
            TypeNameLabel.text = singleHardwareDetails.name
            label1Results.text = singleHardwareDetails.make
            heading3ResultsLabel.text = "\(singleHardwareDetails.lengthMeters)m"
            heading4ResultsLabel.text = singleHardwareDetails.hardwareClass
            heading5ResultsLabel.text = String(singleHardwareDetails.crew)
            heading3ResultsFeetLabel.text = "\(singleHardwareDetails.lengthFeet)ft"
            currentHardwareCostUnits = singleHardwareDetails.cost
            sizeButtons(isHidden: false)
        }
        
    }
    //CAN THIS GO IN SEP FILE
    // Quick facts bar setup
    func quickFactsSetup(with dictionary: [String: Double]) {
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
        
        quickFactsSmallestLabel.text = smallest
        quickFactsLargestLabel.text = largest
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
    
    //Change units
    @IBAction func metricEnglishChange(_ sender: UIButton) {
        if sender == englishLabel {
            heading3ResultsLabel.isHidden = true
            heading3ResultsFeetLabel.isHidden = false
            //sender.setTitleColor(UIColor.white, for: UIControlState.selected)
            englishLabel.titleLabel?.textColor = UIColor.white
            metricLabel.titleLabel?.textColor = UIColor.darkGray
            
        } else if sender == metricLabel {
            metricLabel.titleLabel?.textColor = UIColor.white
            heading3ResultsLabel.isHidden = false
            heading3ResultsFeetLabel.isHidden = true
            englishLabel.titleLabel?.textColor = UIColor.darkGray
        }
    }
    
    //Unwind popup to Details, if exchange rate then show rate and change rate button colours
    @IBAction func unwindToDetailsFromPopup(segue: UIStoryboardSegue) {
        
    }
    
    // Exchange rate popup sends data to this func, then now show this rate on screen
    func setExchangeRate(of rate: Double, unit: Int) {
        valueSentFromPopup = rate
        if let valueJustSentFromPopup = valueSentFromPopup {
            print("I am getting back: \(unit)")
            heading2ResultsUSDLabel.text = "\(valueJustSentFromPopup * Double(unit))"
            heading2ResultsLabel.isHidden = true
            heading2ResultsUSDLabel.isHidden = false
            
        } else {
            //no data been sent ERROR
        }
        
    }
    
    @IBAction func setCostToCredits() {
        creditsButtonLabel.titleLabel?.textColor = UIColor.white
        usdButtonLabel.titleLabel?.textColor = UIColor.darkGray
        heading2ResultsUSDLabel.isHidden = true
        heading2ResultsLabel.isHidden = false
    }
    
    
    // Setup self as value to delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let currentHardwareUnit = currentHardwareCostUnits {
            if let popUpViewController = segue.destination as? PopupViewController {
                popUpViewController.currentHardwareUnit = currentHardwareUnit
                popUpViewController.delegate = self
            }
        } else {
            // STOP segue and show POPUP WARNING MESSAGE THAT NO hardware selccted
        }
    }
    
    //Helper method
    // Set USD and Credit to hidden or not hidden
    func currencyButtons(isHidden: Bool) {
        usdButtonLabel.isHidden = isHidden
        creditsButtonLabel.isHidden = isHidden
    }
    // Set metric and English hidden or not
    func sizeButtons(isHidden: Bool) {
        metricLabel.isHidden = isHidden
        englishLabel.isHidden = isHidden
    }
    

}
