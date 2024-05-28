//
//  CompanionDashboardView.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 16/05/2024.
//

import Foundation
import SwiftUI
import Charts
import CoreLocation

@available(iOS 17.0, *)
struct CompanionAsthmaThreatChart: View {
    @State private var totalWeightedSeverity: Double = 0.0
    @State private var biosignalRisk: Double = 0.0
    @State private var environmentalRisk: Double = 0.0
    @State private var showVeryHighThreatAlert: Bool = false

    @State var asthmathreat: [AsthmaThreat] = [
        .init(title: "Biosignals", risks: 0.2),
        .init(title: "Environmental", risks: 0.25),
        .init(title: "Normal", risks: 0.55)
    ]

    private let asthmaThreatCalculatorUseCase = AsthmaThreatCalculatorUseCase()
    private let locationManager = LocationManager.shared

    func updateAsthmaThreat() {
        asthmaThreatCalculatorUseCase.fetchDataAndCalculateAsthmaSeverity()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.biosignalRisk = 0.2
            self.environmentalRisk = 0.25
            self.totalWeightedSeverity = 0.45

            if totalWeightedSeverity > 0.75 {
                showVeryHighThreatAlert = true
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 5) {
                    Text("Companion Dashboard")
                        .font(Font.custom("Poppins-Bold", size: 18))
                        .padding(.all)

                    let chartColors: [Color] = [
                        .pink.opacity(0.5), .pink, .blue
                    ]

                    Text("Asthma Threat: \(totalWeightedSeverity * 100, specifier: "%.1f")%")
                        .font(Font.custom("Poppins-Bold", size: 26))

                    Chart(asthmathreat) { asthmathreat in
                        SectorMark(
                            angle: .value(
                                Text(asthmathreat.title),
                                asthmathreat.risks
                            ),
                            innerRadius: .ratio(0.6),
                            angularInset: 0.8
                        )
                        .cornerRadius(4)
                        .foregroundStyle(by: .value("Threats", asthmathreat.title))
                    }.frame(width: 300, height: 250)
                    .chartForegroundStyleScale(domain: .automatic, range: chartColors)

                    Spacer()
                    VStack(spacing: 10) {
                        NavigationLink(destination: HistoricalDataView(bioSignal: "Respiratory Rate")) {
                            CustomBioData(bioSignal: "🫁 Respiratory Rate", time: "11:55 AM", data: "19 breaths/min")
                        }
                        NavigationLink(destination: HistoricalDataView(bioSignal: "Heart Rate")) {
                            CustomBioData(bioSignal: "🫀 Heart Rate", time: "12:01 PM", data: "96 BPM")
                        }
                        NavigationLink(destination: HistoricalDataView(bioSignal: "Blood Oxygen")) {
                            CustomBioData(bioSignal: "🩸 Blood Oxygen", time: "12:03 PM", data: "98.5%")
                        }
                    }
                    Spacer()
                }
                .onAppear {
                    // Request location access
                    locationManager.requestLocationAccess()
                    locationManager.startUpdatingLocation()
                    
                    // Request HealthKit access
                    BioSignalData.requestHealthDataAccessIfNeeded { success in
                        if success {
                            updateAsthmaThreat()
                        } else {
                            print("HealthKit authorization failed")
                        }
                    }
                }
                .alert(isPresented: $showVeryHighThreatAlert) {
                    Alert(
                        title: Text("Very High Asthma threat detected!"),
                        message: Text("Please contact the asthma patient immediately."),
                        dismissButton: .default(Text("Dismiss"))
                    )
                }
            }
        }
    }
}

@available(iOS 17.0, *)
struct CompanionDashboardView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                CompanionAsthmaThreatChart()
                    .navigationTitle("")
                    .navigationBarBackButtonHidden(false)
            }.tabItem {
                Label("Dashboard", systemImage: "house")
            }
            .tag(0)
            
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.xyaxis.line")
                }
                .tag(1)
            
            CompanionSettingsScreen().tabItem { Label("Settings", systemImage: "gearshape") }.tag(2)
        }
    }
}

@available(iOS 17.0, *)
struct CompanionDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        CompanionDashboardView()
    }
}
