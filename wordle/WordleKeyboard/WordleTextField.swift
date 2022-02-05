//
//  WordleTextField.swift
//  customKeyboard
//
//  Created by Zahra Sadeghipoor on 2/3/22.
//

import Foundation
import UIKit

class WorldleTextField: UITextField, WordleKeyboardObserver {
    func add(_ string: String) {
        self.text?.append(string)
    }
}
