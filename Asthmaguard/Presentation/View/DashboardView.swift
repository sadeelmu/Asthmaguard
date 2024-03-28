//
//  DashboardView.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 13/03/2024.
//

import Foundation
import SwiftUI
import Charts

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
    
    
    var body: some View {
        VStack {
            Spacer()
            Chart(asthmathreat) { asthmathreat in
                SectorMark(
                    angle: .value(
                        Text(verbatim: asthmathreat.title),
                        asthmathreat.risks
                    ),
                    innerRadius: .ratio(0.6)
                )
                .foregroundStyle(colorForRisk(asthmathreat.title))
            }.frame(width: 300, height: 300)
            
            
            Spacer()
            
            VStack(spacing:20){
                CustomBioDataWidget(bioSignal: "Respiratory Rate", time: "12:00", data: "No data")
                
                CustomBioDataWidget(bioSignal: "Heart Rate", time: "12:01", data: "130 BPM")
            }
            
//            Chart(vitalSigns) { vitalSign in
//                LineMark(x: .value(vitalSign.title, vitalSign.value),
//                         y: .value(vitalSign.title, vitalSign.value))
//                .foregroundStyle(colorForVitalSign(vitalSign.title))
//                .interpolationMethod(.linear)
//            }
//            .frame(height: 200)
            
            Spacer()
        }
    }
}


struct HistoryView: View {
    var body: some View {
        Text("This is the details view.")
    }
}

@available(iOS 17.0, *)
struct DashboardView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                AsthmaThreatChart()
                    .navigationTitle("Asthma Tracker")
                    .navigationBarBackButtonHidden(false)
            }
            .tabItem {
                Label("Dashboard", systemImage: "house")
            }
            .tag(0)
            
            HistoryView()
                .tabItem {
                    Label("Details", systemImage: "info")
                }
                .tag(1)
        }
    }
}

@available(iOS 17.0, *)
struct AsthmaThreatChart_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}



