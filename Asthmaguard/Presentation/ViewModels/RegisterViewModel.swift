//
//  RegisterViewModel.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 04/03/2024.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    func register() {
        // Call the addUserAndPatient function from DatabaseManager
        DatabaseManager.shared.addUserAndPatient(userName: firstName + lastName, password: password, email: email)
    }
    
    func registerWithApple() {
        // Implement registration with Apple if needed
        print("Register with Apple")
    }
}


