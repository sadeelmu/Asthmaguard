//
//  BiometricData.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 28/03/2024.
//

import Foundation
class BiometricData {
    var serial: Int
    var triggerID: Int
    var value: Int
    
    init(serial: Int, triggerID: Int, value: Int) {
        self.serial = serial
        self.triggerID = triggerID
        self.value = value
    }
}

///Biosginals
