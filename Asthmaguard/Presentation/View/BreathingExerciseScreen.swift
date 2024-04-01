//
//  BreathingExerciseScreen.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 31/03/2024.
//

import SwiftUI

@available(iOS 17.0, *)
struct BreathingExerciseScreen: View {
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        // Go back to the previous screen
                    }) {
                        Image("back-arrow")
                            .resizable()
                            .frame(width: 12, height: 22)
                            .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
                    }

                    Spacer()

                    Text("Breathing Exercises")
                        .font(Font.custom("Poppins", size: 18).weight(.bold))
                        .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))

                    Spacer()

                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding(.trailing, 12)
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)

                Text("Recommended Duration: 5 minutes")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        VStack{
                            BreathingExerciseCard(title: "Breathe In", duration: "01:00", color: Color(red: 0.57, green: 0.64, blue: 0.99), imageName: "breathin")
                            BreathingExerciseCard(title: "Breathe Out", duration: "01:00", color: Color(red: 0.77, green: 0.55, blue: 0.95), imageName: "breatheout")
                        }
                        Spacer()
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
                        .font(Font.custom("Poppins", size: 16).weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(.black)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
                
                Spacer()
                
                CustomTabView()

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
                .font(Font.custom("Poppins", size: 16).weight(.bold))
                .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
            Text(duration)
                .font(Font.custom("Poppins", size: 12))
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

struct ExerciseView: View {
    let title: String
    let duration: String
    let color: Color
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            
            Text("Duration: \(duration)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(color.opacity(0.3))
                .frame(width: 100, height: 100)
                .overlay(
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(20)
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
