//
//  KeyboardButton.swift
//
//  Created by Magnus Jensen on 17/02/2019.
//  Copyright © 2019 Magnus Jensen. All rights reserved.
//
import UIKit

protocol KeyboardButtonDelegate: class {
    func keyWasHit(_ button: KeyboardButton)
}

class KeyboardButton: UIButton {
    
    var buttonIsEnabled: Bool = true
    var title: String = ""
    var color: UIColor = .white
    private let formatter: KeyboardButtonFormatter
    weak var delegate: KeyboardButtonDelegate?
    
    override var isHighlighted: Bool {
        didSet {
            formatter.applyHightlight(isHighlighted, to: self)
        }
    }
    
    init(title: CustomStringConvertible, formatter: KeyboardButtonFormatter) {
        self.formatter = formatter
        self.title = title.description
        
        super.init(frame: .zero)
                      
        if title.description == "Del" {
            self.contentMode = .center
            self.setImage(UIImage(systemName: "delete.left"), for: .normal)
            self.tintColor = .black
        } else {
            self.setTitle(title.description, for: .normal)
        }
        
        self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote) //.title2)
        self.formatter.applyStyle(to: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonClicked() {
        guard let delegate = delegate else {
            return
        }
        
        delegate.keyWasHit(self)
    }
}

protocol KeyboardButtonFormatter {
    func applyStyle(to button: KeyboardButton)
    func applyHightlight(_ isHighlighted: Bool, to button: KeyboardButton)
}

struct NormalKeyButtonFormatter: KeyboardButtonFormatter {
    func applyStyle(to button: KeyboardButton) {
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = button.color //.white
        button.layer.cornerRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 0
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.25
    }
    
    func applyHightlight(_ isHighlighted: Bool, to button: KeyboardButton) {
        button.backgroundColor = isHighlighted ? UIColor(red:0.66, green:0.69, blue:0.73, alpha:1.00) : button.color
    }
}

struct SpecielKeyButtonFormatter: KeyboardButtonFormatter {
    func applyStyle(to button: KeyboardButton) {
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red:0.66, green:0.69, blue:0.73, alpha:1.00)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 0
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.25
    }
    
    func applyHightlight(_ isHighlighted: Bool, to button: KeyboardButton) {
        button.backgroundColor = isHighlighted ? .white : UIColor(red:0.66, green:0.69, blue:0.73, alpha:1.00)
    }
}
