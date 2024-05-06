//
//  HealthDataAnalyzer.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 06/05/2024.
//

import Foundation
import HealthKit

class HealthDataAnalyzer {
    
    static func calculateHeartRateSeverity(samples: [HKQuantitySample]) -> Double {
        // Define normal range for heart rate (beats per minute) for healthy adults
        let normalHeartRateRange = 60.0...100.0
        
        // Calculate severity based on deviation from normal range
        var severity = 0.0
        for sample in samples {
            let value = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
            print("Sample type: \(sample.quantityType.identifier), Value: \(value)")
            if !normalHeartRateRange.contains(value) {
                // Increase severity for heart rate deviation based on criteria
                severity += value > 120.0 ? 0.2 : 0.1
            }
        }
        return severity
    }

    // Calculate severity based on respiratory rate
    static func calculateRespiratoryRateSeverity(samples: [HKQuantitySample]) -> Double {
        // Define normal range for respiratory rate (breaths per minute) for healthy adults
        let normalRespiratoryRateRange = 12.0...20.0
        
        // Calculate severity based on deviation from normal range
        var severity = 0.0
        for sample in samples {
            let value = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
            if !normalRespiratoryRateRange.contains(value) {
                // Increase severity for respiratory rate deviation based on criteria
                severity += value > 30.0 ? 0.2 : 0.1
            }
        }
        return severity
    }
    
    // Calculate severity based on oxygen saturation
    static func calculateOxygenSaturationSeverity(samples: [HKQuantitySample]) -> Double {
        // Define normal range for oxygen saturation (%) for healthy adults
        let normalOxygenSaturationRange = 95.0...100.0
        
        // Calculate severity based on deviation from normal range
        var severity = 0.0
        for sample in samples {
            // Check if the sample represents oxygen saturation
            guard sample.quantityType.identifier == HKQuantityTypeIdentifier.oxygenSaturation.rawValue else {
                // Skip if it's not oxygen saturation
                continue
            }
            
            // Get the value in percentage
            let value = sample.quantity.doubleValue(for: HKUnit.percent())
            
            // Check if value is within expected range
            if !normalOxygenSaturationRange.contains(value) {
                // Increase severity for oxygen saturation deviation based on criteria
                severity += value < 90.0 ? 0.2 : 0.1
            }
        }
        return severity
    }


    
    // Calculate overall severity based on all health metrics
    static func calculateOverallSeverity(heartRateSamples: [HKQuantitySample], respiratoryRateSamples: [HKQuantitySample], oxygenSaturationSamples: [HKQuantitySample]) -> Double {
        let heartRateSeverity = calculateHeartRateSeverity(samples: heartRateSamples)
        let respiratoryRateSeverity = calculateRespiratoryRateSeverity(samples: respiratoryRateSamples)
        let oxygenSaturationSeverity = calculateOxygenSaturationSeverity(samples: oxygenSaturationSamples)
        
        // Aggregate severity from all metrics
        let overallSeverity = heartRateSeverity + respiratoryRateSeverity + oxygenSaturationSeverity
        print("Overall bio signal severy = \(overallSeverity)")
        return overallSeverity
    }
}
