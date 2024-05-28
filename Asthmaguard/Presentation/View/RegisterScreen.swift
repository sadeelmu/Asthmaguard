//
//  RegisterScreen.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 04/03/2024.
//

import SwiftUI

@available(iOS 17.0, *)
struct RegisterScreen: View {
    @ObservedObject var registerViewModel = RegisterViewModel()
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false
    @State private var shouldNavigateToSurvey = false
    @State private var shouldNavigateToLogin = false

    var body: some View {
        if shouldNavigateToLogin {
            LoginScreen()
        } else if shouldNavigateToSurvey {
            SurveyView(survey: SurveyScreen) {
                shouldNavigateToLogin = true
            }
        } else {
            Spacer()
            VStack(spacing: 20) {
                Text("Asthma")
                    .font(Font.custom("Poppins-Regular", size: 32).weight(.bold))
                    .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
                + Text("Guard")
                    .font(Font.custom("Poppins-Regular", size: 32).weight(.bold))
                    .foregroundColor(Color(red: 0.57, green: 0.64, blue: 0.99))
                Spacer()
                VStack(spacing: 5) {
                    Text("Hey there,")
                        .font(Font.custom("Poppins-Regular", size: 16))
                        .lineSpacing(24)
                        .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
                    Text("Create an Account")
                        .font(Font.custom("Poppins-Regular", size: 20).weight(.bold))
                        .lineSpacing(30)
                        .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
                }
                Spacer()
                VStack(spacing: 2) {
                    CustomTextField(systemName: "person", placeholder: "First Name", text: $registerViewModel.firstName).padding(10)
                    CustomTextField(systemName: "person", placeholder: "Last Name", text: $registerViewModel.lastName).padding(10)
                    CustomTextField(systemName: "envelope", placeholder: "Email", text: $registerViewModel.email).padding(10)
                        .keyboardType(.emailAddress)
                    CustomTextField(systemName: "lock", placeholder: "Password", text: $registerViewModel.password).padding(10)
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
                VStack(spacing: 10) {
                    Button(action: {
                        registerViewModel.register()
                        shouldNavigateToSurvey = true
                    }) {
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
                }
                HStack(spacing: 3) {
                    Text("Already have an account?")
                        .font(Font.custom("Poppins", size: 14))
                        .lineSpacing(21)
                        .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
                    Button(action: { shouldNavigateToLogin = true }) {
                        Text("Login!")
                            .font(Font.custom("Poppins", size: 14))
                            .foregroundColor(Color(red: 0.57, green: 0.64, blue: 0.99))
                    }
                }
            }
            .padding()
            .background(Color.white)
            Spacer()
        }
    }
}

@available(iOS 17.0, *)
struct RegisterScreen_Preview: PreviewProvider {
    static var previews: some View {
        RegisterScreen()
    }
}
