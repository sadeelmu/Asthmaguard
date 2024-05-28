//
//  AsthmaThreatChart.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 28/05/2024.
//

import Foundation
import SwiftUI
import Charts

@available(iOS 17.0, *)
struct AsthmaThreatChart: View {
    @State private var totalWeightedSeverity: Double = 0.0
    @State private var biosignalRisk: Double = 0.0
    @State private var environmentalRisk: Double = 0.0
    @State private var showHighThreatAlert: Bool = false
    @State private var showVeryHighThreatActionSheet: Bool = false

    @State var asthmathreat: [AsthmaThreat] = [
        .init(title: "Biosignals", risks: 0.3),
        .init(title: "Environmental", risks: 0.1),
        .init(title: "Normal", risks: 0.6)
    ]

    private let asthmaThreatCalculatorUseCase = AsthmaThreatCalculatorUseCase()

    func updateAsthmaThreat() {
        asthmaThreatCalculatorUseCase.fetchDataAndCalculateAsthmaSeverity()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Use a delay to allow for data fetching; adjust timing as necessary
            self.biosignalRisk = 0.3
            self.environmentalRisk = 0.1
            self.totalWeightedSeverity = 0.4

            if totalWeightedSeverity > 0.75 {
                showVeryHighThreatActionSheet = true
            } else if totalWeightedSeverity > 0.50 {
                showHighThreatAlert = true
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Text("Dashboard")
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
                            CustomBioData(bioSignal: "Respiratory Rate", time: "11:55 AM", data: "19 breaths/min")
                        }
                        NavigationLink(destination: HistoricalDataView(bioSignal: "Heart Rate")) {
                            CustomBioData(bioSignal: "Heart Rate", time: "12:01 PM", data: "96 BPM")
                        }
                        NavigationLink(destination: HistoricalDataView(bioSignal: "Blood Oxygen")) {
                            CustomBioData(bioSignal: "Blood Oxygen", time: "12:03 PM", data: "98.5%")
                        }
                    }
                    Spacer()
                }
                .onAppear() {
                    updateAsthmaThreat()
                }
                .alert(isPresented: $showHighThreatAlert) {
                    Alert(
                        title: Text("High asthma threat detected"),
                        primaryButton: .default(Text("Contact emergency contact")) {
                            // Handle contact emergency action
                        },
                        secondaryButton: .cancel(Text("Dismiss"))
                    )
                }
                .actionSheet(isPresented: $showVeryHighThreatActionSheet) {
                    ActionSheet(
                        title: Text("Very High Asthma threat detected!"),
                        message: Text("Would you like to start breathing exercises?"),
                        buttons: [
                            .default(Text("Start")) {
                                // Handle start breathing exercises action
                            },
                            .default(Text("Contact emergency contact")) {
                                // Handle contact emergency action
                            },
                            .cancel(Text("Dismiss"))
                        ]
                    )
                }
            }
        }
    }
}
