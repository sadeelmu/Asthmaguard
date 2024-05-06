//
//  DashboardView.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 13/03/2024.
//

import Foundation
import SwiftUI
import Charts
import CoreLocation

struct AsthmaThreat: Identifiable {
    let id = UUID()
    let title: String
    let risks: Double
}

struct VitalSign: Identifiable {
    let id = UUID()
    let title: String
    let value: Double
}

func colorForRisk(_ title: String) -> Color {
    switch title {
    case "Biosignals":
        return .pink
    case "Enviromental":
        return .pink
    case "Normal":
        return .blue
    default:
        return .blue
    }
}

func colorForVitalSign(_ title: String) -> Color {
    switch title {
    case "Heart Rate":
        return .red
    case "Respiratory Rate":
        return .green
    default:
        return .gray
    }
}

@available(iOS 17.0, *)
struct AsthmaThreatChart: View {
    @State private var asthmathreat: [AsthmaThreat] = [
        .init(title: "Biosignals", risks: 0.5),
        .init(title: "Enviromental", risks: 0.2),
        .init(title: "Normal", risks: 0.3)
    ]
    
    @State private var vitalSigns: [VitalSign] = [
        .init(title: "Heart Rate", value: 78),
        .init(title: "Respiratory Rate", value: 30)
    ]
    
    @State private var showDetailsView = false
    
    var body: some View {
        VStack {
            Spacer()
            let chartColors: [Color] = [
                .pink, .pink, .blue
            ]
            
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
            }.frame(width: 300, height: 300)
                .chartForegroundStyleScale(domain: .automatic, range: chartColors)
            
            
            
            Text("Asthma Threat: 80%")
                .font(Font.custom("Poppins-Bold", size: 26))
            
            
            Spacer()
        }
    }
}

struct AnalyticsView: View {
    
    let asthmaThreats: [AsthmaThreat] = [
        AsthmaThreat(title: "Biosignals", risks: 0.5),
        //        AsthmaThreat(title: "Heart Rate", risks: 0.3),
        //        AsthmaThreat(title: "Respitory Rate", risks: 0.2),
        
        AsthmaThreat(title: "Environmental", risks: 0.2),
        //        AsthmaThreat(title: "Allergies", risks: 0.1),
        //        AsthmaThreat(title: "Weather", risks: 0.1),
        
        
    ]
    
    var body: some View {
        VStack {
            Text("Asthma Threats Breakdown")
                .font(.title)
                .padding()
            
            List(asthmaThreats) { threat in
                HStack {
                    Text(threat.title)
                        .font(.headline)
                    Spacer()
                    Text("\(threat.risks * 100, specifier: "%.1f")%")
                        .foregroundColor(colorForRisk(threat.title))
                        .font(.headline)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            Button(action: {
                AsthmaThreatCalculatorUseCase.fetchData()
                AsthmaThreatCalculatorUseCase.fetchDataAndCalculateAsthmaSeverity()
            }) {
                Label("Show data", systemImage: "sun.min")
            }
        
            
            Spacer()
            
            CustomBioData(bioSignal: "Respiratory Rate", time: "12:00", data: "No data")
            
            CustomBioData(bioSignal: "Heart Rate", time: "12:01", data: "130 BPM")
            
            Spacer()
        }
    }
}


@available(iOS 17.0, *)
struct DashboardView: View {

    @State private var selection = 0
    
    var body: some View {
        
        TabView(selection:$selection) {
            NavigationView {
                AsthmaThreatChart()
                    .navigationTitle("Asthma Tracker")
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
            
            BreathingExerciseScreen().tabItem { Label("Breathing", systemImage:"figure.mind.and.body")}.tag(2)
            
            SettingsScreen().tabItem { Label("Settings", systemImage: "gearshape") }.tag(3)
        }
    }
}


@available(iOS 17.0, *)
struct AsthmaThreatChart_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}



