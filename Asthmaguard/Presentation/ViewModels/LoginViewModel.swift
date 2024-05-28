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

    func login() {
        if let user = DatabaseManager.shared.validateUser(email: email, password: password) {
            SessionManager.shared.login(token: user.token)
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





