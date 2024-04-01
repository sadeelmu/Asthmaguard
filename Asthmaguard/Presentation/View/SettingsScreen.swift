//
//  SettingsScreen.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 17/03/2024.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct SettingsScreen: View {
    @State private var notificationsChoice:Bool = true
    @State private var userName:String = "Sadeel"
    @State private var selection = 0

    
    var body: some View {
        TabView(selection:$selection) {
            VStack(){
                NavigationView {
                    Form {
                        ZStack(alignment: .leading) {
                            HStack {
                                Image("settingImage")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .padding(.leading, 10)
                                VStack(alignment: .leading) {
                                    Text(userName)
                                        .font(.title3)
                                }
                                Spacer()
                                Button(action: {
                                }) {
                                    Text("Edit")
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 20)
                                        .background(Color.pink)
                                        .foregroundColor(.white)
                                        .cornerRadius(50)
                                }
                                
                            }
                        }
                        Section(header: Text("Account")) {
                            NavigationLink(destination: PersonalDataView()) {
                                Label("Personal Data", systemImage: "person")
                            }
                            
                            NavigationLink(destination: AccountView()) {
                                Label("Asthma Attacks", systemImage: "chart.pie.fill")
                            }
                        }
                        
                        Section(header: Text("Patients")) {
                            NavigationLink(destination: PatientsView()) {
                                Label("Add new patient", systemImage: "person")
                            }
                        }
                        
                        Section(header: Text("Pop-up Notification")) {
                            Toggle(isOn: $notificationsChoice) {
                                Label("Pop-up Notification", systemImage: "bell")
                            }.tint(.pink)
                        }
                        
                        Section(header: Text("Other")) {
                            NavigationLink(destination: ContactView()) {
                                Label("Contact Us", systemImage: "mail.fill")
                            }
                            NavigationLink(destination: PrivacyView()) {
                                Label("Privacy Policy", systemImage: "checkmark.shield.fill")
                            }
                        }
                        
                        
                    }
                    .listStyle(.grouped) // Use the grouped list style
                    .background(Color.clear)
                    .navigationBarTitle("Profile")
                    
                }
            }            .tabItem {
                Label("Dashboard", systemImage: "house")
            }
            .tag(0)
            
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.xyaxis.line")
                }
                .tag(1)
            
            BreathingExerciseScreen().tabItem { Label("Breathing", systemImage:"figure.mind.and.body")}.tag(2)
            
            SettingsScreen().tabItem { Label("Settings", systemImage: "gearshape") }.tag(3)
        }
    
       
    }
}

struct PersonalDataView: View {
    var body: some View {
        Text("Personal Data View")
    }
}

struct AccountView: View {
    var body: some View {
        Text("Asthma Attacks View")
    }
}

struct PatientsView: View {
    var body: some View {
        Text("Patients View")
    }
}

struct NotificationView: View {
    var body: some View {
        Text("Notification View")
    }
}

struct ContactView: View {
    var body: some View {
        Text("Contact View")
    }
}


struct PrivacyView: View {
    var body: some View {
        Text("Privacy View")
    }
}

@available(iOS 17.0, *)
struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}


