//
//  AnalyticsView.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 16/05/2024.
//

import Foundation
import SwiftUI

import Charts


struct AnalyticsView: View {

    let asthmaThreats: [AsthmaThreat] = [
        AsthmaThreat(title: "Biosignals", risks: 0.3),
        AsthmaThreat(title: "Environmental", risks: 0.1),
    ]

        @State var enviromental: [Enviromental] = [
            .init(title: "Pollen", severity: 0.2),
            .init(title: "Air Quality", severity: 0.3),
            .init(title: "Particulate Matter", severity: 0.1),
            .init(title: "Normal", severity: 0.4)
        ]
    
        @State var biosignals: [BioSignal] = [
        .init(title: "Respitory Rate", severity: 0.3),
        .init(title: "Heart Rate", severity: 0.3),
        .init(title: "Blood Oxygen", severity: 0.1),
        .init(title: "Normal", severity: 0.3)
        ]
    
    var body: some View {
        VStack {
            Text("Asthma Threats Breakdown")
                .font(Font.custom("Poppins-Regular", size: 20))
                .padding()
            
            
            
            VStack(spacing:20){
                
                let chartColors: [Color] = [
                    .pink, .pink, .pink, .blue
                ]
                
                VStack(spacing:10){
                    
                    Text("Biosignal Data Breakdown")
                        .font(Font.custom("Poppins-Regular", size: 16))
                        .padding()
                    Chart(biosignals) { biosignal in
                        SectorMark(
                            angle: .value(
                                Text(biosignal.title),
                                biosignal.severity
                            ),
                            innerRadius: .ratio(0.6),
                            angularInset: 0.8
                        )
                        .cornerRadius(4)
                        .foregroundStyle(by: .value("Threats", biosignal.title))
                    }.frame(width: 200, height: 150)
                        .chartForegroundStyleScale(domain: .automatic, range: chartColors)
                    
                    Text("Enviromental Data Breakdown")
                        .font(Font.custom("Poppins-Regular", size: 16))
                        .padding()
                    Chart(enviromental) { enviromental in
                        SectorMark(
                            angle: .value(
                                Text(enviromental.title),
                                enviromental.severity
                            ),
                            innerRadius: .ratio(0.6),
                            angularInset: 0.8
                        )
                        .cornerRadius(4)
                        .foregroundStyle(by: .value("Threats", enviromental.title))
                    }.frame(width: 200, height: 150)
                        .chartForegroundStyleScale(domain: .automatic, range: chartColors)
                }
            }
            
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
        }.padding(.all)
    }
}

