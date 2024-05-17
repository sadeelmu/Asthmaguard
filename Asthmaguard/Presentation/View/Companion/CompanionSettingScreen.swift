//
//  CompanionSettingScreen.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 16/05/2024.
//

import Foundation
import SwiftUI


@available(iOS 17.0, *)
struct CompanionSettingsScreen: View {
    @State private var notificationsChoice:Bool = true
    @State private var userName:String = "Dr. Samer Sawlha"
    @State private var selection = 0
    
    var body: some View {
        TabView(selection:$selection) {
            VStack(){
                NavigationView {
                    Form {
                        ZStack(alignment: .leading) {
                            HStack {
                                Image("doctorcolor")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
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
                                        .background(.pink)        .foregroundColor(.white)
                                        .cornerRadius(50)
                                }
                            }
                        }
                        Section(header: Text("Account")) {
                            NavigationLink(destination: AnalyticsView()) {
                                Label("Patient Analaytics", systemImage: "chart.pie.fill")
                            }
                        }
                        
                        Section(header: Text("Notifications")) {
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
                        
                        Section(header: Text("Logout")){
                            Button(action: {
                            }) {
                                Label("Log Out", systemImage: "power")
                                    .foregroundColor(.pink)
                            }
                        }
                    }
                    .listStyle(.grouped)
                    .background(Color.clear)
                    .navigationBarTitle("Settings")
                }
            }
        }
    }
}



@available(iOS 17.0, *)
struct CompanionSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        CompanionSettingsScreen()
    }
}


