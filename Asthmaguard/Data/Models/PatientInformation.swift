//
//  PatientInformation.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 28/03/2024.
//

import Foundation

class PatientInformation {
    var patientID: Int
    var userID: Int
    var name: String
    var dateOfBirth: Date
    var gender: Int
    var height: Int
    var weight: Int
    
    init(patientID: Int, userID: Int, name: String, dateOfBirth: Date, gender: Int, height: Int, weight: Int) {
        self.patientID = patientID
        self.userID = userID
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.height = height
        self.weight = weight
    }
}
