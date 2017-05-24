//
//  BreatheData.swift
//  BreathRecognizer
//
//  Created by wangkan on 2017/5/18.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import Foundation

open class BreatheData {
    open var date: Date!
    open var interval : Double!
    
    public init(date: Date, interval: Double) {
        self.date = date
        self.interval = interval
    }
}
