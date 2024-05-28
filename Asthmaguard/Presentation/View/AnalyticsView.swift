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
    @State private var heartRateSeverity: Double = 0.0
    @State private var respiratoryRateSeverity: Double = 0.0
    @State private var oxygenSaturationSeverity: Double = 0.0
    @State private var airQualitySeverity: Double = 0.0
    @State private var pollenSeverity: Double = 0.0
    @State private var humiditySeverity: Double = 0.0
    @State private var cloudCoverSeverity: Double = 0.0
    @State private var temperatureSeverity: Double = 0.0

    private let asthmaThreatCalculatorUseCase = AsthmaThreatCalculatorUseCase()

    func updateSeverities() {
        DispatchQueue.main.async {
            self.heartRateSeverity = asthmaThreatCalculatorUseCase.weightedHeartRateSeverity
            self.respiratoryRateSeverity = asthmaThreatCalculatorUseCase.weightedRespiratoryRateSeverity
            self.oxygenSaturationSeverity = asthmaThreatCalculatorUseCase.weightedOxygenSaturationSeverity
            self.airQualitySeverity = asthmaThreatCalculatorUseCase.weightedAirQualitySeverity
            self.pollenSeverity = asthmaThreatCalculatorUseCase.weightedPollenSeverity
            self.humiditySeverity = asthmaThreatCalculatorUseCase.weightedHumiditySeverity
            self.cloudCoverSeverity = asthmaThreatCalculatorUseCase.weightedCloudCoverSeverity
            self.temperatureSeverity = asthmaThreatCalculatorUseCase.weightedTemperatureSeverity
        }
    }

    var body: some View {
        ScrollView {
            Text("Analytics")
                .font(Font.custom("Poppins-Bold", size: 18))
                .padding(.all, 5)

            VStack(spacing: 5) {
                Text("Asthma Threat Breakdown")
                    .font(Font.custom("Poppins-Regular", size: 22))
                    .padding(.all, 5)

                VStack(spacing: 5) {
                    let enviromentalChartColors: [Color] = [
                        .pink, .cyan, .green, .blue, .yellow
                    ]

                    let biosignalChartColors: [Color] = [
                        .pink, .blue, .green
                    ]

                    VStack(spacing: 5) {
                        Divider()
                        Text("📈 Biosignal Data Breakdown")
                            .font(Font.custom("Poppins-Bold", size: 18))
                            .padding()

                        VStack(alignment: .leading) {
                            Text("Heart Rate: \(heartRateSeverity * 100, specifier: "%.1f")%")
                            Text("Respiratory Rate: \(respiratoryRateSeverity * 100, specifier: "%.1f")%")
                            Text("SpO2: \(oxygenSaturationSeverity * 100, specifier: "%.1f")%")
                        }
                        .padding()

                        Text("The biosignal data and vital signs are increasing the asthma threat by \(heartRateSeverity + respiratoryRateSeverity + oxygenSaturationSeverity, specifier: "%.1f")%.")
                            .font(Font.custom("Poppins-Regular", size: 14))
                            .padding()
                            .multilineTextAlignment(.leading)

                        Chart {
                            SectorMark(
                                angle: .value("Heart Rate", heartRateSeverity),
                                innerRadius: .ratio(0.6),
                                angularInset: 0.8
                            )
                            .cornerRadius(4)
                            .foregroundStyle(by: .value("Threats", "Heart Rate"))

                            SectorMark(
                                angle: .value("Respiratory Rate", respiratoryRateSeverity),
                                innerRadius: .ratio(0.6),
                                angularInset: 0.8
                            )
                            .cornerRadius(4)
                            .foregroundStyle(by: .value("Threats", "Respiratory Rate"))

                            SectorMark(
                                angle: .value("SpO2", oxygenSaturationSeverity),
                                innerRadius: .ratio(0.6),
                                angularInset: 0.8
                            )
                            .cornerRadius(4)
                            .foregroundStyle(by: .value("Threats", "SpO2"))
                        }
                        .frame(width: 300, height: 175)
                        .chartForegroundStyleScale(domain: ["Heart Rate", "Respiratory Rate", "SpO2"], range: biosignalChartColors)
                    }

                    Divider().padding(.all, 10)

                    VStack(spacing: 5) {
                        Text("📊 Environmental Data Breakdown")
                            .font(Font.custom("Poppins-Bold", size: 18))
                            .padding()

                        VStack(alignment: .leading) {
                            Text("Pollen: \(pollenSeverity * 100, specifier: "%.1f")%")
                            Text("Air Quality: \(airQualitySeverity * 100, specifier: "%.1f")%")
                            Text("Humidity: \(humiditySeverity * 100, specifier: "%.1f")%")
                            Text("Cloud Cover: \(cloudCoverSeverity * 100, specifier: "%.1f")%")
                            Text("Temperature: \(temperatureSeverity * 100, specifier: "%.1f")%")
                        }
                        .padding()

                        Text("The environmental data is increasing the asthma threat by a total of \(pollenSeverity + airQualitySeverity + humiditySeverity + cloudCoverSeverity + temperatureSeverity, specifier: "%.1f")%.")
                            .font(Font.custom("Poppins-Regular", size: 14))
                            .padding()
                            .multilineTextAlignment(.leading)

                        Chart {
                            SectorMark(
                                angle: .value("Pollen", pollenSeverity),
                                innerRadius: .ratio(0.6),
                                angularInset: 0.8
                            )
                            .cornerRadius(4)
                            .foregroundStyle(by: .value("Threats", "Pollen"))

                            SectorMark(
                                angle: .value("Air Quality", airQualitySeverity),
                                innerRadius: .ratio(0.6),
                                angularInset: 0.8
                            )
                            .cornerRadius(4)
                            .foregroundStyle(by: .value("Threats", "Air Quality"))

                            SectorMark(
                                angle: .value("Humidity", humiditySeverity),
                                innerRadius: .ratio(0.6),
                                angularInset: 0.8
                            )
                            .cornerRadius(4)
                            .foregroundStyle(by: .value("Threats", "Humidity"))

                            SectorMark(
                                angle: .value("Cloud Cover", cloudCoverSeverity),
                                innerRadius: .ratio(0.6),
                                angularInset: 0.8
                            )
                            .cornerRadius(4)
                            .foregroundStyle(by: .value("Threats", "Cloud Cover"))

                            SectorMark(
                                angle: .value("Temperature", temperatureSeverity),
                                innerRadius: .ratio(0.6),
                                angularInset: 0.8
                            )
                            .cornerRadius(4)
                            .foregroundStyle(by: .value("Threats", "Temperature"))
                        }
                        .frame(width: 300, height: 175)
                        .chartForegroundStyleScale(domain: ["Pollen", "Air Quality", "Humidity", "Cloud Cover", "Temperature"], range: enviromentalChartColors)
                    }

                    Divider()
                    Spacer()
                }
            }
            Spacer()
        }
        .onAppear {
            updateSeverities()
        }
    }
}
