//
//  WordleTextField.swift
//  customKeyboard
//
//  Created by Zahra Sadeghipoor on 2/3/22.
//

import Foundation
import UIKit

protocol WordleTextFieldDelegate: AnyObject {
    func textFieldDidDelete()
    func enterWasPressed()
}

class WorldleTextField: UITextField, WordleKeyboardObserver {
    weak var myDelegate: WordleTextFieldDelegate?
    func add(_ string: String) {
        if self.text?.isEmpty == true { // accept only one character in each text field
            self.text?.append(string)
        }
    }
    
    override func deleteBackward() {
        //super.deleteBackward()
        myDelegate?.textFieldDidDelete()
    }
    
    func shouldReturn() {
        myDelegate?.enterWasPressed()
    }
}
