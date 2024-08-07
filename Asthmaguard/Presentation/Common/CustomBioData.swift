//
//  CustomBioData.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 28/03/2024.
//

import Foundation
import SwiftUI

public struct CustomBioData: View {
    var bioSignal:String
    var time:String
    var data:String
    
    public var body: some View{
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .center) {
                    HStack(spacing: 2) {
                        Text(bioSignal)
                            .font(Font.custom("Poppins-Regular", size: 14))
                            .foregroundColor(Color(red: 0.92, green: 0.29, blue: 0.38))
                    }
                    Spacer()
                    HStack(spacing: 2) {
                        Text(time)
                            .font(Font.custom("Poppins-Bold", size: 12))
                            .foregroundColor(Color(red: 0.52, green: 0.52, blue: 0.52))
                    }
                }
                .frame(maxWidth: .infinity)
                
                Text(data)
                    .font(Font.custom("Poppins-Regular", size: 16))
                    .foregroundColor(.black)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(20)
        .frame(width: 300, height: 80)
        .background(Color(red: 1, green: 0.80, blue: 0.85).opacity(0.4))
        
        .cornerRadius(10)
    }
}
