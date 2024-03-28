//
//  User.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 28/03/2024.
//

import Foundation

class User {
    var id: Int
    var username: String
    var password: String
    var email: String
    var creationDate: Date
    var appleID: String?
    var referralCode: String
    
    init(id: Int, username: String, password: String, email: String, creationDate: Date, appleID: String?, referralCode: String) {
        self.id = id
        self.username = username
        self.password = password
        self.email = email
        self.creationDate = creationDate
        self.appleID = appleID
        self.referralCode = referralCode
    }
}
