//
//  CustomTabView.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 01/04/2024.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct CustomTabView: View{
    
    var body: some View {
        TabView() {
            HStack{}
            .tabItem {
                Label("Dashboard", systemImage: "house")
            }
            .tag(0)
            
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.xyaxis.line")
                }
                .tag(1)
            
            BreathingExerciseScreen().tabItem { Label("Breathing", systemImage:"figure.mind.and.body")}.tag(2)
            
            SettingsScreen().tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
    
}
