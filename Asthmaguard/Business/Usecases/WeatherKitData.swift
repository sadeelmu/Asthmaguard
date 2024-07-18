//
//  WeatherKitData.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 16/05/2024.
//

import WeatherKit
import CoreLocation

class WeatherKitData {
    
    struct WeatherData {
        let humidity: Double
        let cloudCover: Double
        let temperature: Double
    }
    
    // MARK: - fetchWeatherData
    /// Function to fetch weather data based on latitude and longitude
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (WeatherData?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        Task {
            do {
                // Fetch weather data using WeatherKit
                let weather = try await WeatherService.shared.weather(for: location)
                
                // Extract and convert relevant weather information
                let humidity = weather.currentWeather.humidity * 100 // Convert to percentage
                let cloudCover = weather.currentWeather.cloudCover // Keep as double
                let temperature = weather.currentWeather.temperature.converted(to: .celsius).value // Convert to Celsius
                
                // Create a WeatherData object with the fetched information
                let weatherData = WeatherData(humidity: humidity, cloudCover: cloudCover, temperature: temperature)
                
                // Call the completion handler with the fetched weather data
                completion(weatherData)
            } catch {
                // Print error and call the completion handler with nil
                print("Error fetching weather data: \(error)")
                completion(nil)
            }
        }
    }
    
    // MARK: - calculateHumiditySeverity
    /// Function to calculate severity based on humidity
    func calculateHumiditySeverity(humidity: Double) -> Double {
        if humidity >= 80 {
            return 1.0
        } else if humidity >= 70 {
            return 0.75
        } else if humidity >= 60 {
            return 0.5
        } else if humidity >= 50 {
            return 0.25
        } else {
            return 0.0
        }
    }
    
    // MARK: - calculateCloudCoverSeverity
    /// Function to calculate severity based on cloud cover
    func calculateCloudCoverSeverity(cloudCover: Double) -> Double {
        return cloudCover >= 0.8 ? 1.0 : 0.0
    }
    
    // MARK: - calculateTemperatureSeverity
    /// Function to calculate severity based on temperature
    func calculateTemperatureSeverity(temperature: Double) -> Double {
        if temperature <= -12 {
            return 1.0
        } else if temperature <= -5 {
            return 0.75
        } else if temperature <= 0 {
            return 0.5
        } else if temperature <= 10 {
            return 0.25
        } else {
            return 0.0
        }
    }
    
    // MARK: - calculateOverallWeatherSeverity
    /// Function to calculate overall weather severity based on multiple factors
    func calculateOverallWeatherSeverity(weatherData: WeatherData) -> Double {
        let humiditySeverity = calculateHumiditySeverity(humidity: weatherData.humidity)
        let cloudCoverSeverity = calculateCloudCoverSeverity(cloudCover: weatherData.cloudCover)
        let temperatureSeverity = calculateTemperatureSeverity(temperature: weatherData.temperature)
        
        // Sum of all severities to get overall severity
        return humiditySeverity + cloudCoverSeverity + temperatureSeverity
    }
}

