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
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .foregroundColor(.gray)
                .padding(.leading, 12)
            TextField(placeholder, text: $text)
                .font(Font.custom("Poppins-Regular", size: 12))
                .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
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
