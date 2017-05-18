//
//  ViewController.swift
//  BreathRecognizer
//
//  Created by Jeames Bone on 26/08/2015.
//  Copyright (c) 2015 Jeames Bone. All rights reserved.
//

import UIKit
import BreatheRecognizer

class RecognizerVC: UIViewController {
    var breatheRecognizer: BreatheRecognizer! = nil
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        do {
            try breatheRecognizer = BreatheRecognizer(threshold: -15) { [unowned self] isBreathing in
                if isBreathing {
                    self.bottomConstraint.constant = 300
                } else {
                    self.bottomConstraint.constant = 50
                }
            }
        } catch {
            print("Error initializing breath recognizer")
        }
    }
}

