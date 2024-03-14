//
//  APIHelper.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 11/03/2024.
//

import Foundation

func getMinuteForecast(city: String, apiKey: String, completion: @escaping (Result<Data, Error>) -> Void) {
    let urlString = "http://dataservice.accuweather.com/forecasts/v1/minute/1day?apikey=\(apiKey)&q=\(city)"
    
    if let url = URL(string: urlString) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                if let data = data {
                    completion(.success(data))
                } else {
                    let error = NSError(domain: "InvalidData", code: 0, userInfo: nil)
                    completion(.failure(error))
                }
            } else {
                let error = NSError(domain: "HTTPError", code: 0, userInfo: nil)
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
