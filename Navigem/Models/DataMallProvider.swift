//
//  DataMallProvider.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import Foundation

class DataMallProvider {
    static func getBusStop() throws {
        var components = URLComponents(string: "\(K.apiUrl)/BusArrivalv2")!
        components.queryItems = [
            URLQueryItem(name: "BusStopCode", value: "10079")
        ]
        var request = URLRequest(url: components.url!)
        guard let apiKey = ProcessInfo.processInfo.environment[K.datamallEnvVar] else {
            throw ApiKeyError.missing
        }
        request.setValue("AccountKey", forHTTPHeaderField: apiKey)
        let task = URLSession.shared.dataTask(with: request) { (data, res, err) in
            guard let data = data else {return}
            print(data)
        }
        task.resume()
    }
}
