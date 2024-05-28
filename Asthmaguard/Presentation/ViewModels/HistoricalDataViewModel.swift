//
//  HistoricalDataViewModel.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 28/05/2024.
//

import Foundation
import SwiftUI
import HealthKit

class HistoricalDataViewModel: ObservableObject {
    @Published var heartRateSamples: [HKQuantitySample] = []
    @Published var respiratoryRateSamples: [HKQuantitySample] = []
    @Published var oxygenSaturationSamples: [HKQuantitySample] = []

    func fetchHealthData() {
        BioSignalData.requestHealthDataAccessIfNeeded { success in
            guard success else {
                print("Failed to authorize HealthKit access.")
                return
            }

            BioSignalData.fetchAllSamples { samples, error in
                DispatchQueue.main.async {
                    guard let samples = samples, error == nil else {
                        print("Failed to fetch health data: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }

                    self.heartRateSamples = samples.filter { $0.quantityType == HKQuantityType.quantityType(forIdentifier: .heartRate)! }
                    self.respiratoryRateSamples = samples.filter { $0.quantityType == HKQuantityType.quantityType(forIdentifier: .respiratoryRate)! }
                    self.oxygenSaturationSamples = samples.filter { $0.quantityType == HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)! }
                }
            }
        }
    }
}

