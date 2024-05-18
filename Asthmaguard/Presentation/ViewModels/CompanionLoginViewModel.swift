//
//  CompanionLoginViewModel.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 18/05/2024.
//

import Foundation
class CompanionLoginViewModel:ObservableObject{
    @Published var companionReferral:String = ""
    @Published var shouldNavigateToCompanionDashboard: Bool = false

    func login(){
        print("login")
        shouldNavigateToCompanionDashboard = true
    }
    
    func register(){
    }
}

