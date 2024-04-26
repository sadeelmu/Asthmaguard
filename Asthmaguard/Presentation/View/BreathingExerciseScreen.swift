//
//  BreathingExerciseScreen.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 31/03/2024.
//

import SwiftUI

@available(iOS 17.0, *)
struct BreathingExerciseScreen: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection:$selection) {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 10) {
                    Text("Breathing Exercises")
                        .font(Font.custom("Poppins-Bold", size: 25))
                        .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
                    
                    Text("Recommended Duration: 5 minutes")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Divider()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(alignment:.leading,spacing: 20) {
                            Text("Set 1")
                                .font(Font.custom("Poppins-Regular", size: 20))
                            
                            HStack{
                                BreathingExerciseCard(title: "Breathe In", duration: "01:00", color: Color(red: 0.57, green: 0.64, blue: 0.99), imageName: "breathin")
                                BreathingExerciseCard(title: "Breathe Out", duration: "01:00", color: Color(red: 0.77, green: 0.55, blue: 0.95), imageName: "breatheout")
                            }
                            
                            Divider()
                            Text("Set 2")
                                .font(Font.custom("Poppins-Regular", size: 20))
                            
                            BreathingExerciseCard(title: "Meditate", duration: "02:00", color: Color(red: 0.57, green: 0.64, blue: 0.99), imageName: "meditate")
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Action for starting exercises
                    }) {
                        Text("Start Selected Exercise")
                            .font(Font.custom("Poppins-Regular", size: 16).weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(.black)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    
                    Spacer()
                }
            }
        }
    }
}

struct BreathingExerciseCard: View {
    let title: String
    let duration: String
    let color: Color
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(Font.custom("Poppins-Regular", size: 16).weight(.bold))
                .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
            Text(duration)
                .font(Font.custom("Poppins-Regular", size: 12))
                .foregroundColor(Color(red: 0.48, green: 0.44, blue: 0.45))
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(color.opacity(0.3))
                .frame(width: 120, height: 120)
                .overlay(
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                )
        }
    }
}

@available(iOS 17.0, *)
struct BreathingExerciseScreen_Previews: PreviewProvider {
    static var previews: some View {
        BreathingExerciseScreen()
    }
}
