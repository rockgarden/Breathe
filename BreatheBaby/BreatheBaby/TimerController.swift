//
//  ViewController.swift
//  BreathingTimer
//
//  Created by Daniele on 2017-05-16.
//  Copyright © 2017 Daniele Perazzolo. All rights reserved.
//

import UIKit

class TimerController: UIViewController {
    // Values
    let MAX_TIME = 7
    let MIN_TIME = 0
    let PAUSE_TIME = 2
    let pauseText = "Hold"
    var curTime = 0
    var breathDirection = true // (true, in), (false, out)

    // UI Outlets
    @IBOutlet weak var time: UILabel!
    
    @IBAction func syncTimeAndBreath(_ sender: Any) {
        curTime = MIN_TIME + 1
        breathDirection = true
        time.text = "\(curTime)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
        // Breathe In
        if (breathDirection) {
            curTime += 1
            
            // If less than MAX_TIME
            if (curTime < MAX_TIME) {
                time.text = "\(curTime)"
            // If reaching MAX_TIME tell user to hold breathe
            } else if (curTime == MAX_TIME) {
                time.text = pauseText
            // If hold time has passed reverse breathDirection
            } else if (curTime >= MAX_TIME + PAUSE_TIME) {
                breathDirection = false
                curTime = MAX_TIME - 1
                time.text = "\(curTime)"
            } else {
                // DO NOTHING
            }
        // Breath Out
        } else {
            curTime -= 1
            
            // If greater than MIN_TIME
            if (curTime > MIN_TIME) {
                time.text = "\(curTime)"
            // If reaching MIN_TIME tell user to hold
            } else if (curTime == MIN_TIME) {
                time.text = pauseText
            // If hold time has passed reverse breatheDirection
            } else if (curTime <= MIN_TIME - PAUSE_TIME) {
                breathDirection = true
                curTime = MIN_TIME + 1
                time.text = "\(curTime)"
            } else {
                // DO NOTHING
            }
        }
    }
}

