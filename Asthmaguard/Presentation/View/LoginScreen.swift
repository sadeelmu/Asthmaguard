//
//  LoginScreen.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 13/02/2024.
//

import Foundation
import SwiftUI

struct LoginScreen: View {
    @ObservedObject var loginViewModel: LoginViewModel = LoginViewModel()

    var body: some View {
        VStack {
            Spacer()
            Text("AsthmaGuard")
                .font(Font.custom("Poppins-Regular", size: 32).weight(.bold))
                .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))

            Text("Take a breath\n")
                .font(Font.custom("Poppins-Regular", size: 16))
                .foregroundColor(Color(red: 0.48, green: 0.44, blue: 0.45))

            VStack(spacing: 16) {
                CustomTextField(systemName: "person", placeholder: "Email", text: $loginViewModel.email)
                    .keyboardType(.emailAddress)

                CustomTextField(systemName: "lock", placeholder: "Password", text: $loginViewModel.password)

                Button(action: {loginViewModel.login()}) {
                    Text("Login")
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

                Button(action: {loginViewModel.loginWithApple()}) {
                    Text("Login with Apple")
                        .font(Font.custom("Poppins-Regular", size: 14).weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.black)
                        .cornerRadius(99)
                        .shadow(color: Color(red: 0.58, green: 0.68, blue: 1, opacity: 0.30), radius: 22, y: 10)
                }

                Button(action: {loginViewModel.companion()}) {
                    Text("Companion’s portal")
                        .font(Font.custom("Poppins-Regular", size: 14).weight(.bold))
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .frame(height: 50)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.58, blue: 0.58), Color(red: 1, green: 0.58, blue: 0.58).opacity(0.51)]), startPoint: .top, endPoint: .bottom)
                        )
                        .cornerRadius(99)
                        .shadow(color: Color(red: 0.58, green: 0.68, blue: 1, opacity: 0.30), radius: 22, y: 10)
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 50)

            Spacer()
        }
        .background(Color.white)
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
