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
    @Published var isRegistered: Bool = false

    
    func register() {
        DatabaseManager.shared.addUser(username: firstName+lastName, password: password, email: email)
        isRegistered = true

    }
    
    func registerWithApple() {
        print("Register with Apple")
    }
    
    func login(){
        
    }
}


