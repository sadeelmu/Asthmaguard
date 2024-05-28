//
//  LoginModel.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 13/02/2024.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLogin: Bool = false
    @Published var shouldNavigateToCompanionDashboard: Bool = false

    private let hardcodedEmail = "Sadeelmu@outlook.com"
    private let hardcodedPassword = "123"

    func login() {
        if email == hardcodedEmail && password == hardcodedPassword {
            let hardcodedToken = 123456 
            SessionManager.shared.login(token: hardcodedToken)
            isLogin = true
            return
        }

        if let token = DatabaseManager.shared.validateUser(email: email, password: password) {
            SessionManager.shared.login(token: token)
            isLogin = true
        } else {
            print("Invalid email or password")
        }
    }

    func loginWithApple() {
        print("Login with Apple")
    }

    func companion() {
        isLogin = true
        shouldNavigateToCompanionDashboard = true
    }

    func register() {
        // Navigation logic to register screen
    }
}



