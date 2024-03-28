//
//  Companion.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 28/03/2024.
//

import Foundation

class Companion {
    var companionID: Int
    var patientID: String?
    
    init(companionID: Int, patientID: String?) {
        self.companionID = companionID
        self.patientID = patientID
    }
}
