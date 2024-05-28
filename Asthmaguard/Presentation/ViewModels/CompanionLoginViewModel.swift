//
//  CompanionLoginViewModel.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 18/05/2024.
//

import Foundation

class CompanionLoginViewModel: ObservableObject {
    @Published var companionReferral: String = ""
    @Published var shouldNavigateToCompanionDashboard: Bool = false
    @Published var shouldNavigateToRegister: Bool = false

    private let hardcodedToken = "123456"

    func login() {
        if companionReferral == hardcodedToken {
            shouldNavigateToCompanionDashboard = true
        } else {
            print("Invalid referral code")
            // Optionally, you can show an alert or some other indication of an invalid referral code
        }
    }

    func register() {
        shouldNavigateToRegister = true
    }
}
