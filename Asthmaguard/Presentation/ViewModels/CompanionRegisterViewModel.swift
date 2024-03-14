//
//  CompanionRegisterViewModel.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 12/03/2024.
//

import Foundation

class CompanionRegisterViewModel:ObservableObject{
    @Published var firstName:String = ""
    @Published var lastName:String = ""
    @Published var email:String = ""
    @Published var password:String = ""
    @Published var companionReferral:String = ""
    
    func register(){
        print("register")
    }
    
    func registerWithApple(){
        print("register with apple")
    }
}

