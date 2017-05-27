//
//  AppGlobalObject.swift
//  BreatheBaby
//
//  Created by wangkan on 2017/5/26.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import Foundation
import CoreData
import AVFoundation

var managedContext: NSManagedObjectContext? //To be initialized in AppDelegate
var inBackgroundMode = false //是否后台运行

let MAX_REC_DURATION: Double = 5 // seconds
let DOCUMENT_DIR = NSHomeDirectory() + "/Documents/"

let utilAudioSession = AVAudioSession()
var utilAudioRecorder: AVAudioRecorder?
var utilAudioPlayer: AVAudioPlayer?

let DEFAULT_SAMPLE_RATE = 44100
let defaultAudioSettings: [AnyHashable: Any] = [
    AVFormatIDKey: kAudioFormatLinearPCM,
    AVLinearPCMIsFloatKey: true,
    AVNumberOfChannelsKey: 1,
    AVSampleRateKey: DEFAULT_SAMPLE_RATE,
]

var sound = Sound(name: "")
