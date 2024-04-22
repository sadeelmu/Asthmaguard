//
//  APIManager.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 23/04/2024.
//

import Foundation

// Define struct for Air Quality Request
struct AirQualityRequest: Codable {
    let location: Location

    struct Location: Codable {
        let latitude: Double
        let longitude: Double
    }
}

// Function to make HTTP POST request
func makeAirQualityRequest() {
    let requestBody = AirQualityRequest(location: AirQualityRequest.Location(latitude: 32.023090, longitude: 35.875825))

    guard let jsonData = try? JSONEncoder().encode(requestBody) else {
        print("Error encoding request")
        return
    }

    let urlString = "https://pollen.googleapis.com/v1/forecast:lookup?key=AIzaSyBsEgk_PWNwRVmGAA_ihIF1JmBtJskuur8&location.longitude=35.32&location.latitude=32.32&days=1"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData

    let session = URLSession.shared

    let task = session.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            print("No response")
            return
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            print("HTTP status code \(httpResponse.statusCode)")
            return
        }

        guard let responseData = data else {
            print("No data received")
            return
        }

        do {
            let json = try JSONSerialization.jsonObject(with: responseData, options: [])
            print(json)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }

    task.resume()
}

// Function to make HTTP GET request
func makePollenRequest() {
    let urlString = "https://airquality.googleapis.com/v1/currentConditions:lookup?key=AIzaSyBsEgk_PWNwRVmGAA_ihIF1JmBtJskuur8"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }

    let session = URLSession.shared

    let task = session.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            print("No response")
            return
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            print("HTTP status code \(httpResponse.statusCode)")
            return
        }

        guard let responseData = data else {
            print("No data received")
            return
        }

        do {
            let json = try JSONSerialization.jsonObject(with: responseData, options: [])
            print(json)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }

    task.resume()
}

