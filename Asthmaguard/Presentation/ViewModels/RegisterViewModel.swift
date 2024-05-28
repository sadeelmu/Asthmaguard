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
         let username = firstName + lastName
         let token = generateToken()
         if DatabaseManager.shared.addUser(username: username, password: password, email: email, token: token) {
             SessionManager.shared.login(token: token)
             isRegistered = true
         } else {
             print("Failed to register user")
         }
     }

    func registerWithApple() {
        print("Register with Apple")
    }

    func login() {
        // Navigation logic to login screen
    }

    private func generateToken() -> Int {
        return Int.random(in: 100000...999999)
    }
}

