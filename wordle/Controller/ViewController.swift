//
//  ViewController.swift
//  wordle
//
//  Created by Zahra Sadeghipoor on 1/27/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        AppUtility.lockOrientation(.portrait)
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

