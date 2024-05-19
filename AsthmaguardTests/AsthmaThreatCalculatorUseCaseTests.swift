//
//  AsthmaThreatCalculatorUseCaseTests.swift
//  AsthmaguardTests
//
//  Created by Sadeel Muwahed on 19/05/2024.
//

import XCTest
@testable import Asthmaguard

class AsthmaThreatCalculatorUseCaseTests: XCTestCase {

    var asthmaThreatCalculator: AsthmaThreatCalculatorUseCase!

    override func setUp() {
        super.setUp()
        asthmaThreatCalculator = AsthmaThreatCalculatorUseCase()
    }

    override func tearDown() {
        asthmaThreatCalculator = nil
        super.tearDown()
    }

    func testCalculateAQISeverity() {
        let highAQI = 150
        let moderateAQI = 75
        let lowAQI = 25
        
        XCTAssertEqual(asthmaThreatCalculator.calculateAQISeverity(universalAQI: highAQI), 1.0, "High AQI should return severity of 1.0")
        XCTAssertEqual(asthmaThreatCalculator.calculateAQISeverity(universalAQI: moderateAQI), 0.5, "Moderate AQI should return severity of 0.5")
        XCTAssertEqual(asthmaThreatCalculator.calculateAQISeverity(universalAQI: lowAQI), 0.0, "Low AQI should return severity of 0.0")
    }

    func testCalculatePollenSeverity() {
        let pollenForecastData = EnviromentalData.PollenForecastData(
            date: Date(),
            pollenTypes: [
                EnviromentalData.PollenType(code: "tree", indexInfo: EnviromentalData.IndexInfo(category: "High", displayName: "High"))
            ]
        )
        
        XCTAssertEqual(asthmaThreatCalculator.calculatePollenSeverity(pollenForecastData: pollenForecastData), 0.8, "High pollen category should return severity of 0.8")
    }

    func testCalculateWeightedSeverity() {
        let heartRateSeverity = 0.5
        let respiratoryRateSeverity = 0.4
        let oxygenSaturationSeverity = 0.3
        let airQualitySeverity = 0.6
        let pollenSeverity = 0.7
        let humiditySeverity = 0.5
        let cloudCoverSeverity = 0.4
        let temperatureSeverity = 0.2
        
        let grades = [5, 4, 3, 5, 2, 1, 3, 4]
        
        let weightedSeverity = asthmaThreatCalculator.calculateWeightedSeverity(
            heartRateSeverity: heartRateSeverity,
            respiratoryRateSeverity: respiratoryRateSeverity,
            oxygenSaturationSeverity: oxygenSaturationSeverity,
            airQualitySeverity: airQualitySeverity,
            pollenSeverity: pollenSeverity,
            humiditySeverity: humiditySeverity,
            cloudCoverSeverity: cloudCoverSeverity,
            temperatureSeverity: temperatureSeverity,
            triggerGrades: grades
        )
        
        XCTAssertEqual(weightedSeverity, (heartRateSeverity * 5 + respiratoryRateSeverity * 4 + oxygenSaturationSeverity * 3 + airQualitySeverity * 5 + pollenSeverity * 2 + humiditySeverity * 1 + cloudCoverSeverity * 3 + temperatureSeverity * 4) / 27.0, "Weighted severity calculation is incorrect")
    }
}
