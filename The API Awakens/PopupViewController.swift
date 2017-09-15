//
//  PopupViewController.swift
//  The API Awakens
//
//  Created by Angus Muller on 14/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

protocol dataEnteredDelegate {
    func setExchangeRate(of rate: Double, unit: Int)
}

class PopupViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var invalidRateLabel: UILabel!
    
    var delegate: dataEnteredDelegate?
    var currentHardwareUnit: Int = 0 //Keep track of unit cost, default 0 as done guard let checks on details before passing to this property
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting popup view to rounded edges
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        self.textField.becomeFirstResponder() // Set keyboard to pop up as soon as view loads
        
    }
    // When submit pressed check contents of text field
    @IBAction func submitAndClosePopup(_ sender: Any) {
        if let textField = textField.text, let textFieldIsDouble = Double(textField) {
            print("yay its a number: \(textFieldIsDouble)")
            delegate?.setExchangeRate(of: textFieldIsDouble, unit: currentHardwareUnit)
            self.performSegue(withIdentifier: "unwindToDetails", sender: self)
        } else if textField.text == "" {
            print("Boo tahts not a number")
            invalidRateLabel.text = "Field is empty, enter a rate"
            invalidRateLabel.isHidden = false
        } else {
            print("Boo tahts not a number")
            invalidRateLabel.text = "Sorry invalid exchange rate"
            invalidRateLabel.isHidden = false
        }
        
        
    }
    
    //Cancel button closes popup view
    @IBAction func cancelPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
