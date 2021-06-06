//
//  UnitSetting.swift
//  Z4Cast
//
//  Created by Ethan Yu on 6/5/21.
//  Copyright © 2021 Yutopia Productions. All rights reserved.
//

import Foundation

//Store user defaults for units
class UnitSetting {
    
    let unitKey = "unitKey"
    let uDefaults = UserDefaults.standard
    
    //Unit Mutator
    func setUnit(unit: String) {
        uDefaults.set(unit, forKey: unitKey)
    }
    
    //Unit Accessor
    func getUnit() -> String {
        if let output = uDefaults.string(forKey: unitKey) {
            return output
        } else {
            return ""
        }
    }
}
