//
//  LoginModel.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 13/02/2024.
//

import Foundation

class LoginViewModel:ObservableObject{
    @Published var email:String = ""
    @Published var password:String = ""
    
    func login(){
       print("Data is \(DatabaseManager.shared.fetchUsers())") 
    }
    
    func loginWithApple(){
        print("Login with apple")
    }
    
    func companion(){
        print("companion")
    }
}

