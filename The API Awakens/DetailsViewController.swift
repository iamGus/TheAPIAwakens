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
    
    // The five headings and results outlets
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
    
    // English and Metric outlets
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
    var pickerData: [String] = [String]() // Picker properties
    var valueSentFromPopup: Double? // Value from Currency Exchange popup
    var currentHardwareCostCredits: Int? // Value of current cost of current selected hardware
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup label Headings depending on starWarsType Chosen
        setupLabelHeadings()
        
        //Calls API and puts data into datasource
        GetDataAndUpdateDataSource()
    }
    
    
    // MARK: - Call API and put data into datasource
    func GetDataAndUpdateDataSource() {
        //Check that a StarWars type has been passed from ViewController (not nil)
        guard let starWarsTypeSelected = starWarsTypeSelected else {
            showAlert(title: "Error", message: "No Star Wars type has been selected")
            return
        }
        client.getData(type: starWarsTypeSelected) { [weak self] starWarsType, error in
            if let error = error {
                
                //Error catching note: Though in this project I have made all errors appear on-screen, in a production app a lot of these network error would probably be dealt without user interaction.
                switch error {
                case .requestFailed: self?.showAlert(title: "Error", message: "Sorry data request failed, please go back and try again. Also check you have a data connection")
                case .jsonConversionFailure: self?.showAlert(title: "Error", message: "Could not convert data from web")
                case .invalidData: self?.showAlert(title: "Error", message: "Data from web is invalid")
                case .responseUnsuccessful: self?.showAlert(title: "Error", message: "Retrieving data from web unsuccessful")
                case .jsonParsingFailure(let message): self?.showAlert(title: "Error", message: "\(message)")
                }
                
            } else if starWarsType.isEmpty {
                self?.showAlert(title: "Error", message: "No data from web, most likely cause missing key or value from web.")
            } else {
            //If API is successful and returns data, find out what data it is.
                
                // Set Hardware Datasource
                if let starWarsHardware = starWarsType as? [Hardware] {
                    self?.hardwareDataSource.update(with: starWarsHardware)
                    self?.hardwareSetups()
                   
                // Set Character Datasource
                } else if let starWarsCharacters = starWarsType as? [Characters] {
                    self?.charactersDataSource.update(with: starWarsCharacters)
                    
                    self?.charactersSetups()
                   
                } else {
                    self?.showAlert(title: "App Error", message: "Could not detect a valid Star Wars type")
                }
            }
        }
    }
    
    // If Starship or Vehicle: Do hardware setups, run by GetDataAndUpdateDataSource()
    func hardwareSetups() {
        
        //SetupPicker
        pickerData = hardwareDataSource.returnArrayForPicker()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //Pass hardware data to Quick Facts function and set quick fact labels
        let dataForQuickFacts = hardwareDataSource.nameAndSizeForFacts()
        let smallestAndLargest = Helper().quickFactsSetup(with: dataForQuickFacts)
        quickFactsSmallestLabel.text = smallestAndLargest.smallest
        quickFactsLargestLabel.text = smallestAndLargest.largest
    }
    
    // If Character: Do characters setups, run by GetDataAndUpdateDataSource()
    func charactersSetups() {
        
        //SetupPicker
        pickerData = charactersDataSource.returnArrayForPicker()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //Pass hardware data to Quick Facts function and set quick fact labels
        let dataForQuickFacts = charactersDataSource.nameAndSizeForFacts()
        let smallestAndLargest = Helper().quickFactsSetup(with: dataForQuickFacts)
        quickFactsSmallestLabel.text = smallestAndLargest.smallest
        quickFactsLargestLabel.text = smallestAndLargest.largest
    }
    
    //MARK: - Set label headings text
    //When page loads set headings to character headings or to Hardware headings
    func setupLabelHeadings() {
        guard let starWarsTypeSelected = starWarsTypeSelected else {
            return //This error handling notification to user has already been handled in API call above so no need to do anything here.
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
    
    // MARK: - Update headings and content
    // updating labels when a row is selected from picker
    func updateLabels(pickerRow row: Int) {
        guard let starWarsTypeSelected = starWarsTypeSelected else {
            return //This error handling notification to user already been handled in API call above so no need to anything here.
        }
        if starWarsTypeSelected == .character {
            
            let singleCharacterDetails = charactersDataSource.returnSingleCharacter(pickerRow: row)
            TypeNameLabel.text = singleCharacterDetails.name
            label1Results.text = singleCharacterDetails.born
            heading2ResultsLabel.text = singleCharacterDetails.homeName
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
                    //Checking if there is a value in exchange rate from the popup, if so it means user is currently switched to usd so make sure this label has usd conversion showing
                    if let exchangeRateValueFromPopup = valueSentFromPopup {
                        heading2ResultsUSDLabel.text = Helper().exchangeConverter(exchangeRate: exchangeRateValueFromPopup, credits: singleHardwareDetails.cost)
                    }
                }
            
            TypeNameLabel.text = singleHardwareDetails.name
            label1Results.text = singleHardwareDetails.make
            heading3ResultsLabel.text = "\(singleHardwareDetails.lengthMeters)m"
            heading4ResultsLabel.text = singleHardwareDetails.hardwareClass
            heading5ResultsLabel.text = String(singleHardwareDetails.crew)
            heading3ResultsFeetLabel.text = "\(singleHardwareDetails.lengthFeet)ft"
            currentHardwareCostCredits = singleHardwareDetails.cost
            sizeButtons(isHidden: false)
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
        return
    }
    
    //Change units to British or Metric units
    @IBAction func metricEnglishChange(_ sender: UIButton) {
        if sender == englishLabel {
            heading3ResultsLabel.isHidden = true
            heading3ResultsFeetLabel.isHidden = false
            englishLabel.setTitleColor(UIColor.white, for: .normal)
            metricLabel.setTitleColor(UIColor.darkGray, for: .normal)
            
        } else if sender == metricLabel {
            metricLabel.setTitleColor(UIColor.white, for: .normal)
            heading3ResultsLabel.isHidden = false
            heading3ResultsFeetLabel.isHidden = true
            englishLabel.setTitleColor(UIColor.darkGray, for: .normal)
        }
    }
    
    //Unwind popup to Details
    @IBAction func unwindToDetailsFromPopup(segue: UIStoryboardSegue) {
    }
    
    // Exchange rate popup sends data to this func, show USD on screen
    func setExchangeRate(of rate: Double, credits: Int) {
        valueSentFromPopup = rate // set in general property so can be used later
        if let valueJustSentFromPopup = valueSentFromPopup { // if valueSentFromRate has value then show value on screen and set buttons styles
            heading2ResultsUSDLabel.text = Helper().exchangeConverter(exchangeRate: valueJustSentFromPopup, credits: credits)
            heading2ResultsLabel.isHidden = true
            heading2ResultsUSDLabel.isHidden = false
            usdButtonLabel.setTitleColor(UIColor.white, for: .normal)
            creditsButtonLabel.setTitleColor(UIColor.darkGray, for: .normal)
            
        } else {
            showAlert(title: "Error", message: "Error reading exchange rate, please try again")
        }
        
    }
    
    // If Credits button clicked then show credit figure and change style of buttons
    @IBAction func setCostToCredits() {
        creditsButtonLabel.setTitleColor(UIColor.white, for: .normal)
        usdButtonLabel.setTitleColor(UIColor.darkGray, for: .normal)
        heading2ResultsUSDLabel.isHidden = true
        heading2ResultsLabel.isHidden = false
    }
    
    
    // Setup self as value to delegate and check if a hardware has been selected before trying to show Exchange popup.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "popup") {
            if let currentHardwareCredits = currentHardwareCostCredits {
                if let popUpViewController = segue.destination as? PopupViewController {
                    popUpViewController.currentHardwareCredits = currentHardwareCredits
                    popUpViewController.delegate = self
                }
            // Means no current hardware selection so stop and show error of no item selected. This should not happen due to exchange rate button hiding if no hardware selected but in here just in case.
            } else {
                showAlert(title: "Error", message: "No Star Wars hardware selected, please first choose one")
            }
        }
    }
    
    // MARK: - Other helper method
    
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
    
    // Generic alert pop up function used for all error handling notifications
    func showAlert(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    

}
