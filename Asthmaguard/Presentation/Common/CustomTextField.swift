//
//  CustomTextField.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 04/03/2024.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    var systemName: String
    var placeholder: String
    @Binding var text: String
    @State private var isSecure: Bool = true // State to track password visibility
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .foregroundColor(.gray)
                .padding(.leading, 12)
            
            if systemName == "lock" { // Check if it's a password field
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .font(Font.custom("Poppins-Regular", size: 12))
                        .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                } else {
                    TextField(placeholder, text: $text)
                        .font(Font.custom("Poppins-Regular", size: 12))
                        .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                }
                
                Button(action: { isSecure.toggle() }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                        .padding(.trailing, 12)
                }
            } else {
                TextField(placeholder, text: $text)
                    .font(Font.custom("Poppins-Regular", size: 12))
                    .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
            }
        }
        .frame(height: 48)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .foregroundColor(Color(red: 0.97, green: 0.97, blue: 0.97))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(red: 0.97, green: 0.97, blue: 0.97), lineWidth: 0.50)
                )
        )
    }
}

