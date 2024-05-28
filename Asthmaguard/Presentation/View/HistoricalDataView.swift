//
//  HistoricalDataView.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 28/05/2024.
//

import Foundation
import SwiftUI
import HealthKit

@available(iOS 17.0, *)
struct HistoricalDataView: View {
    var bioSignal: String
    @State private var samples: [HKQuantitySample] = []
    
    var body: some View {
        VStack {
            Text("\(bioSignal) Historical Data")
                .font(Font.custom("Poppins-Bold", size: 18))
                .padding()
            
            List(samples, id: \.uuid) { sample in
                VStack(alignment: .leading) {
                    Text(String(format: "%.1f", sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))))
                    Text("\(sample.startDate.formatted(.dateTime.year().month().day().hour().minute().second()))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            fetchHistoricalData(for: bioSignal)
        }
    }
    
    private func fetchHistoricalData(for bioSignal: String) {
        BioSignalData.requestHealthDataAccessIfNeeded { success in
            guard success else {
                print("HealthKit authorization failed")
                return
            }
            
            switch bioSignal {
            case "Heart Rate":
                BioSignalData.fetchHeartRateSamples { samples, error in
                    if let samples = samples {
                        self.samples = samples
                    }
                }
            case "Respiratory Rate":
                BioSignalData.fetchRespiratoryRateSamples { samples, error in
                    if let samples = samples {
                        self.samples = samples
                    }
                }
            case "Blood Oxygen":
                BioSignalData.fetchOxygenSaturationSamples { samples, error in
                    if let samples = samples {
                        self.samples = samples
                    }
                }
            default:
                print("Unknown bio signal type")
            }
        }
    }
}

struct HealthDataListView: View {
    let title: String
    let samples: [HKQuantitySample]
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Font.custom("Poppins-Regular", size: 18))
                .padding(.bottom, 4)
            
            ForEach(samples, id: \.uuid) { sample in
                VStack(alignment: .leading) {
                    Text("\(sample.quantity.doubleValue(for: .count().unitDivided(by: .minute()))) \(unit)")
                    Text("Date: \(sample.startDate, formatter: DateFormatter.short)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
    }
}

extension DateFormatter {
    static let short: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}


