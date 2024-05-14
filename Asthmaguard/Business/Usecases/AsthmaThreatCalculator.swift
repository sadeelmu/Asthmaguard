//
//  AsthmaThreatCalculatorUseCase.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 06/05/2024.
//

import Foundation
import CoreLocation
import HealthKit

class AsthmaThreatCalculatorUseCase {
    private let locationManager = LocationManager.shared

    // MARK: - Monitoring

    static func startMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            fetchDataAndCalculateAsthmaSeverity()
        }
    }
    
    // MARK: - Data Fetching
    static func fetchDataAndCalculateAsthmaSeverity() {
        LocationManager.shared.requestLocation()
        
        BioSignalData.requestHealthDataAccessIfNeeded { success in
            guard success else {
                print("Failed to authorize HealthKit access.")
                return
            }
            
            fetchBiosignalData { biosignalSamples in
                guard let biosignalSamples = biosignalSamples else {
                    print("Failed to fetch biosignal data.")
                    return
                }
                
                // Fetch environmental data
                fetchEnvironmentalData { airQualityData, pollenForecastData in
                    guard let airQualityData = airQualityData, let pollenForecastData = pollenForecastData else {
                        print("Failed to fetch environmental data.")
                        return
                    }
                    
                    // Calculate asthma severity
                    let severity = calculateAsthmaSeverity(biosignalSamples: biosignalSamples, environmentalData: (airQualityData, pollenForecastData))
                    print("Asthma Threat: \(Int(severity * 100))%")
                }
            }
        }
    }
    
    static func fetchData() {
        // Request user's location permission
        LocationManager.shared.requestLocation()
        
        BioSignalData.requestHealthDataAccessIfNeeded { success in
            guard success else {
                print("Failed to authorize HealthKit access.")
                return
            }
        }
        
        fetchBiosignalData { biosignalSamples in
            // Fetch environmental data
            fetchEnvironmentalData { airQualityData, pollenForecastData in
                print("airQuality data \(airQualityData), pollenforecastData \(pollenForecastData), bioSignalData \(biosignalSamples)")
            }
        }
    }
    // MARK: - Biosignal Data
    
    static func fetchBiosignalData(completion: @escaping ([HKQuantitySample]?) -> Void) {
        BioSignalData.requestHealthDataAccessIfNeeded { success in
            guard success else {
                print("Failed to authorize HealthKit access.")
                completion(nil)
                return
            }
            
            var biosignalSamples: [HKQuantitySample] = []
            
            BioSignalData.fetchHeartRateSamples { heartRateSamples, _ in
                if let heartRateSamples = heartRateSamples {
                    print("Heart rate samples fetched: \(heartRateSamples.count)")
                    biosignalSamples.append(contentsOf: heartRateSamples)
                }
                
                // Print the heart rate samples to verify their content
                for sample in biosignalSamples {
                    print("Sample type: \(sample.quantityType)")
                }
                
                // Process biosignal data
                completion(biosignalSamples)
            }
        }
    }

    
    // MARK: - Biosignal Data Processing

    static func processBiosignalData(_ biosignalSamples: [HKQuantitySample]) {
        // Print biosignal data
        for sample in biosignalSamples {
            let identifier = sample.uuid.uuidString
            var valueString = ""
            var unitString = ""
            let timestamp = sample.startDate
            
            switch sample.quantityType.identifier {
            case HKQuantityTypeIdentifier.heartRate.rawValue:
                // Heart rate unit is beats per minute
                valueString = "\(sample.quantity.doubleValue(for: HKUnit(from: "count/min")))"
                unitString = "count/min"
            case HKQuantityTypeIdentifier.respiratoryRate.rawValue:
                // Respiratory rate unit is breaths per minute
                valueString = "\(sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())))"
                unitString = "breaths/min"
            case HKQuantityTypeIdentifier.oxygenSaturation.rawValue:
                // Oxygen saturation unit is percentage
                valueString = "\(sample.quantity.doubleValue(for: HKUnit.percent()))"
                unitString = "%"
            default:
                break
            }
            
            print("\(identifier) \(valueString) \(unitString) recorded at \(timestamp)")
        }
    }
    
    // MARK: - Environmental Data

    
    static func fetchEnvironmentalData(completion: @escaping (EnviromentalData.AirQualityData?, EnviromentalData.PollenForecastData?) -> Void) {
        guard let userLocation = LocationManager.shared.getCurrentLocation() else {
            print("User location not available")
            return
        }
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        // Fetch environmental data using user's location
        EnviromentalData().fetchAirQuality(latitude: latitude, longitude: longitude) { airQualityData in
            EnviromentalData().fetchPollenForecast(latitude: latitude, longitude: longitude) { pollenForecastData in
                completion(airQualityData, pollenForecastData)
            }
        }
    }
    
    // MARK: - AQI Calculation

    static func calculateAQIThreatLevel(latitude: Double, longitude: Double, completion: @escaping (Double) -> Void) {
        EnviromentalData().fetchAirQuality(latitude: latitude, longitude: longitude) { (airQualityData) in
            var aqiSeverity = 0.0
            
            if let universalAQI = airQualityData?.universalAQI {
                print("Universal AQI: \(universalAQI)")
                if universalAQI >= 101 {
                    print("Air quality is unhealthy for people with asthma.")
                    aqiSeverity = 1.0
                } else if universalAQI >= 51 {
                    print("Air quality can worsen asthma symptoms.")
                    aqiSeverity = 0.5
                } else {
                    print("Air quality is good for people with asthma.")
                    aqiSeverity = 0.0
                }
            } else {
                print("Failed to fetch air quality data.")
            }
            
            completion(aqiSeverity)
        }
    }
    
    // MARK: - Pollen Severity Calculation

    static func calculatePollenSeverity(_ pollenForecastData: EnviromentalData.PollenForecastData?) -> Double {
        guard let pollenTypes = pollenForecastData?.pollenTypes else {
            return 0.0 // No pollen data available, severity is minimal
        }
        
        // Map pollen categories to severity levels
        let categorySeverityMap: [String: Double] = [
            "None": 0.0,
            "Very Low": 0.2,
            "Low": 0.4,
            "Moderate": 0.6,
            "High": 0.8,
            "Very High": 1.0
        ]
        
        // Calculate severity based on the maximum severity level of all pollen types
        let maxSeverity = pollenTypes.map { categorySeverityMap[$0.indexInfo.category] ?? 0.0 }.max() ?? 0.0
        return maxSeverity
    }
    
    // MARK: - Asthma Severity Calculation

    static func calculateAsthmaSeverity(biosignalSamples: [HKQuantitySample]?, environmentalData: (EnviromentalData.AirQualityData?, EnviromentalData.PollenForecastData?)) -> Double {
        guard let biosignalSamples = biosignalSamples else {
            return 0.0 // No biosignal data available, severity is minimal
        }
        
        let heartRateSeverity = HealthDataAnalyzer.calculateHeartRateSeverity(samples: biosignalSamples)
        let respiratoryRateSeverity = HealthDataAnalyzer.calculateRespiratoryRateSeverity(samples: biosignalSamples)
        let oxygenSaturationSeverity = HealthDataAnalyzer.calculateOxygenSaturationSeverity(samples: biosignalSamples)
        
        guard let airQualityData = environmentalData.0 else {
            print("Air quality data not available")
            return 0.0
        }
        
        let locationManager = LocationManager.shared
        guard let userLocation = locationManager.getCurrentLocation() else {
            print("User location not available")
            return 0.0
        }
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        var airQualitySeverity = 0.0
        calculateAQIThreatLevel(latitude: latitude, longitude: longitude) { aqiSeverity in
            airQualitySeverity = aqiSeverity
        }
        
        let pollenSeverity = calculatePollenSeverity(environmentalData.1)
        
        
        return heartRateSeverity + respiratoryRateSeverity + oxygenSaturationSeverity + airQualitySeverity + pollenSeverity
    }

}

