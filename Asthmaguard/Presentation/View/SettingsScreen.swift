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
    @State private var notificationsChoice: Bool = true
    @State private var userName: String = "Sadeel Muwahed"
    @State private var selection = 0
    @State private var shouldLogout = false

    var body: some View {
        if shouldLogout {
            LoginScreen()
        } else {
            TabView(selection: $selection) {
                VStack() {
                    NavigationView {
                        Form {
                            ZStack(alignment: .leading) {
                                HStack {
                                    Image("sadeel")
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
                                            .background(Color.pink)
                                            .foregroundColor(.white)
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
                                NavigationLink(destination: AddCompanionView()) {
                                    Label("Add Companion Doctor", systemImage: "person")
                                }
                            }

                            Section(header: Text("Notifications")) {
                                Toggle(isOn: $notificationsChoice) {
                                    Label("Pop-up Notification", systemImage: "bell")
                                }.tint(Color.pink)
                            }

                            Section(header: Text("Other")) {
                                NavigationLink(destination: ContactView()) {
                                    Label("Contact Us", systemImage: "mail.fill")
                                }
                                NavigationLink(destination: PrivacyView()) {
                                    Label("Privacy Policy", systemImage: "checkmark.shield.fill")
                                }
                            }
                            Section(header: Text("Logout")) {
                                Button(action: {
                                    shouldLogout = true
                                }) {
                                    Label("Log Out", systemImage: "power")
                                        .foregroundColor(Color.pink)
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
}

struct AddCompanionView: View {
    @State private var companionEmail: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Add Companion")
                .font(Font.custom("Poppins-Bold", size: 18))
                .padding()

            TextField("Companion's email", text: $companionEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing, .bottom])

            Button(action: addCompanion) {
                Text("Send Invite")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.pink)
                    .cornerRadius(8)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Companion Added"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Add Companion")
    }

    private func addCompanion() {
        alertMessage = "An invite has been sent to \(companionEmail). The token is 123456"
        
        showAlert = true
    }
}

@available(iOS 17.0, *)
struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Privacy Policy")
                    .font(Font.custom("Poppins-Bold", size: 18))
                    .padding()

                Text("This is a the privacy policy for AsthmaGuard app. Your privacy is important to us. We collect and store health data in a secure manner and do not share it with third parties without your consent.")
                    .font(Font.custom("Poppins-Regular", size: 14))
                    .padding()

                Text("Data Collection")
                    .font(Font.custom("Poppins-Bold", size: 16))
                    .padding([.top, .leading, .trailing])

                Text("We collect data such as heart rate, respiratory rate, and oxygen saturation to monitor your asthma condition. This data is used solely for providing health insights and alerts.")
                    .font(Font.custom("Poppins-Regular", size: 14))
                    .padding([.leading, .trailing, .bottom])

                Text("Data Security")
                    .font(Font.custom("Poppins-Bold", size: 16))
                    .padding([.top, .leading, .trailing])

                Text("Your data is stored securely and encrypted. We take all necessary measures to ensure that your data is protected against unauthorized access.")
                    .font(Font.custom("Poppins-Regular", size: 14))
                    .padding([.leading, .trailing, .bottom])
                
            }
        }
        .padding()
        .navigationTitle("Privacy Policy")
    }
}

@available(iOS 17.0, *)
struct ContactView: View {
    @State private var email: String = ""
    @State private var message: String = ""
    @State private var showAlert: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Contact Us")
                .font(Font.custom("Poppins-Bold", size: 18))
                .padding()

            TextField("Your email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing, .bottom])

            Text("Message")
                .font(Font.custom("Poppins-Bold", size: 16))
                .padding([.top, .leading, .trailing])

            TextEditor(text: $message)
                .frame(height: 200)
                .border(Color.gray, width: 1)
                .padding([.leading, .trailing, .bottom])

            Button(action: sendMessage) {
                Text("Send Message")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.pink)
                    .cornerRadius(8)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Message Sent"),
                    message: Text("Your message has been sent successfully."),
                    dismissButton: .default(Text("OK"))
                )
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Contact Us")
    }

    private func sendMessage() {
        showAlert = true
    }
}

@available(iOS 17.0, *)
struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
