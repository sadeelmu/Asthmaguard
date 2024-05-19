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
    private let weatherKitData = WeatherKitData()
    private let healthStore = HKHealthStore()
    private let databaseManager = DatabaseManager.shared

    // MARK: - Monitoring

    func startMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.fetchDataAndCalculateAsthmaSeverity()
        }
    }
    
    // MARK: - Data Fetching
    
    private func fetchDataAndCalculateAsthmaSeverity() {
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
                    
                    self.calculateAsthmaSeverity(biosignalSamples: biosignalSamples, environmentalData: (airQualityData, pollenForecastData), weatherData: weatherData)
                }
            }
        }
    }
    
    func fetchData() {
        self.fetchBiosignalData { biosignalSamples in
            self.fetchEnvironmentalData { airQualityData, pollenForecastData in
                self.fetchWeatherData { weatherData in
                    print("airQuality data \(String(describing: airQualityData)), pollenForecastData \(String(describing: pollenForecastData)), weatherData \(String(describing: weatherData)), bioSignalData \(String(describing: biosignalSamples))")
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
    
    private func calculateAsthmaSeverity(biosignalSamples: [HKQuantitySample], environmentalData: (EnviromentalData.AirQualityData?, EnviromentalData.PollenForecastData?), weatherData: WeatherKitData.WeatherData) {
        let userID = 1 // Example userID, replace with actual user ID
        databaseManager.fetchAsthmaTriggers(forUserID: userID) { triggerGrades in
            let heartRateSeverity = HealthDataAnalyzer.calculateHeartRateSeverity(samples: biosignalSamples)
            let respiratoryRateSeverity = HealthDataAnalyzer.calculateRespiratoryRateSeverity(samples: biosignalSamples)
            let oxygenSaturationSeverity = HealthDataAnalyzer.calculateOxygenSaturationSeverity(samples: biosignalSamples)
            
            var airQualitySeverity = 0.0
            if let airQualityData = environmentalData.0 {
                airQualitySeverity = self.calculateAQISeverity(aqiLevel: airQualityData.universalAQI)
            }
            
            let pollenSeverity = self.calculatePollenSeverity(pollenForecastData: environmentalData.1)
            let humiditySeverity = self.weatherKitData.calculateHumiditySeverity(humidity: weatherData.humidity)
            let cloudCoverSeverity = self.weatherKitData.calculateCloudCoverSeverity(cloudCover: weatherData.cloudCover)
            let temperatureSeverity = self.weatherKitData.calculateTemperatureSeverity(temperature: weatherData.temperature)
            
            let weightedSeverity = self.calculateWeightedSeverity(
                heartRateSeverity: heartRateSeverity,
                respiratoryRateSeverity: respiratoryRateSeverity,
                oxygenSaturationSeverity: oxygenSaturationSeverity,
                airQualitySeverity: airQualitySeverity,
                pollenSeverity: pollenSeverity,
                humiditySeverity: humiditySeverity,
                cloudCoverSeverity: cloudCoverSeverity,
                temperatureSeverity: temperatureSeverity,
                triggerGrades: triggerGrades
            )
            
            print("Asthma Threat: \(Int(weightedSeverity * 100))%")
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
    
    private func calculateWeightedSeverity(
        heartRateSeverity: Double,
        respiratoryRateSeverity: Double,
        oxygenSaturationSeverity: Double,
        airQualitySeverity: Double,
        pollenSeverity: Double,
        humiditySeverity: Double,
        cloudCoverSeverity: Double,
        temperatureSeverity: Double,
        triggerGrades: [Int]
    ) -> Double {
        let totalGrade = Double(triggerGrades.reduce(0, +))
        
        let weightedSeverity = (
            (heartRateSeverity * Double(triggerGrades[0])) +
            (respiratoryRateSeverity * Double(triggerGrades[1])) +
            (oxygenSaturationSeverity * Double(triggerGrades[2])) +
            (airQualitySeverity * Double(triggerGrades[3])) +
            (pollenSeverity * Double(triggerGrades[4])) +
            (humiditySeverity * Double(triggerGrades[5])) +
            (cloudCoverSeverity * Double(triggerGrades[6])) +
            (temperatureSeverity * Double(triggerGrades[7]))
        ) / totalGrade
        
        return weightedSeverity
    }
}
