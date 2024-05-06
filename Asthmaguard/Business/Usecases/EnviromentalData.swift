//
//  EnviromentalDataUseCase.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 06/05/2024.
//

import Foundation
import CoreLocation

class EnviromentalData{
    struct AirQualityData {
        let dateTime: String
        let regionCode: String
        let universalAQI: Int?
    }
    
    struct CustomLocalAqi {
          let regionCode: String
          let aqi: String
      }

    struct PollenForecastData {
        let date: Date
        let pollenTypes: [PollenType]
    }

    struct PollenType {
        let code: String
        let indexInfo: IndexInfo
    }

    struct IndexInfo {
        let category: String
        let displayName: String
    }

    func fetchAirQuality(latitude: Double, longitude: Double, completion: @escaping (AirQualityData?) -> Void) {
        let requestBody = AirQualityRequest(location: AirQualityRequest.Location(latitude: latitude, longitude: longitude))

        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            print("Error encoding request")
            completion(nil)
            return
        }

        let urlString = "https://airquality.googleapis.com/v1/currentConditions:lookup?key=AIzaSyBsEgk_PWNwRVmGAA_ihIF1JmBtJskuur8"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
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
                completion(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("No response")
                completion(nil)
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP status code \(httpResponse.statusCode)")
                completion(nil)
                return
            }

            guard let responseData = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                if let airQualityData = try self.parseAirQualityResponse(responseData) {
                    completion(airQualityData)
                } else {
                    print("Failed to parse air quality data")
                    completion(nil)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }

        task.resume()
    }

    private func parseAirQualityResponse(_ data: Data) throws -> AirQualityData? {
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        guard let dateTime = json?["dateTime"] as? String,
              let regionCode = json?["regionCode"] as? String,
              let indexes = json?["indexes"] as? [[String: Any]],
              let index = indexes.first,
              let universalAQI = index["aqi"] as? Int
        else {
            print("Failed to parse air quality data")
            return nil
        }

        return AirQualityData(dateTime: dateTime, regionCode: regionCode, universalAQI: universalAQI)
    }


    func fetchPollenForecast(latitude: Double, longitude: Double, completion: @escaping (PollenForecastData?) -> Void){
        let urlString = "https://pollen.googleapis.com/v1/forecast:lookup?key=AIzaSyBsEgk_PWNwRVmGAA_ihIF1JmBtJskuur8&location.longitude=\(longitude)&location.latitude=\(latitude)&days=1&languageCode=en&plantsDescription=0"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("No data returned from API.")
                completion(nil)
                return
            }

            if let pollenForecastData = self.parsePollenForecastResponse(data) {
                completion(pollenForecastData)
            } else {
                completion(nil)
            }
        }

        task.resume()
    }

    func parsePollenForecastResponse(_ data: Data) -> PollenForecastData? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("Invalid JSON format.")
                return nil
            }

            guard let dailyInfoArray = json["dailyInfo"] as? [[String: Any]] else {
                print("Missing or invalid dailyInfo data in API response.")
                return nil
            }

            var pollenTypes: [PollenType] = []

            for dailyData in dailyInfoArray {
                if let pollenTypeInfoArray = dailyData["pollenTypeInfo"] as? [[String: Any]] {
                    for pollenTypeData in pollenTypeInfoArray {
                        if let code = pollenTypeData["code"] as? String,
                           let indexInfoDict = pollenTypeData["indexInfo"] as? [String: Any],
                           let indexInfo = parseIndexInfo(indexInfoDict)
                        {
                            let pollenType = PollenType(code: code, indexInfo: indexInfo)
                            pollenTypes.append(pollenType)
                        }
                    }
                }
            }

            guard let dateDict = dailyInfoArray.first?["date"] as? [String: Int],
                  let year = dateDict["year"],
                  let month = dateDict["month"],
                  let day = dateDict["day"]
            else {
                print("Missing or invalid date data in API response.")
                return nil
            }

            let dateComponents = DateComponents(year: year, month: month, day: day)
            guard let date = Calendar.current.date(from: dateComponents) else {
                print("Failed to create date object from components.")
                return nil
            }

            return PollenForecastData(date: date, pollenTypes: pollenTypes)
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
            return nil
        }
    }

    private func parseIndexInfo(_ indexInfoDict: [String: Any]) -> IndexInfo? {
        guard
            let category = indexInfoDict["category"] as? String,
            let displayName = indexInfoDict["displayName"] as? String
        else {
            print("Missing or invalid index info data.")
            return nil
        }

        return IndexInfo(category: category, displayName: displayName)
    }

}

