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
    var correctGuess = false
    let magicWord = ["h", "e", "l", "l", "o"]
    
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
        
        let rowIndex = indexPath.row
        prepareTextField(cell.Char1, rowIndex: rowIndex, textFieldIndex: 0)
        prepareTextField(cell.Char2, rowIndex: rowIndex, textFieldIndex: 1)
        prepareTextField(cell.Char3, rowIndex: rowIndex, textFieldIndex: 2)
        prepareTextField(cell.Char4, rowIndex: rowIndex, textFieldIndex: 3)
        prepareTextField(cell.Char5, rowIndex: rowIndex, textFieldIndex: 4)
        
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
    
    func prepareTextField(_ textField: MyTextField, rowIndex: Int, textFieldIndex: Int) {
        textField.delegate = self
        textField.myDelegate = self
        let word = words[rowIndex]
        textField.text = word[textFieldIndex]
        if correctGuess && rowIndex == activeRow {
            textField.backgroundColor = .green
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == currentTextField {
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidDelete() {
            print("delete")
        if textFieldCounter == numberOfCharacters - 1 {
            if words[activeRow][textFieldCounter] == "" {
                textFieldCounter -= 1
                words[activeRow][textFieldCounter] = ""
            } else {
                words[activeRow][textFieldCounter] = ""
            }
            tableView.reloadData()
        } else {
            if textFieldCounter > 0 {
                textFieldCounter -= 1
                words[activeRow][textFieldCounter] = ""
                tableView.reloadData()
            }
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.hasText {
            print("Text field changed")
            if let text = textField.text {
                words[activeRow][textFieldCounter] = text
            }
           
            if textFieldCounter < numberOfCharacters - 1 {
                textFieldCounter += 1
                tableView.reloadData()

            }

        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("pressed")
        if textFieldCounter == numberOfCharacters - 1 {
            let guess = words[activeRow]
            if guess == magicWord {
                correctGuess = true
                textField.resignFirstResponder()
                tableView.reloadData()
                let alert = UIAlertController(title: "Congratulation!\n This was your best try ever.", message: "You did it!", preferredStyle: .alert)
                self.present(alert, animated: true) {
                    print("done!")
                }
                
            } else {
                textFieldCounter = 0
                activeRow += 1
                textField.resignFirstResponder()
                tableView.reloadData()
            }
            return true
        } else {
            return false
        }
    }
}
