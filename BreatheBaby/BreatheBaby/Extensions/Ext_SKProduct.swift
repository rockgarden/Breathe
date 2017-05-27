//
//  Ext_SKProduct.swift
//  BreatheBaby
//
//  Created by wangkan on 2017/5/27.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import StoreKit
extension SKProduct {
    // Thanks to Ben Dodson
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)!
    }
    
}
