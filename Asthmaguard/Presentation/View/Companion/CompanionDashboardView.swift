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
    @State var asthmathreat: [AsthmaThreat] = [
        .init(title: "Enviromental", risks: 0.15),
        .init(title: "BioSignal", risks: 0.35),
        .init(title: "Normal", risks: 0.5)
    ]
    
    
    @State private var showDetailsView = false
    
    var body: some View {
        
        VStack(spacing:10){
            Text("Companion Dashboard")
                .font(Font.custom("Poppins-Bold", size: 18))
                .padding(.all)
            
            let chartColors: [Color] = [
                .pink.opacity(0.7), .pink, .blue
            ]
            
            let asthmaThreatRisks:Double = 0.4
            
            HStack {
                Image("sadeel")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(.leading, 10)
                VStack(alignment: .leading) {
                    Text("Sadeel Muwahed")
                        .font(.title3)
                }
            }
            
            Text("Asthma Threat: \(asthmaThreatRisks * 100,  specifier: "%.1f")%")
                .font(Font.custom("Poppins-Regular", size: 26))
            
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


@available(iOS 17.0, *)
struct CompanionDashboardView: View {

    @State private var selection = 0
    
    var body: some View {
        
        TabView(selection:$selection) {
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
struct CompanionAsthmaThreatChart_Previews: PreviewProvider {
    static var previews: some View {
        CompanionDashboardView()
    }
}



