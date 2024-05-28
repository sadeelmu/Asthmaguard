//
//  AsthmaThreatCalculatorUseCase.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 06/05/2024.
//

import Foundation
import CoreLocation
import HealthKit

public class AsthmaThreatCalculatorUseCase {
    private let locationManager = LocationManager.shared
    private let weatherKitData = WeatherKitData()
    private let healthStore = HKHealthStore()
    private let databaseManager = DatabaseManager.shared
    
    var weightedEnvironmentalRisk: Double = 0.0
    var weightedBioSignalRisk: Double = 0.0
    
    var weightedHeartRateSeverity: Double = 0.0
    var weightedRespiratoryRateSeverity: Double = 0.0
    var weightedOxygenSaturationSeverity: Double = 0.0
    var weightedAirQualitySeverity: Double = 0.0
    var weightedPollenSeverity: Double = 0.0
    var weightedHumiditySeverity: Double = 0.0
    var weightedCloudCoverSeverity: Double = 0.0
    var weightedTemperatureSeverity: Double = 0.0
    var totalWeightedSeverity: Double = 0.0

    init() {
        startMonitoring()
    }
    
    // MARK: - Monitoring

    func startMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.fetchDataAndCalculateAsthmaSeverity()
        }
    }
    
    // MARK: - Data Fetching
    
    func fetchDataAndCalculateAsthmaSeverity() {
         guard let patientToken = getPatientToken() else {
             print("Current token not available.")
             return
         }
         
         databaseManager.fetchUserID(byToken: patientToken) { userID in
             guard let userID = userID else {
                 print("User ID not found for token: \(patientToken).")
                 return
             }
             
             self.fetchBiosignalData { biosignalSamples in
                 guard let biosignalSamples = biosignalSamples else {
                     print("Failed to fetch biosignal data.")
                     return
                 }
                 
                 self.fetchEnvironmentalData { airQualityData, pollenForecastData in
                     guard let airQualityData = airQualityData, let pollenForecastData = pollenForecastData else {
                         print("Failed to fetch environmental data.")
                         return
                     }
                     
                     self.fetchWeatherData { weatherData in
                         guard let weatherData = weatherData else {
                             print("Failed to fetch weather data.")
                             return
                         }
                         
                         self.calculateAsthmaSeverity(userID: userID, biosignalSamples: biosignalSamples, environmentalData: (airQualityData, pollenForecastData), weatherData: weatherData)
                     }
                 }
             }
         }
     }
    
    func fetchData() {
        guard let patientToken = getPatientToken() else {
            print("Current username not available.")
            return
        }
        
        databaseManager.fetchUserID(byToken: patientToken) { userID in
            guard let userID = userID else {
                print("User ID not found for username: \(patientToken).")
                return
            }
            
            self.fetchBiosignalData { biosignalSamples in
                self.fetchEnvironmentalData { airQualityData, pollenForecastData in
                    self.fetchWeatherData { weatherData in
                        print("airQuality data \(String(describing: airQualityData)), pollenForecastData \(String(describing: pollenForecastData)), weatherData \(String(describing: weatherData)), bioSignalData \(String(describing: biosignalSamples))")
                    }
                }
            }
        }
    }
    
    // MARK: - Biosignal Data
    
    private func fetchBiosignalData(completion: @escaping ([HKQuantitySample]?) -> Void) {
        BioSignalData.requestHealthDataAccessIfNeeded { success in
            guard success else {
                print("Failed to authorize HealthKit access.")
                completion(nil)
                return
            }
            
            BioSignalData.fetchAllSamples { samples, error in
                if let samples = samples {
                    completion(samples)
                } else {
                    print("Failed to fetch biosignal data: \(error?.localizedDescription ?? "unknown error")")
                    completion(nil)
                }
            }
        }
    }

    // MARK: - Environmental Data
    
    private func fetchEnvironmentalData(completion: @escaping (EnviromentalData.AirQualityData?, EnviromentalData.PollenForecastData?) -> Void) {
        guard let userLocation = LocationManager.shared.getCurrentLocation() else {
            print("User location not available")
            completion(nil, nil)
            return
        }
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let environmentalData = EnviromentalData()
        environmentalData.fetchAirQuality(latitude: latitude, longitude: longitude) { airQualityData in
            environmentalData.fetchPollenForecast(latitude: latitude, longitude: longitude) { pollenForecastData in
                completion(airQualityData, pollenForecastData)
            }
        }
    }

    // MARK: - Weather Data
    
    private func fetchWeatherData(completion: @escaping (WeatherKitData.WeatherData?) -> Void) {
        guard let userLocation = LocationManager.shared.getCurrentLocation() else {
            print("User location not available")
            completion(nil)
            return
        }
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        weatherKitData.fetchWeatherData(latitude: latitude, longitude: longitude) { weatherData in
            completion(weatherData)
        }
    }

    // MARK: - Asthma Severity Calculation
    
    private func calculateAsthmaSeverity(userID: Int, biosignalSamples: [HKQuantitySample], environmentalData: (EnviromentalData.AirQualityData?, EnviromentalData.PollenForecastData?), weatherData: WeatherKitData.WeatherData) {
        databaseManager.fetchAsthmaTriggers(forUserID: userID) { triggerGrades in
            let heartRateSeverity = HealthDataAnalyzer.calculateHeartRateSeverity(samples: biosignalSamples)
            let respiratoryRateSeverity = HealthDataAnalyzer.calculateRespiratoryRateSeverity(samples: biosignalSamples)
            let oxygenSaturationSeverity = HealthDataAnalyzer.calculateOxygenSaturationSeverity(samples: biosignalSamples)
            
            let airQualitySeverity = self.calculateAQISeverity(aqiLevel: environmentalData.0?.universalAQI)
            let pollenSeverity = self.calculatePollenSeverity(pollenForecastData: environmentalData.1)
            let humiditySeverity = self.weatherKitData.calculateHumiditySeverity(humidity: weatherData.humidity)
            let cloudCoverSeverity = self.weatherKitData.calculateCloudCoverSeverity(cloudCover: weatherData.cloudCover)
            let temperatureSeverity = self.weatherKitData.calculateTemperatureSeverity(temperature: weatherData.temperature)
            
            self.weightedHeartRateSeverity = heartRateSeverity * Double(triggerGrades[0])
            self.weightedRespiratoryRateSeverity = respiratoryRateSeverity * Double(triggerGrades[1])
            self.weightedOxygenSaturationSeverity = oxygenSaturationSeverity * Double(triggerGrades[2])
            self.weightedAirQualitySeverity = airQualitySeverity * Double(triggerGrades[3])
            self.weightedPollenSeverity = pollenSeverity * Double(triggerGrades[4])
            self.weightedHumiditySeverity = humiditySeverity * Double(triggerGrades[5])
            self.weightedCloudCoverSeverity = cloudCoverSeverity * Double(triggerGrades[6])
            self.weightedTemperatureSeverity = temperatureSeverity * Double(triggerGrades[7])
            
            let biosignalWeightsTotal = Double(triggerGrades[0] + triggerGrades[1] + triggerGrades[2])
            let environmentalWeightsTotal = Double(triggerGrades[3] + triggerGrades[4] + triggerGrades[5] + triggerGrades[6] + triggerGrades[7])
            let totalWeights = biosignalWeightsTotal + environmentalWeightsTotal
            
            self.weightedBioSignalRisk = (
                self.weightedHeartRateSeverity +
                self.weightedRespiratoryRateSeverity +
                self.weightedOxygenSaturationSeverity
            ) / biosignalWeightsTotal
            
            self.weightedEnvironmentalRisk = (
                self.weightedAirQualitySeverity +
                self.weightedPollenSeverity +
                self.weightedHumiditySeverity +
                self.weightedCloudCoverSeverity +
                self.weightedTemperatureSeverity
            ) / environmentalWeightsTotal

            self.totalWeightedSeverity = (
                self.weightedHeartRateSeverity +
                self.weightedRespiratoryRateSeverity +
                self.weightedOxygenSaturationSeverity +
                self.weightedAirQualitySeverity +
                self.weightedPollenSeverity +
                self.weightedHumiditySeverity +
                self.weightedCloudCoverSeverity +
                self.weightedTemperatureSeverity
            ) / totalWeights
            
            print("Weighted Environmental Risk: \(self.weightedEnvironmentalRisk)")
            print("Weighted BioSignal Risk: \(self.weightedBioSignalRisk)")
            print("Total Weighted Severity: \(self.totalWeightedSeverity)")
        }
    }
    
    func calculateAQISeverity(aqiLevel: Int?) -> Double {
        guard let aqiLevel = aqiLevel else {
            return 0.0
        }
        
        if aqiLevel >= 101 {
            return 1.0
        } else if aqiLevel >= 51 {
            return 0.5
        } else {
            return 0.0
        }
    }
    
    func calculatePollenSeverity(pollenForecastData: EnviromentalData.PollenForecastData?) -> Double {
        guard let pollenTypes = pollenForecastData?.pollenTypes else {
            return 0.0
        }
        
        let categorySeverityMap: [String: Double] = [
            "None": 0.0,
            "Very Low": 0.2,
            "Low": 0.4,
            "Moderate": 0.6,
            "High": 0.8,
            "Very High": 1.0
        ]
        
        let maxSeverity = pollenTypes.map { categorySeverityMap[$0.indexInfo.category] ?? 0.0 }.max() ?? 0.0
        return maxSeverity
    }

    private func getPatientToken() -> Int? {
           return SessionManager.shared.getCurrentToken()
       }
}
