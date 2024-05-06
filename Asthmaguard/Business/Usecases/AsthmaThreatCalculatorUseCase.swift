//
//  AsthmaThreatCalculatorUseCase.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 06/05/2024.
//

import Foundation
import CoreLocation
import HealthKit

struct AsthmaSeverity {
    var repositoryRateSeverity: Double
    var bloodOxygenSeverity: Double
    var heartRateSeverity: Double
    var pollutionSeverity: Double
    var pollenSeverity: Double
}

class AsthmaThreatCalculatorUseCase {
    private let locationManager = LocationManager.shared

    static func startMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            fetchDataAndCalculateAsthmaSeverity()
        }
    }
    
    static func fetchDataAndCalculateAsthmaSeverity() {
        // Fetch biosignal data
        fetchBiosignalData { biosignalSamples in
            // Fetch environmental data
            fetchEnvironmentalData { airQualityData, pollenForecastData in
                // Calculate asthma severity
                let severity = calculateAsthmaSeverity(biosignalSamples: biosignalSamples, environmentalData: (airQualityData, pollenForecastData))
                print("Asthma Threat: \(Int(severity * 100))%")
                // Here you can update UI or take any other action based on the severity
            }
        }
    }
    
    static func fetchData(){
        fetchBiosignalData { biosignalSamples in
            // Fetch environmental data
            fetchEnvironmentalData { airQualityData, pollenForecastData in
                print("airQuality data \(airQualityData), pollenforecastData \(pollenForecastData), bioSignalData \(biosignalSamples)")
            }
        }
    }
    
    static func fetchBiosignalData(completion: @escaping ([HKQuantitySample]?) -> Void) {
        BioSignalData.fetchHeartRateSamples { heartRateSamples, _ in
            // Handle heart rate samples
            BioSignalData.fetchRespiratoryRateSamples { respiratoryRateSamples, _ in
                // Handle respiratory rate samples
                BioSignalData.fetchOxygenSaturationSamples { oxygenSaturationSamples, _ in
                    // Handle oxygen saturation samples
                    let biosignalSamples = [heartRateSamples, respiratoryRateSamples, oxygenSaturationSamples].compactMap { $0 }.flatMap { $0 }
                    completion(biosignalSamples)
                }
            }
        }
    }
    
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
    
    static func calculateAsthmaSeverity(biosignalSamples: [HKQuantitySample]?, environmentalData: (EnviromentalData.AirQualityData?, EnviromentalData.PollenForecastData?)) -> Double {
        guard let biosignalSamples = biosignalSamples else {
            return 0.0 // No biosignal data available, severity is minimal
        }

        // Define normal ranges for biosignal parameters
        let normalHeartRateRange = 60.0...100.0 // Normal range for heart rate (beats per minute) for healthy adults
        let normalRespiratoryRateRange = 12.0...20.0 // Normal range for respiratory rate (breaths per minute) for healthy adults
        let normalOxygenSaturationRange = 95.0...100.0 // Normal range for oxygen saturation (%) for healthy adults

        // Calculate severity based on deviation from normal ranges
        var biosignalSeverity = 0.0

        for sample in biosignalSamples {
            let value = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))

            switch sample.quantityType.identifier {
            case HKQuantityTypeIdentifier.heartRate.rawValue:
                if !normalHeartRateRange.contains(value) {
                    biosignalSeverity += value > 120.0 ? 0.2 : 0.1 // Increase severity for heart rate deviation based on asthmatic exacerbation criteria
                }
            case HKQuantityTypeIdentifier.respiratoryRate.rawValue:
                if !normalRespiratoryRateRange.contains(value) {
                    biosignalSeverity += value > 30.0 ? 0.2 : 0.1 // Increase severity for respiratory rate deviation based on asthmatic exacerbation criteria
                }
            case HKQuantityTypeIdentifier.oxygenSaturation.rawValue:
                if !normalOxygenSaturationRange.contains(value) {
                    biosignalSeverity += value < 90.0 ? 0.2 : 0.1 // Increase severity for oxygen saturation deviation based on asthmatic exacerbation criteria
                }
            default:
                break
            }
        }
        
        let airQualitySeverity = Double(environmentalData.0?.universalAQI ?? 0) // Use air quality data to calculate severity
        let pollenSeverity = environmentalData.1?.pollenTypes.count ?? 0 > 0 ? 0.1 : 0.0 // Increase severity if pollen forecast is available
        return biosignalSeverity + airQualitySeverity + pollenSeverity
    }
}

