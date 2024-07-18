//
//  HealthDataAnalyzer.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 06/05/2024.
//

import Foundation
import HealthKit

class HealthDataAnalyzer {
    
    // MARK: - calculateHeartRateSeverity
    static func calculateHeartRateSeverity(samples: [HKQuantitySample]) -> Double {
        let normalHeartRateRange = 60.0...100.0
        var severity = 0.0
        for sample in samples {
            let value = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
            if !normalHeartRateRange.contains(value) {
                severity += value > 120.0 ? 0.2 : 0.1
            }
        }
        return severity
    }
    
    // MARK: - calculateRespiratoryRateSeverity
    static func calculateRespiratoryRateSeverity(samples: [HKQuantitySample]) -> Double {
        let normalRespiratoryRateRange = 12.0...20.0
        var severity = 0.0
        for sample in samples {
            let value = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
            if !normalRespiratoryRateRange.contains(value) {
                severity += value > 30.0 ? 0.2 : 0.1
            }
        }
        return severity
    }
    
    // MARK: - calculateOxygenSaturationSeverity
    static func calculateOxygenSaturationSeverity(samples: [HKQuantitySample]) -> Double {
        let normalOxygenSaturationRange = 95.0...100.0
        var severity = 0.0
        for sample in samples {
            guard sample.quantityType.identifier == HKQuantityTypeIdentifier.oxygenSaturation.rawValue else {
                continue
            }
            let value = sample.quantity.doubleValue(for: HKUnit.percent())
            if !normalOxygenSaturationRange.contains(value) {
                severity += value < 90.0 ? 0.2 : 0.1
            }
        }
        return severity
    }
    
    // MARK: - calculateOverallSeverity
    static func calculateOverallSeverity(heartRateSamples: [HKQuantitySample], respiratoryRateSamples: [HKQuantitySample], oxygenSaturationSamples: [HKQuantitySample]) -> Double {
        let heartRateSeverity = calculateHeartRateSeverity(samples: heartRateSamples)
        let respiratoryRateSeverity = calculateRespiratoryRateSeverity(samples: respiratoryRateSamples)
        let oxygenSaturationSeverity = calculateOxygenSaturationSeverity(samples: oxygenSaturationSamples)
        let overallSeverity = heartRateSeverity + respiratoryRateSeverity + oxygenSaturationSeverity
        print("Overall biosignal severyity = \(overallSeverity)")
        return overallSeverity
    }
}
