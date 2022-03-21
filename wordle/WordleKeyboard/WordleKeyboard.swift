//
//  WordleKeyboard.swift
//  customKeyboard
//
//  Created by Zahra Sadeghipoor on 2/3/22.
//

import UIKit

// Modified from: https://www.magnuskahr.dk/posts/2019/05/creating-a-custom-input-in-swift/

class WordleKeyboard: UIInputView {
    
    /// Observers telling when keys were hit
    weak var observer: WordleKeyboardObserver?
    var observers: [WordleKeyboardObserver]?
    
    var buttons : [String: KeyboardButton] = [String: KeyboardButton]()
    var keyboardHeight : CGFloat
    let stackViewWidthMultiplier = [0.93, 0.83, 0.83]
    
    func stackViewGenerator(for stackViewCount: Int) -> UIStackView {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.frame = frame
        stackview.spacing = 4
        stackview.alignment = .center
        stackview.distribution = .equalSpacing
        addSubview(stackview)
        //verticalStackView.addSubview(stackview)
            
        stackview.translatesAutoresizingMaskIntoConstraints = false

        let guide = safeAreaLayoutGuide
        let topAnchorOffset = CGFloat(stackViewCount) * keyboardHeight * 0.33;
        var constraints = [
            stackview.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackview.topAnchor.constraint(equalTo: guide.topAnchor, constant: topAnchorOffset),
            stackview.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.30),
            stackview.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: stackViewWidthMultiplier[stackViewCount])
        ]

//        switch UIDevice.current.userInterfaceIdiom {
//            case .phone:
//                constraints.append(stackview.leftAnchor.constraint(equalToSystemSpacingAfter: guide.leftAnchor, multiplier: 1))
//                constraints.append(stackview.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -8))
//            case .pad:
//                constraints.append(stackview.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5))
//                default: break
//        }

        NSLayoutConstraint.activate(constraints)
            
        return stackview 
    }
    
//    private lazy var verticalStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.frame = frame
//        stackView.spacing = 10
//        stackView.distribution = .fillEqually
////        stackView.addArrangedSubview(stackviewRow1)
////        stackView.addArrangedSubview(stackviewRow2)
////        addSubview(stackView)
//        return stackView
//    }()
    
    private lazy var stackviewRow0: UIStackView = {
        
        let stackView = stackViewGenerator(for: 0)
        return stackView
    }()
    
    private lazy var stackviewRow1: UIStackView = {
        
        let stackView = stackViewGenerator(for: 1)
        return stackView
    }()
    
    private lazy var stackviewRow2: UIStackView = {
        
        let stackView = stackViewGenerator(for: 2)
        return stackView
    }()
    
    
    private func addButton(with title: CustomStringConvertible, and formatter: KeyboardButtonFormatter, to stackview: UIStackView) {
        let button = KeyboardButton(title: title, formatter: formatter)
        button.delegate = self
        stackview.addArrangedSubview(button)
        let constraints = [
            button.heightAnchor.constraint(equalTo: stackview.heightAnchor, constant: -2),
            button.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 0.09)
            ]
        NSLayoutConstraint.activate(constraints)
        buttons[title as! String] = button
    }

    func disableButton(with title: String) {
        let button = buttons[title]
        button?.buttonIsEnabled = false
        button?.backgroundColor = .gray
    }
    
    func changeKeyColor(with title: String) {
        print("key is changing color")
        let button = buttons[title.uppercased()]
        button?.color = .gray
        button?.backgroundColor = button?.color
    }
    
    init(keyboardHeight: CGFloat) {
        self.keyboardHeight = keyboardHeight
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: keyboardHeight), inputViewStyle: .keyboard)
        
        self.backgroundColor = .lightGray
        
        let alphabetListRow0 = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
        for alphabet in alphabetListRow0 {
            addButton(with: alphabet, and: NormalKeyButtonFormatter(), to: stackviewRow0)
        }
        
        let alphabetListRow1 = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
        for alphabet in alphabetListRow1 {
            addButton(with: alphabet, and: NormalKeyButtonFormatter(), to: stackviewRow1)
        }
        
        let alphabetListRow2 = ["ENTER", "Z", "X", "C", "V", "B", "N", "M", "Del"]
        for alphabet in alphabetListRow2 {
            addButton(with: alphabet, and: NormalKeyButtonFormatter(), to: stackviewRow2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}


// MARK: - KeyboardButtonDelegate methods
extension WordleKeyboard: KeyboardButtonDelegate {
    func keyWasHit(_ button: KeyboardButton) {
//        guard let title = button.titleLabel?.text else {
//            return
//        }
        
        let title = button.title
        
        if title == "Del" {
            if let safeObserver = observer {
                if let textField = safeObserver as? WorldleTextField {
                    textField.deleteBackward()
                }
            }
            return
        }
        
        if title == "Enter" {
            if let safeObserver = observer {
                if let textField = safeObserver as? WorldleTextField {
                    textField.shouldReturn()
                }
            }
            return
        }
        
        if button.buttonIsEnabled {
            observer?.add(title)
        }
        //print("Did hit \(title)")
    }
}
