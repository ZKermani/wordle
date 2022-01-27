//
//  MyTextField.swift
//  wordle
//
//  Created by Zahra Sadeghipoor on 1/27/22.
//

// MyTextField.swift
import UIKit

protocol MyTextFieldDelegate: AnyObject {
    func textFieldDidDelete()
}

class MyTextField: UITextField {

    weak var myDelegate: MyTextFieldDelegate?

    override func deleteBackward() {
        super.deleteBackward()
        myDelegate?.textFieldDidDelete()
    }
}
