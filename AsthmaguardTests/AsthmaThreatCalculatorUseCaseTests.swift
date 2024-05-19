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
    var weatherKitData: WeatherKitData!

    override func setUp() {
        super.setUp()
        asthmaThreatCalculator = AsthmaThreatCalculatorUseCase()
        weatherKitData = WeatherKitData()
    }

    override func tearDown() {
        asthmaThreatCalculator = nil
        weatherKitData = nil
        super.tearDown()
    }

    func testCalculateAQISeverity() {
        let highAQI = 150
        let moderateAQI = 75
        let lowAQI = 25
        
        XCTAssertEqual(asthmaThreatCalculator.calculateAQISeverity(aqiLevel: highAQI), 1.0, "High AQI should return severity of 1.0")
        XCTAssertEqual(asthmaThreatCalculator.calculateAQISeverity(aqiLevel: moderateAQI), 0.5, "Moderate AQI should return severity of 0.5")
        XCTAssertEqual(asthmaThreatCalculator.calculateAQISeverity(aqiLevel: lowAQI), 0.0, "Low AQI should return severity of 0.0")
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

    // New tests for weather severity calculations

    func testCalculateHumiditySeverity() {
        let lowHumidity = 45.0
        let mediumHumidity = 55.0
        let highHumidity = 75.0
        
        XCTAssertEqual(weatherKitData.calculateHumiditySeverity(humidity: lowHumidity), 0.0, "Low humidity should return severity of 0.0")
        XCTAssertEqual(weatherKitData.calculateHumiditySeverity(humidity: mediumHumidity), 0.25, "Medium humidity should return severity of 0.25")
        XCTAssertEqual(weatherKitData.calculateHumiditySeverity(humidity: highHumidity), 1.0, "High humidity should return severity of 1.0")
    }
    
    func testCalculateCloudCoverSeverity() {
        let lowCloudCover = 0.4
        let mediumCloudCover = 0.7
        let highCloudCover = 0.9
        
        XCTAssertEqual(weatherKitData.calculateCloudCoverSeverity(cloudCover: lowCloudCover), 0.0, "Low cloud cover should return severity of 0.0")
        XCTAssertEqual(weatherKitData.calculateCloudCoverSeverity(cloudCover: mediumCloudCover), 0.0, "Medium cloud cover should return severity of 0.0")
        XCTAssertEqual(weatherKitData.calculateCloudCoverSeverity(cloudCover: highCloudCover), 1.0, "High cloud cover should return severity of 1.0")
    }
    
    func testCalculateTemperatureSeverity() {
        let warmTemperature = 15.0
        let coldTemperature = -5.0
        let veryColdTemperature = -15.0
        
        XCTAssertEqual(weatherKitData.calculateTemperatureSeverity(temperature: warmTemperature), 0.0, "Warm temperature should return severity of 0.0")
        XCTAssertEqual(weatherKitData.calculateTemperatureSeverity(temperature: coldTemperature), 0.5, "Cold temperature should return severity of 0.5")
        XCTAssertEqual(weatherKitData.calculateTemperatureSeverity(temperature: veryColdTemperature), 1.0, "Very cold temperature should return severity of 1.0")
    }

    // Updated test for calculating weighted severity including weather factors

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
