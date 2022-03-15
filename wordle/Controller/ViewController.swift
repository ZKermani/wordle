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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        AppUtility.lockOrientation(.portrait)
        
        playButton.layer.cornerRadius = playButton.frame.height / 10
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "startToGame", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
}

