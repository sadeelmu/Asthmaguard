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
    @Published var isLogin: Bool = false
    
    func login(){
        DatabaseManager.shared.fetchUsers()
        isLogin = true
    }
    
    func loginWithApple(){
        print("Login with apple")
    }
    
    func companion(){
        print("companion")
    }
}

