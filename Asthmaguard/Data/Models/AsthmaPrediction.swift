//
//  AsthmaPrediction.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 28/03/2024.
//

import Foundation

class AsthmaPrediction {
    var serial: Int
    var patientID: Int?
    var timestamp: Date
    var asthmaPredictionValue: Int
    
    init(serial: Int, patientID: Int?, timestamp: Date, asthmaPredictionValue: Int) {
        self.serial = serial
        self.patientID = patientID
        self.timestamp = timestamp
        self.asthmaPredictionValue = asthmaPredictionValue
    }
}
