//
//  WeatherKitData.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 16/05/2024.
//

import Foundation
import WeatherKit
import CoreLocation

//Need to get humidity, cloudcover and temperature  
//Severity: Asthma patients will be triggered if Humidity is above 50-60%, Cloudover is 1 (boolean value), and temperature if it's cold below 12

class WeatherKitData {
    
    struct WeatherData {
        let humidity: Double
        let cloudCover: Bool
        let temperature: Double
    }
    
    // MARK: - Fetch Weather Data
    
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (WeatherData?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        Task {
            do {
                let weather = try await WeatherService.shared.weather(for: location)
                
                let humidity = weather.currentWeather.humidity * 100 // Convert to percentage
                let cloudCover = weather.currentWeather.cloudCover > 0.5 // Assuming cloud cover is represented as a fraction
                let temperature = weather.currentWeather.temperature.value
                
                let weatherData = WeatherData(humidity: humidity, cloudCover: cloudCover, temperature: temperature)
                
                completion(weatherData)
            } catch {
                print("Error fetching weather data: \(error)")
                completion(nil)
            }
        }
    }
    
    // MARK: - Calculate Severity
    
    func calculateHumiditySeverity(humidity: Double) -> Double {
        if humidity > 60 {
            return 0.2
        } else if humidity > 50 {
            return 0.1
        } else {
            return 0.0
        }
    }
    
    func calculateCloudCoverSeverity(cloudCover: Bool) -> Double {
        return cloudCover ? 0.1 : 0.0
    }
    
    func calculateTemperatureSeverity(temperature: Double) -> Double {
        return temperature < 12 ? 0.2 : 0.0
    }
    
    func calculateOverallWeatherSeverity(weatherData: WeatherData) -> Double {
        let humiditySeverity = calculateHumiditySeverity(humidity: weatherData.humidity)
        let cloudCoverSeverity = calculateCloudCoverSeverity(cloudCover: weatherData.cloudCover)
        let temperatureSeverity = calculateTemperatureSeverity(temperature: weatherData.temperature)
        
        return humiditySeverity + cloudCoverSeverity + temperatureSeverity
    }
}
