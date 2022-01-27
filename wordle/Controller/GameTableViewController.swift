//
//  GameTableViewController.swift
//  wordle
//
//  Created by Zahra Sadeghipoor on 1/27/22.
//

import UIKit

class GameTableViewController: UITableViewController, UITextFieldDelegate, MyTextFieldDelegate {
    
    let numberOfGuesses = 6
    let numberOfCharacters = 5
    var activeRow = 0
    var currentTextField = UITextField()
    var nextTextField = UITextField()
    var textFieldCounter = 0
    var words = [[String]]()
    let magicWord = ["h", "l", "l", "o"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GuessCell", bundle: nil), forCellReuseIdentifier: "reusableCell")
        tableView.separatorStyle = .none
        
        let defaultGuess = ["", "", "", "", ""]
//        let defaultGuess = [" ", " ", " ", " ", " "]
        for _ in 0...numberOfGuesses - 1 {
            words.append(defaultGuess)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numberOfGuesses
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! GuessCell
        cell.Char1.delegate = self
        cell.Char2.delegate = self
        cell.Char3.delegate = self
        cell.Char4.delegate = self
        cell.Char5.delegate = self
        cell.Char1.myDelegate = self
        cell.Char2.myDelegate = self
        cell.Char3.myDelegate = self
        cell.Char4.myDelegate = self
        cell.Char5.myDelegate = self
        
        let word = words[indexPath.row]
        cell.Char1.text = word[0]
        cell.Char2.text = word[1]
        cell.Char3.text = word[2]
        cell.Char4.text = word[3]
        cell.Char5.text = word[4]
        
        if indexPath.row == activeRow {
            switch textFieldCounter {
            case 0:
                currentTextField = cell.Char1
            case 1:
                currentTextField = cell.Char2
            case 2:
                currentTextField = cell.Char3
            case 3:
                currentTextField = cell.Char4
            case 4:
                currentTextField = cell.Char5
            default:
                currentTextField = UITextField()
            }
        }
        currentTextField.becomeFirstResponder()
        return cell
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //tableView.reloadData()
        if textField == currentTextField {
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidDelete() {
            print("delete")
        if textFieldCounter > 0 {
            textFieldCounter -= 1
            words[activeRow][textFieldCounter] = ""
            tableView.reloadData()
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.hasText {
            print("Text field changed")
            if let text = textField.text {
                words[activeRow][textFieldCounter] = text
            }

            if textFieldCounter == numberOfCharacters - 1 {
                // test the guess
                activeRow += 1
                textFieldCounter = 0
                // if activeRow > numberOfGuesse: Better luck next time!
            } else {
                textFieldCounter += 1
            }

            tableView.reloadData()
        }
    }
}
