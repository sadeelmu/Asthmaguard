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

struct AsthmaThreatChart: View {
    @State private var asthmathreat: [AsthmaThreat] = [
        .init(title: "Biosignals", risks: 0.7),
        .init(title: "Enviromental", risks: 0.2),
        .init(title: "History", risks: 0.1)
    ]
    
    // Define a function to map each title to a color
    func colorForTitle(_ title: String) -> Color {
        switch title {
        case "Biosignals":
            return .blue
        case "Enviromental":
            return .green
        case "History":
            return .orange
        default:
            return .gray
        }
    }
    
    var body: some View {
        Chart(asthmathreat) { asthmathreat in
            SectorMark(
                angle: .value(
                    Text(verbatim: asthmathreat.title),
                    asthmathreat.risks
                ),
                innerRadius: .ratio(0.6)
            )
            .foregroundStyle(
                by: .color(colorForTitle(asthmathreat.title))
            )
        }
    }
}
