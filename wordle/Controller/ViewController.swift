//
//  ViewController.swift
//  wordle
//
//  Created by Zahra Sadeghipoor on 1/27/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    let cornerRadiusMultiplier = CGFloat(0.01)
    let fontSizeMultiplier = CGFloat(0.05)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        AppUtility.lockOrientation(.portrait)
        
        let screenSize = self.view.frame.size
        playButton.layer.cornerRadius = cornerRadiusMultiplier * screenSize.height
        
        let fontSize = fontSizeMultiplier * screenSize.width
        welcomeLabel.font = welcomeLabel.font.withSize(fontSize)
        
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes = [NSAttributedString.Key.font: font]
        let title = NSAttributedString(string: "START", attributes: attributes)
        playButton.setAttributedTitle(title, for: .normal)
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "StartToGame", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
}

