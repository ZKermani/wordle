//
//  GuessCell.swift
//  wordle
//
//  Created by Zahra Sadeghipoor on 1/27/22.
//

import UIKit
import QuartzCore

class GuessCell: UITableViewCell {

    @IBOutlet weak var GuessCellView: UIView!
    @IBOutlet weak var Char1: MyTextField!
    @IBOutlet weak var Char5: MyTextField!
    @IBOutlet weak var Char4: MyTextField!
    @IBOutlet weak var Char3: MyTextField!
    @IBOutlet weak var Char2: MyTextField!
    
    @IBAction func char1Changed(_ sender: UITextField) {
        //print("char1Chnged")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // TODO: Refactor the following
        Char1.layer.borderWidth = GuessCellView.frame.height / 20
        Char1.layer.cornerRadius = GuessCellView.frame.height / 10
        
        Char2.layer.borderWidth = GuessCellView.frame.height / 20
        Char2.layer.cornerRadius = GuessCellView.frame.height / 10
        
        Char3.layer.borderWidth = GuessCellView.frame.height / 20
        Char3.layer.cornerRadius = GuessCellView.frame.height / 10
        
        Char4.layer.borderWidth = GuessCellView.frame.height / 20
        Char4.layer.cornerRadius = GuessCellView.frame.height / 10
        
        Char5.layer.borderWidth = GuessCellView.frame.height / 20
        Char5.layer.cornerRadius = GuessCellView.frame.height / 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return false
//    }
}
