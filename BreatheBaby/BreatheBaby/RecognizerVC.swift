//
//  RecognizerVC.swift
//  BreatheBaby
//
//  Created by wangkan on 2017/5/22.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit
import BreatheRecognizer

class RecognizerVC: UIViewController {
    
    weak var breatheRecognizer: BreatheRecognizer! = nil
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var breathImage: UIView!
    @IBOutlet weak var notifyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var instructionLabel: UILabel!
    
    var checkTimer: Timer!
    var timeAtPress: Date!
    var isDataCollected = true
    var dataCollected = 0
    var intervalData: Double!
    lazy var breatheData = [BreatheData]()
    
    var phone = "4692659694"
    
    override func viewDidLoad() {
        do {
            // TODO: Swift中的weak、unowned对应Objective-C中的weak、unsafe_unretained，这表明前者在对象释放后 会自动将对象置为nil，而后者依然保持一个“无效的”引用，如果此时调用这个“无效的”引用将会引起程序崩溃。 https://www.douban.com/note/537218897/?type=like
            try breatheRecognizer = BreatheRecognizer(threshold: -15) { [weak self] isBreathing in
                if isBreathing {
                    self?.bottomConstraint.constant = 300
                    if self?.timeAtPress != nil {
                        self?.endTimer()
                    }
                    self?.startTimer()
                } else {
                    self?.bottomConstraint.constant = 50
                }
            }
        } catch {
            print("Error initializing breath recognizer")
        }
        
        breathImage.fadeOut()
        breathImage.fadeIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationItem.title = "prepare"
        
        setupParallax()
    }
    
    private func setupParallax() {
        // Set vertical effect
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -10
        verticalMotionEffect.maximumRelativeValue = 10
        
        // Set horizontal effect
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -10
        horizontalMotionEffect.maximumRelativeValue = 10
        
        // Create group to combine both
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        // Add both effects to your view
        self.view.addMotionEffect(group)
    }
    
    @IBAction func notifyButtonPressed(_ sender: Any) {
        let formatedNumber = self.phone.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        print("calling \(formatedNumber)")
        let phoneUrl = "tel://\(formatedNumber)"
        let url:URL = URL(string: phoneUrl)!
        UIApplication.shared.openURL(url)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.cancelButton.isHidden = true
        self.notifyButton.isHidden = true
        self.isDataCollected = true
        self.dataCollected = 0
        self.intervalData = nil
        self.timeAtPress = nil
        self.checkTimer = nil
        self.instructionLabel.isHidden = false
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RecordsVC {
            vc.data = self.breatheData
        }
    }
    
    func startTimer() {
        timeAtPress = Date()
    }
    
    func endTimer() {
        dataCollected += 1
        print(Date().timeIntervalSince(timeAtPress))
        
        if dataCollected == 1 {
            self.instructionLabel.isHidden = true
            navigationItem.title = "Detected abnormal breathing..."
            intervalData = Date().timeIntervalSince(timeAtPress)
            animate(time: intervalData)
        } else if dataCollected < 5 {
            navigationItem.title = "Recording Data..."
            intervalData = (intervalData + Date().timeIntervalSince(timeAtPress))/2
            animate(time: intervalData)
        } else if dataCollected == 5 {
            navigationItem.title = "Data Recorded..."
            intervalData = (intervalData + Date().timeIntervalSince(timeAtPress))/2
            self.breatheData.insert(BreatheData(date: Date(), interval: intervalData), at: 0)
            animate(time: intervalData)
        } else {
            navigationItem.title = "Everything will be okay..."
            self.isDataCollected = false
            self.cancelButton.isHidden = false
            self.notifyButton.isHidden = false
            
            self.cancelButton.fadeOut()
            self.cancelButton.fadeIn()
            
            self.notifyButton.fadeOut()
            self.notifyButton.fadeIn()
        }
    }
    
    func animate(time: Double) {
        if self.breathImage.layer.animationKeys() == nil {
            let halfTime = time/2
            UIView.animate(withDuration: halfTime, animations: {
                self.breathImage.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            }, completion: { finish in
                UIView.animate(withDuration: halfTime){
                    self.breathImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            })
        }
        
        if intervalData < 4.0 {
            intervalData = intervalData + 0.005
        }
    }
    
    deinit {
        breatheRecognizer = nil
    }
}

