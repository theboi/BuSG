//
//  DataMallProvider.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import Foundation

class DataMallProvider {
    static func getBusStop() throws {
        throw ApiKeyError.missing
        let url = URL(string: "\(K.apiUrl)/BusArrivalv2")!
        var request = URLRequest(url: url)
        guard let apiKey = ProcessInfo.processInfo.environment[K.datamallEnvVar] else {
            
        }
        request.setValue("AccountKey", forHTTPHeaderField: apiKey)
        let task = URLSession.shared.dataTask(with: request) { (data, res, err) in
            guard let data = data else {return}
            print(data)
        }
        task.resume()
    }
}
