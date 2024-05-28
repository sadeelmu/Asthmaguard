//
//  BreathingExerciseScreen.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 31/03/2024.
//

import SwiftUI
import SDWebImageSwiftUI

@available(iOS 17.0, *)
struct BreathingExerciseScreen: View {
    @State private var selectedExercise: BreathingExercise?
    @State private var isExerciseStarted = false

    var body: some View {
        TabView {
            ZStack {
                VStack(spacing: 5) {
                    VStack(spacing: 5) {
                        Text("Breathing Exercises")
                            .font(Font.custom("Poppins-Bold", size: 18))
                            .padding(.all, 5)

                        Text("Clinically proven breathing exercises designed to improve your asthma symptoms.")
                            .font(Font.custom("Poppins-Bold", size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.all)

                    Divider()
                    Spacer()
                    VStack(spacing: 20) {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    BreathingExerciseCard(exercise: BreathingExercise(title: "Inhaler", duration: "2 minutes", color: Color(red: 0.57, green: 0.64, blue: 0.99), imageName: "useinhaler", gifName: "howtouseinhaler"), selectedExercise: $selectedExercise)
                                    Text("Helps open airways and improve breathing.")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .multilineTextAlignment(.leading)
                                }
                                Divider()
                                HStack {
                                    BreathingExerciseCard(exercise: BreathingExercise(title: "Meditate", duration: "5 minutes", color: Color(red: 0.57, green: 0.64, blue: 0.99), imageName: "meditation", gifName: "meditation"), selectedExercise: $selectedExercise)
                                    Text("Helps relax and improve breathing.")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .multilineTextAlignment(.leading)
                                }
                                Divider()
                                HStack {
                                    BreathingExerciseCard(exercise: BreathingExercise(title: "Breathe", duration: "5 minutes", color: Color(red: 0.57, green: 0.64, blue: 0.99), imageName: "breathin", gifName: "nasal"), selectedExercise: $selectedExercise)
                                    Text("Breathe in and out from your nasal.")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .padding(.bottom, 10)
                            .padding(.top, 10)
                            .padding(.horizontal, 20)

                            Button(action: {
                                // Start the selected exercise
                                isExerciseStarted = true
                            }) {
                                Text("Start Selected Breathing Exercise")
                                    .font(Font.custom("Poppins-Regular", size: 16).weight(.bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 55)
                                    .background(selectedExercise != nil ? Color.black : Color.gray.opacity(0.5))
                                    .cornerRadius(25)
                                    .disabled(selectedExercise == nil)
                            }
                            .padding(.all, 10)
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isExerciseStarted) {
            if let exercise = selectedExercise {
                BreathingExerciseView(exercise: exercise)
            }
        }
    }
}

struct BreathingExerciseCard: View {
    let exercise: BreathingExercise
    @Binding var selectedExercise: BreathingExercise?

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(exercise.title)
                .font(Font.custom("Poppins-Regular", size: 18).weight(.bold))
                .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
            Text(exercise.duration)
                .font(Font.custom("Poppins-Regular", size: 12))
                .foregroundColor(Color(red: 0.48, green: 0.44, blue: 0.45))
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(exercise.title == selectedExercise?.title ? Color(red: 0.97, green: 0.61, blue: 0.69) : exercise.color.opacity(0.3))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(exercise.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                )
        }
        .onTapGesture {
            selectedExercise = exercise
        }
    }
}

@available(iOS 17.0, *)
struct BreathingExerciseScreen_Previews: PreviewProvider {
    static var previews: some View {
        BreathingExerciseScreen()
    }
}

struct BreathingExercise {
    let title: String
    let duration: String
    let color: Color
    let imageName: String
    let gifName: String
}


@available(iOS 17.0, *)
struct BreathingExerciseView: View {
    let exercise: BreathingExercise
    @State private var timerValue = 0
    @State private var timer: Timer?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing:20){
            Spacer()
            Text("\(exercise.title) Breathing Exercise")
                .font(Font.custom("Poppins-Regular", size: 26).weight(.bold))
                .padding()
            Divider()
            VStack(spacing:5){
                Text("Timer: \(timerValue) seconds")
                    .font(Font.custom("Poppins-Regular", size: 16).weight(.bold))
                    .multilineTextAlignment(.leading)
                Text("Please do the breathing excerise for the complete duration of the advised time: \(exercise.duration).")
                    .multilineTextAlignment(.leading)
                    .padding(.all, 10)
                    .font(Font.custom("Poppins-Regular", size: 16))
             

            }
            Divider()
            Spacer()
                WebImage(url: Bundle.main.url(forResource: exercise.gifName, withExtension: "gif"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250, height: 100)
                    .padding(.all, 10)

            Spacer()
            Divider()
            Button(action: {
                timer?.invalidate()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Stop Breathing Exercise")
                    .font(Font.custom("Poppins-Regular", size: 20).weight(.bold))
                    .foregroundColor(.white)
                    .frame(width: 375)
                    .frame(height: 100)
                    .background(.black)
                    .frame(height: 50)
                    .cornerRadius(25)
            }
            .padding(.all, 10)
            Spacer()
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    func startTimer() {
        let durationInSeconds = convertDurationToSeconds()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timerValue < durationInSeconds {
                timerValue += 1
            } else {
                timer?.invalidate()
            }
        }
    }
    
    func convertDurationToSeconds() -> Int {
        var seconds = 0
        if let minutesRange = exercise.duration.range(of: " minute") {
            let minutes = String(exercise.duration.prefix(upTo: minutesRange.lowerBound))
            if let minutesInt = Int(minutes) {
                seconds += minutesInt * 60
            }
        }
        if let secondsRange = exercise.duration.range(of: " seconds") {
            let secondsString = String(exercise.duration.prefix(upTo: secondsRange.lowerBound))
            if let secondsInt = Int(secondsString) {
                seconds += secondsInt
            }
        }
        return seconds
    }
}
