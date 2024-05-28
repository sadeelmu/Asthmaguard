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


@available(iOS 17.0, *)
struct DashboardView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
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
            
            BreathingExerciseScreen().tabItem { Label("Breathing", systemImage: "figure.mind.and.body") }.tag(2)
            
            SettingsScreen().tabItem { Label("Settings", systemImage: "gearshape") }.tag(3)
        }
    }
}



@available(iOS 17.0, *)
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}



