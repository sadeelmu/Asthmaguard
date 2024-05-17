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
        .init(title: "Air Quality", severity: 0.4),
        .init(title: "Cloudover", severity: 0.05),
        .init(title:"Humidity", severity: 0.15),
        .init(title: "Temperature", severity: 0.1)
    ]
    
    @State var biosignals: [BioSignal] = [
        .init(title: "Respitory Rate", severity: 0.3),
        .init(title: "Heart Rate", severity: 0.3),
        .init(title: "SpO2", severity: 0.1),
    ]
    
    var body: some View {
        ScrollView {
            Text("Analytics")
                .font(Font.custom("Poppins-Bold", size: 18))
                .padding(.all, 5)
            
            VStack(spacing:5){
                Text("Asthma Threat Breakdown")
                    .font(Font.custom("Poppins-Regular", size: 22))
                    .padding(.all, 5)
                
                VStack(spacing:5){
                    
                    let enviromentalChartColors: [Color] = [
                        .pink, .cyan, .green, .blue, .yellow
                    ]
                    
                    let biosignalChartColors: [Color] = [
                        .pink, .blue, .green
                    ]
                    
                    VStack(spacing:5){
                        
                        VStack(spacing:5){
                            Divider()
                            Text("📈 Biosignal Data Breakdown")
                                .font(Font.custom("Poppins-Bold", size: 18))
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
                            }.frame(width: 300, height: 175)
                                .chartForegroundStyleScale(domain: .automatic, range: biosignalChartColors)
                            
                            Text("The biosignal data and vital signs are increasing the asthma threat by 30%.")
                                .font(Font.custom("Poppins-Regular", size: 14))
                                .padding()
                                .multilineTextAlignment(.leading)
                        }
                        
                        Divider().padding(.all, 10)
                        
                        VStack(spacing:5){
                            Text("📊 Enviromental Data Breakdown")
                                .font(Font.custom("Poppins-Bold", size: 18))
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
                            }.frame(width: 300, height: 175)
                                .chartForegroundStyleScale(domain: .automatic, range: enviromentalChartColors)
                            
                            Text("The enviromental data is increasing the asthma threat by a total of 10%.")
                                .font(Font.custom("Poppins-Regular", size: 14))
                                .padding()
                                .multilineTextAlignment(.leading)
                            
                        }
                        Divider()
                        Spacer()
                    }
                }
                
                Spacer()
                
                
            }
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
