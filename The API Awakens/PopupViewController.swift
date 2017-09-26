//
//  PopupViewController.swift
//  The API Awakens
//
//  Created by Angus Muller on 14/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

protocol dataEnteredDelegate: class {
    func setExchangeRate(of rate: Double, credits: Int)
}

class PopupViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var invalidRateLabel: UILabel!
    
    weak var delegate: dataEnteredDelegate?
    var currentHardwareCredits: Int = 0 //Keep track of credits cost, default 0 as already done guard let checks on details before passing to this property
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting popup view to rounded edges
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        self.textField.becomeFirstResponder() // Set keyboard to pop up as soon as view loads
        
    }
    // When submit pressed check contents of text field
    @IBAction func submitAndClosePopup(_ sender: Any) {
        if let textField = Double(textField.text!) {
            // If textfield has workable data then send it to setExchange func
            if textField > 0 {
                delegate?.setExchangeRate(of: textField, credits: currentHardwareCredits)
                self.performSegue(withIdentifier: "unwindToDetails", sender: self)
            // Else check for errors
            } else if textField == 0 {
                invalidRateLabel.text = "You cannot have a rate of 0"
                invalidRateLabel.isHidden = false
            } else {
                invalidRateLabel.text = "You cannot have a rate below 0"
                invalidRateLabel.isHidden = false
            }
        } else {
            invalidRateLabel.text = "Please only input numbers"
            invalidRateLabel.isHidden = false
        }
        
    }
    
    //Cancel button closes popup view
    @IBAction func cancelPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
