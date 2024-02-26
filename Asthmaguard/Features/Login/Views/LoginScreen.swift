//
//  LoginScreen.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 13/02/2024.
//

import Foundation
import SwiftUI

struct LoginScreen:View{
    @ObservedObject var viewModel:LoginViewModel = LoginViewModel()
    
    var body: some View{
        VStack{
            Text("AsthmaGuard").bold().font(.title).padding(.all)
            Text("Take a breath").font(.subheadline).padding(.all)
            
            Spacer()
            
            VStack{
                TextField(
                    "Email",
                    text: $viewModel.email
                ).autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.top, 20)
                
                SecureField(
                    "Password",
                    text:$viewModel.password
                ).padding(.top, 20)
            }
            
            Spacer()
            
            VStack{
                Button(action: viewModel.login, label: {
                    Text("Login")
                        .font(.body)
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(10)
                })
                Spacer()
                Button(action: viewModel.login, label: {
                    Text("Login with Apple")
                        .font(.body)
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(10)
                })
            }
            
        }.padding(30)
    }
}
