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
}

class WorldleTextField: UITextField, WordleKeyboardObserver {
    weak var myDelegate: WordleTextFieldDelegate?
    func add(_ string: String) {
        self.text?.append(string)
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        myDelegate?.textFieldDidDelete()
    }
}
