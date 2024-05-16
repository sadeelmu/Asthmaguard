//
//  CompanionRegisterScreen.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 12/03/2024.
//

import Foundation
import SwiftUI

struct CompanionRegisterScreen: View {
    @ObservedObject var companionRegisterViewModel = CompanionRegisterViewModel()
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false
    
    var body: some View {
        
        VStack(spacing: 20) {
            Spacer()
            VStack(spacing:5){
                Text("Stay in touch,")
                    .font(Font.custom("Poppins-Regular", size: 16))
                    .lineSpacing(24)
                    .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
                
                Text("Create a Companion’s Account")
                    .font(Font.custom("Poppins-Regular", size: 20).weight(.bold))
                    .lineSpacing(30)
                    .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
            }
            
            Spacer()
            
            VStack(spacing:2){
                CustomTextField(systemName: "person", placeholder: "First Name", text: $companionRegisterViewModel.firstName).padding(10)
                
                CustomTextField(systemName: "person", placeholder: "Last Name", text: $companionRegisterViewModel.lastName).padding(10)
                
                CustomTextField(systemName: "envelope", placeholder: "Email", text: $companionRegisterViewModel.email).padding(10)
                    .keyboardType(.emailAddress)
                
                CustomTextField(systemName: "lock", placeholder: "Password", text: $companionRegisterViewModel.password).padding(10)
                
                CustomTextField(systemName: "person", placeholder: "Companion’s referral", text: $companionRegisterViewModel.companionReferral).padding(10)

                
                HStack {
                    Button(action: { agreedToTerms.toggle() }) {
                        Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text("By continuing you accept our Privacy Policy and Term of Use")
                        .font(Font.custom("Poppins-Regular", size: 10))
                        .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                }
            }
            
            
                        
            VStack(spacing:10) {
                Button(action: companionRegisterViewModel.register) {
                    Text("Register")
                        .font(Font.custom("Poppins-Regular", size: 14).weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color(red: 0.57, green: 0.64, blue: 0.99), Color(red: 0.62, green: 0.81, blue: 1)]), startPoint: .trailing, endPoint: .leading)
                        )
                        .cornerRadius(99)
                        .shadow(color: Color(red: 0.58, green: 0.68, blue: 1, opacity: 0.30), radius: 22, y: 10)
                }
                
                
                Divider().padding(.vertical, 5)
                
                Button(action: companionRegisterViewModel.registerWithApple) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(red: 0.87, green: 0.85, blue: 0.86), lineWidth: 0.40)
                        Text("Register with Apple")
                            .font(Font.custom("Poppins-Regular", size: 14).weight(.bold))
                            .foregroundColor(.black)
                    }
                    .frame(width: 192, height: 50)
                }
            }
            
            Text("Already have an account? Login")
              .font(Font.custom("Poppins-Regular", size: 14))
              .lineSpacing(21)
              .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
            
                    
        }
        .padding()
        .background(Color.white)
    }
}

