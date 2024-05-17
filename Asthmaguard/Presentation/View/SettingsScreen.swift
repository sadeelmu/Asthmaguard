//
//  SettingsScreen.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 17/03/2024.
//

import Foundation
import SwiftUI
 /**    let repositoryRateValue =
  let bloodOxygenValue =
  
  
  var weightRepositoryrate = repositoryRateValue
  var weightBloodoxygen = bloodOxygenValue
  var weightedHeartrate = heartRateValue
  var weightPollution = pollutionValue
  var weightPollen = pollenValue*/


@available(iOS 17.0, *)
struct SettingsScreen: View {
    @State private var notificationsChoice:Bool = true
    @State private var userName:String = "Patient"
    @State private var selection = 0
    
    var body: some View {
        TabView(selection:$selection) {
            VStack(){
                NavigationView {
                    Form {
                        ZStack(alignment: .leading) {
                            HStack {
                                Image("patient")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .padding(.leading, 1)
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
                        Section(header: Text("Data")) {

                            
                            NavigationLink(destination: AnalyticsView()) {
                                Label("Analytics", systemImage: "chart.pie.fill")
                            }
                        }
                        
                        Section(header: Text("Companions")) {
                            NavigationLink(destination: PatientsView()) {
                                Label("Add Companion Doctor", systemImage: "person")
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
                    .listStyle(.grouped) // Use the grouped list style
                    .background(Color.clear)
                    .navigationBarTitle("Settings")
                }
            }
        }
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


