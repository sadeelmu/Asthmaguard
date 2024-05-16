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

struct Enviromental: Identifiable{
    var id = UUID()
    let title: String
    let severity: Double
}
struct BioSignal: Identifiable{
    var id = UUID()
    let title: String
    let severity: Double
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

@available(iOS 17.0, *)
struct AsthmaThreatChart: View {
    @State var asthmathreat: [AsthmaThreat] = [
        .init(title: "Biosignals", risks: 0.3),
        .init(title: "Enviromental", risks: 0.1),
        .init(title: "Normal", risks: 0.6)
    ]
    
    
    @State private var showDetailsView = false
    
    var body: some View {
        
        ScrollView(showsIndicators:false){
            VStack(spacing:20){
                Text("Dashboard")
                    .font(Font.custom("Poppins-Bold", size: 18))
                    .padding(.all)
                
                let chartColors: [Color] = [
                    .pink.opacity(0.5), .pink, .blue
                ]
                
              
                let asthmaThreatRisks:Double = 0.4
                
                Text("Asthma Threat: \(asthmaThreatRisks * 100,  specifier: "%.1f")%")
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
                VStack(spacing:10){
                    CustomBioData(bioSignal: "Respiratory Rate", time: "11:55 AM", data: "19 breathes/min")
                    
                    CustomBioData(bioSignal: "Heart Rate", time: "12:01 PM", data: "96 BPM")
                    
                    CustomBioData(bioSignal: "Blood Oxygen", time: "12:03 PM", data: "98.5%")
                }
                Spacer()
            }
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



