//
//  HealthDataAnalyzerTests.swift
//  AsthmaguardTests
//
//  Created by Sadeel Muwahed on 19/05/2024.
//

import XCTest
import HealthKit
@testable import Asthmaguard

class HealthDataAnalyzerTests: XCTestCase {

    func testCalculateHeartRateSeverity() {
        let samples = createHeartRateSamples(values: [50, 70, 120, 130])
        let severity = HealthDataAnalyzer.calculateHeartRateSeverity(samples: samples)
        XCTAssertEqual(severity, 0.3, "Heart rate severity calculation is incorrect")
    }

    func testCalculateRespiratoryRateSeverity() {
        let samples = createRespiratoryRateSamples(values: [10, 15, 25, 35])
        let severity = HealthDataAnalyzer.calculateRespiratoryRateSeverity(samples: samples)
        XCTAssertEqual(severity, 0.4, "Respiratory rate severity calculation is incorrect")
    }

    func testCalculateOxygenSaturationSeverity() {
        let samples = createOxygenSaturationSamples(values: [94, 89, 96, 85])
        let severity = HealthDataAnalyzer.calculateOxygenSaturationSeverity(samples: samples)
        XCTAssertEqual(severity, 0.3, "Oxygen saturation severity calculation is incorrect")
    }

    func testCalculateOverallSeverity() {
        let heartRateSamples = createHeartRateSamples(values: [50, 70, 120, 130])
        let respiratoryRateSamples = createRespiratoryRateSamples(values: [10, 15, 25, 35])
        let oxygenSaturationSamples = createOxygenSaturationSamples(values: [94, 89, 96, 85])
        
        let overallSeverity = HealthDataAnalyzer.calculateOverallSeverity(
            heartRateSamples: heartRateSamples,
            respiratoryRateSamples: respiratoryRateSamples,
            oxygenSaturationSamples: oxygenSaturationSamples
        )
        
        XCTAssertEqual(overallSeverity, 1.0, "Overall severity calculation is incorrect")
    }
    
    private func createHeartRateSamples(values: [Double]) -> [HKQuantitySample] {
        return values.map { value in
            let quantity = HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: value)
            return HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .heartRate)!, quantity: quantity, start: Date(), end: Date())
        }
    }
    
    private func createRespiratoryRateSamples(values: [Double]) -> [HKQuantitySample] {
        return values.map { value in
            let quantity = HKQuantity(unit: HKUnit.count().unitDivided(by: HKUnit.minute()), doubleValue: value)
            return HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .respiratoryRate)!, quantity: quantity, start: Date(), end: Date())
        }
    }
    
    private func createOxygenSaturationSamples(values: [Double]) -> [HKQuantitySample] {
        return values.map { value in
            let quantity = HKQuantity(unit: HKUnit.percent(), doubleValue: value)
            return HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!, quantity: quantity, start: Date(), end: Date())
        }
    }
}
