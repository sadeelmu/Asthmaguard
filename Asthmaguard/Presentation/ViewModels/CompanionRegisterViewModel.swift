//
//  CompanionRegisterViewModel.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 12/03/2024.
//

import Foundation

class CompanionRegisterViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var companionReferral: String = ""
    @Published var shouldNavigateToLogin: Bool = false

    func register() {
        // Registration logic here, if needed
        shouldNavigateToLogin = true
    }

    func login() {
        shouldNavigateToLogin = true
    }
}

