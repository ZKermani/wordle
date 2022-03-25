//
//  GameViewController.swift
//  wordle
//
//  Created by Zahra Sadeghipoor on 3/18/22.
//

import UIKit

import SPConfetti

class GameViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate, WordleTextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let numberOfGuesses = 5
    let numberOfCharacters = 5
    var activeRow = 0
    var currentTextField = UITextField()
    var nextTextField = UITextField()
    var textFieldCounter = 0
    var words = [[String]]()
    var colors = [[UIColor]]()
    var correctGuess = false
    var NLetterWords = [String]()
    var magicWord = [String]()
    
    private let keyboardHeightMultiplier = 0.25
    private let maxKeyboardHeight = 180.0
    var keyboard: WordleKeyboard?
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        keyboard = WordleKeyboard(keyboardHeight: min(view.frame.size.height * keyboardHeightMultiplier, maxKeyboardHeight))
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GuessCell", bundle: nil), forCellReuseIdentifier: "reusableCell")
        tableView.separatorStyle = .none
        
        let defaultGuess = ["", "", "", "", ""]
        let defaultColor = [UIColor]( repeating: .white, count: numberOfCharacters)
        for _ in 0...numberOfGuesses - 1 {
            words.append(defaultGuess)
            colors.append(defaultColor)
        }
        
        loadWords()
        resetGame()
        assignTextFieldInputView()
        
    }
    
    @objc func willEnterForeground() {
        if correctGuess || ( activeRow == numberOfGuesses - 1 && textFieldCounter == numberOfCharacters - 1) {
            // Reset the game only if the game was over before user left the app.
            let defaultGuess = ["", "", "", "", ""]
            let defaultColor = [UIColor]( repeating: .white, count: numberOfCharacters)
            for _ in 0...numberOfGuesses - 1 {
                words.append(defaultGuess)
                colors.append(defaultColor)
            }
            resetGame()
            assignTextFieldInputView()
        }
    }
    
    func assignTextFieldInputView() {
        for row in 0..<numberOfGuesses {
            let indexPath = IndexPath(row: row, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! GuessCell
            cell.Char1.inputView = keyboard
            cell.Char2.inputView = keyboard
            cell.Char3.inputView = keyboard
            cell.Char4.inputView = keyboard
            cell.Char5.inputView = keyboard
        }
    }
    
    func loadWords() {
        
        NLetterWords = enDictionary
        
//        let fileName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("dictionary.txt") // the file is created using osDictionary.txt file
//
////        let fileName2 = URL(fileURLWithPath: "/Users/Zahra/Documents/Work:Personal/Learning/iOS_Swift/MyApps/wordle/wordle/osDictionary.txt")
//
//        do {
//            //let text = try String(contentsOf: fileName)
//            let text = try String(contentsOf: fileName)
////            do {
////                try text.write(to: fileName, atomically: true, encoding: String.Encoding.utf8)
////            } catch {
////                print("error writing to file \(error)")
////            }
//
//            //print(text.count)
//            let words = text.split(whereSeparator: \.isNewline)
//            //print(words.count)
//            NLetterWords = words.filter{ $0.count == numberOfCharacters}
//            print(NLetterWords.count)
//        } catch {
//            print("error reading file \(error)")
//        }
    }
    
    func resetGame() {
        
        keyboard?.resetKeyColors()
        
        activeRow = 0
        textFieldCounter = 0
        correctGuess = false
        let defaultGuess = ["", "", "", "", ""]
        let defaultColor = [UIColor]( repeating: .white, count: numberOfCharacters)
        for i in 0...numberOfGuesses - 1 {
            words[i]  = defaultGuess
            colors[i] = defaultColor
        }
        let randomWord = NLetterWords.randomElement()!
        magicWord = [String]()
        for char in randomWord {
            magicWord.append(String(char))
        }
        print(magicWord)
        tableView.reloadData()
        updateCurrentTextField()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numberOfGuesses
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! GuessCell
        
        let rowIndex = indexPath.row
        prepareTextField(cell.Char1, rowIndex: rowIndex, textFieldIndex: 0)
        prepareTextField(cell.Char2, rowIndex: rowIndex, textFieldIndex: 1)
        prepareTextField(cell.Char3, rowIndex: rowIndex, textFieldIndex: 2)
        prepareTextField(cell.Char4, rowIndex: rowIndex, textFieldIndex: 3)
        prepareTextField(cell.Char5, rowIndex: rowIndex, textFieldIndex: 4)
       return cell
    }
    
    func prepareTextField(_ textField: WorldleTextField, rowIndex: Int, textFieldIndex: Int) {
        textField.delegate = self
        textField.myDelegate = self
        //textField.inputView = keyboard
        
        let word = words[rowIndex]
        textField.text = word[textFieldIndex]
        
        let color = colors[rowIndex]
        textField.backgroundColor = color[textFieldIndex]
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == currentTextField {
            keyboard!.observer = textField as! WorldleTextField
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidDelete() {
        if textFieldCounter == numberOfCharacters - 1 {
            if words[activeRow][textFieldCounter] == "" {
                textFieldCounter -= 1
                words[activeRow][textFieldCounter] = ""
            } else {
                words[activeRow][textFieldCounter] = ""
            }
        } else {
            if textFieldCounter > 0 {
                textFieldCounter -= 1
                words[activeRow][textFieldCounter] = ""
            }
        }
        
        DispatchQueue.main.async {
            self.updateCurrentTextField()
        }
        tableView.reloadData()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {

       if textField.hasText {
            if let text = textField.text {
                words[activeRow][textFieldCounter] = text

                if textFieldCounter < numberOfCharacters - 1 {
                    textFieldCounter += 1
                    tableView.reloadData()
                    DispatchQueue.main.async {
                        self.updateCurrentTextField()
                    }
                }
            }
        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if textField.text?.isEmpty == true && !string.isEmpty {
//
//            textField.text = string
//            words[activeRow][textFieldCounter] = string
//
//            if textFieldCounter < numberOfCharacters - 1 {
//                textFieldCounter += 1
//                //tableView.reloadData()
//            }
//
//            updateCurrentTextField()
//
//            return false
//        }
//
////        if textField.text?.isEmpty == false {
////            return false
////        }
//
//        return true
//    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textFieldCounter == numberOfCharacters - 1 {
            checkGuess(textField)
            return true
        } else {
            return false
        }
    }
    
    
     func enterWasPressed() {
         
         if textFieldCounter == numberOfCharacters - 1 {
             let textField = UITextField()
             checkGuess(textField)
         }
     }
    
    func checkGuess(_ textField: UITextField) {
        
        var guess = words[activeRow]
        for i in 0..<guess.count {
            guess[i] = guess[i].lowercased()
        }
        
        // check if the word is in dictionary
        let guessWord = guess.joined(separator: "")
        if NLetterWords.contains(guessWord) {
            
            // Change colors according to the guess/magic word similarity
            for count in 0...numberOfCharacters - 1 {
                let char = guess[count]
                var color = UIColor()
                if magicWord.contains(char) {
                    color = .orange
                    if char == magicWord[count] {
                        color = .green
                    }
                } else {
                    colors[activeRow][count] = .gray
                    color = .gray
                }
                
                colors[activeRow][count] = color
                self.keyboard!.changeColorFor(key: char, to: color)
            }
            
            if guess == magicWord { // game is won
                
                correctGuess = true
                //textField.resignFirstResponder()
                tableView.reloadData()
                
                let alert = endOfGameAlert(title: "Congratulation!\n You are a genius.",
                                           message: "")
                self.present(alert, animated: true, completion: nil)
                SPConfetti.startAnimating(.fullWidthToDown,
                                          particles: [.triangle, .star, .arc, .circle, .polygon, .heart],
                                          duration: 5.0)
                
            } else {
                
                if activeRow == numberOfGuesses - 1 { // game over
                    let alert = endOfGameAlert(title: "Game Over!\n Better luck next time.",
                                               message: "You're not that smart!")
                    self.present(alert, animated: true, completion: nil)
                    
                } else { // can still play
                    
                    textFieldCounter = 0
                    activeRow += 1
                    tableView.reloadData()
                    updateCurrentTextField()
                    
                }
            }
            
        } else {
            let alert = UIAlertController(title: "That is not a word!", message: "Try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.updateCurrentTextField()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func endOfGameAlert(title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let playAgainAction = UIAlertAction(title: "Play again", style: .default, handler: { action in
            self.resetGame()
        })
        let cancelAction = UIAlertAction(title: "I'm done", style: .default, handler: { action in
            // apparently the app is not supposed to quit itself. Only the user is in control of doing so by "pressing the home button" for instance.
            //exit(0)
        })
        
        alert.addAction(playAgainAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    func updateCurrentTextField() {
        let indexPath = IndexPath(row: self.activeRow, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! GuessCell
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
        currentTextField.becomeFirstResponder()
    }
    
}
