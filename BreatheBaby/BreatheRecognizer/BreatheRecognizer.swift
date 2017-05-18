//
//  BreathRecognizer.swift
//  BreathRecognizer
//
//  Created by Jeames Bone on 26/08/2015.
//  Copyright (c) 2015 Jeames Bone. All rights reserved.
//

// https://github.com/alexreidy/Digital-Ear

import Foundation
import AVFoundation

open class BreatheRecognizer: NSObject {
    
    /// Threshold in decibels (-160 < threshold < 0)
    let threshold: Float
    var recorder: AVAudioRecorder? = nil

    var isBreathing = false {
        willSet(newBreathing) {
            // Run the callback function only on change
            if isBreathing != newBreathing {
                self.breathFunction(newBreathing)
            }
        }
    }

    var breathFunction: (Bool) -> ()

    public init(threshold: Float, breathFunction: @escaping (Bool) -> ()) throws {
        self.threshold = threshold
        self.breathFunction = breathFunction
        super.init()
        try self.setupAudioRecorder()
    }

    func setupAudioRecorder() throws {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
        try AVAudioSession.sharedInstance().setActive(true)

        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("tmpSound")

        var settings = [String: Any]()
        settings[AVSampleRateKey] = 44100.0
        settings[AVFormatIDKey] = Int(kAudioFormatAppleLossless)
        settings[AVNumberOfChannelsKey] = 1
        settings[AVEncoderAudioQualityKey] = AVAudioQuality.max.rawValue

        try recorder = AVAudioRecorder(url: url, settings: settings)
        recorder?.prepareToRecord()
        recorder?.isMeteringEnabled = true
        recorder?.record()

        Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func tick() {
        if let recorder = recorder {
            recorder.updateMeters()

            /// 计算呼吸时间的平均功率和峰值功率的加权平均值.  a weighted average of the average power and peak power for the time period.
            let average = recorder.averagePower(forChannel: 0) * 0.4
            let peak = recorder.peakPower(forChannel: 0) * 0.6
            let combinedPower = average + peak

            isBreathing = (combinedPower > threshold)
        }
    }
}
