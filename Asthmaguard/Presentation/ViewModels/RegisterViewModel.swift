//
//  RegisterViewModel.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 04/03/2024.
//

import Foundation

class RegisterViewModel:ObservableObject{
    @Published var firstName:String = ""
    @Published var lastName:String = ""
    @Published var email:String = ""
    @Published var password:String = ""
    
    func register(){
        print("register")
    }
    
    func registerWithApple(){
        print("register with apple")
    }
}

