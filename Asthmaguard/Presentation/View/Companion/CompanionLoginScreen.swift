//
//  CompanionLoginScreen.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 18/05/2024.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct CompanionLoginScreen: View {
    @ObservedObject var loginViewModel: CompanionLoginViewModel = CompanionLoginViewModel()
    
    var body: some View {
        if loginViewModel.shouldNavigateToCompanionDashboard {
            CompanionDashboardView()
        } else if loginViewModel.shouldNavigateToRegister {
            CompanionRegisterScreen()
        } else {
            VStack {
                Spacer()
                Text("Asthma")
                    .font(Font.custom("Poppins-Regular", size: 32).weight(.bold))
                    .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
                + Text("Guard")
                    .font(Font.custom("Poppins-Regular", size: 32).weight(.bold))
                    .foregroundColor(Color(red: 0.57, green: 0.64, blue: 0.99))
                
                Text("Help your patients manage their asthma")
                    .font(Font.custom("Poppins-Regular", size: 16))
                    .foregroundColor(Color(red: 0.48, green: 0.44, blue: 0.45))
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 16) {
                    CustomTextField(systemName: "person", placeholder: "Companion Referral Code", text: $loginViewModel.companionReferral)
                        .keyboardType(.emailAddress)
                    
                    Button(action: { loginViewModel.login() }) {
                        Text("Login as companion")
                            .font(Font.custom("Poppins-Regular", size: 14).weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.58, blue: 0.58), Color(red: 1, green: 0.58, blue: 0.58).opacity(0.51)]), startPoint: .top, endPoint: .bottom)
                            )
                            .cornerRadius(99)
                            .shadow(color: Color(red: 0.58, green: 0.68, blue: 1, opacity: 0.30), radius: 22, y: 10)
                    }
                    
                    Button(action: { loginViewModel.login() }) {
                        Text("Patient Portal")
                            .font(Font.custom("Poppins-Regular", size: 14).weight(.bold))
                            .foregroundColor(.white)
                            .frame(width: 200)
                            .frame(height: 50)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color(red: 0.57, green: 0.64, blue: 0.99), Color(red: 0.62, green: 0.81, blue: 1)]), startPoint: .trailing, endPoint: .leading)
                            )
                            .cornerRadius(99)
                            .shadow(color: Color(red: 0.58, green: 0.68, blue: 1, opacity: 0.30), radius: 22, y: 10)
                    }
                    
                    HStack(spacing: 3) {
                        Text("Do not have an account?")
                            .font(Font.custom("Poppins", size: 14))
                            .lineSpacing(21)
                            .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
                        Button(action: { loginViewModel.register() }) {
                            Text("Get Started!")
                                .font(Font.custom("Poppins", size: 14))
                                .foregroundColor(Color(red: 0.57, green: 0.64, blue: 0.99))
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 50)
                
                Spacer()
            }
            .background(Color.white)
        }
    }
}

struct CompanionLoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        CompanionLoginScreen()
    }
}
