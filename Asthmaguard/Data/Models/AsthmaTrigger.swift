//
//  AsthmaTrigger.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 28/03/2024.
//

import Foundation

class AsthmaTrigger {
    var triggerID: Int
    var patientID: Int
    var grade: Int?
    
    init(triggerID: Int, patientID: Int, grade: Int?) {
        self.triggerID = triggerID
        self.patientID = patientID
        self.grade = grade
    }
}
