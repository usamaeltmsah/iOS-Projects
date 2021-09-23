//
//  ViewController.swift
//  Tipsy
//
//  Created by Angela Yu on 09/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet var billTextField: UITextField!
    @IBOutlet var zeroPctButton: UIButton!
    @IBOutlet var tenPctButton: UIButton!
    @IBOutlet var twentyPctButton: UIButton!
    @IBOutlet var splitNumberLabel: UILabel!
    var billValue: Double?
    var tipValue: Double = 0.1
    var splitValue: Double = 2
    var billValWithTip: Double = 0
    var tipsForEach: Double = 0
    
    @IBAction func tipChanged(_ sender: UIButton) {
        billTextField.endEditing(true)
        switch sender {
        case zeroPctButton:
            tipValue = 0.0
            zeroPctButton.isSelected = true
            tenPctButton.isSelected = false
            twentyPctButton.isSelected = false
        case tenPctButton:
            tipValue = 0.1
            tenPctButton.isSelected = true
            zeroPctButton.isSelected = false
            twentyPctButton.isSelected = false
        case twentyPctButton:
            tipValue = 0.2
            twentyPctButton.isSelected = true
            zeroPctButton.isSelected = false
            tenPctButton.isSelected = false
        default:
            return
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        splitValue = sender.value
        splitNumberLabel.text = String(format: "%.f", splitValue)
    }
    
    @IBAction func calculatePressed(_ sender: Any) {
        billValue = Double(billTextField.text ?? "0.0")
        if let billValue = billValue {
            billValWithTip = billValue + billValue * tipValue
            tipsForEach = billValWithTip / splitValue
            performSegue(withIdentifier: "resultSegue", sender: self)
        }
    }
    
    func getTipsForEach() -> String {
        return String(format: "%.2f", tipsForEach)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultSegue" {
            let destinationVC = segue.destination as? ResultsViewController
            destinationVC?.total = getTipsForEach()
        }
    }
}

