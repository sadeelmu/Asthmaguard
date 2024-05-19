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
                    
                    let severity = self.calculateAsthmaSeverity(
                        biosignalSamples: biosignalSamples,
                        environmentalData: (airQualityData, pollenForecastData),
                        weatherData: weatherData
                    )
                    print("Asthma Threat: \(Int(severity * 100))%")
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
    
    private func calculateAsthmaSeverity(biosignalSamples: [HKQuantitySample], environmentalData: (EnviromentalData.AirQualityData?, EnviromentalData.PollenForecastData?), weatherData: WeatherKitData.WeatherData) -> Double {
        let heartRateSeverity = HealthDataAnalyzer.calculateHeartRateSeverity(samples: biosignalSamples)
        let respiratoryRateSeverity = HealthDataAnalyzer.calculateRespiratoryRateSeverity(samples: biosignalSamples)
        let oxygenSaturationSeverity = HealthDataAnalyzer.calculateOxygenSaturationSeverity(samples: biosignalSamples)
        
        var airQualitySeverity = 0.0
        if let airQualityData = environmentalData.0 {
            airQualitySeverity = calculateAQISeverity(universalAQI: airQualityData.universalAQI)
        }
        
        let pollenSeverity = calculatePollenSeverity(pollenForecastData: environmentalData.1)
        let weatherSeverity = weatherKitData.calculateOverallWeatherSeverity(weatherData: weatherData)
        
        let overallSeverity = heartRateSeverity + respiratoryRateSeverity + oxygenSaturationSeverity + airQualitySeverity + pollenSeverity + weatherSeverity
        return overallSeverity
    }
    
    private func calculateAQISeverity(universalAQI: Int?) -> Double {
        guard let universalAQI = universalAQI else {
            return 0.0
        }
        
        if universalAQI >= 101 {
            return 1.0
        } else if universalAQI >= 51 {
            return 0.5
        } else {
            return 0.0
        }
    }
    
    private func calculatePollenSeverity(pollenForecastData: EnviromentalData.PollenForecastData?) -> Double {
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
}
