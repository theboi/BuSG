//
//  DataMallProvider.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import Foundation

class DataMallProvider {
    static func getBusStop() throws {
        var request = URLRequest(url: URL(string: K.apiUrl.busArrival, with: [
            URLQueryItem(name: "BusStopCode", value: "10079")
        ])!)
        guard let apiKey = ProcessInfo.processInfo.environment[K.datamallEnvVar] else {
            throw ApiKeyError.missing
        }
        request.setValue("AccountKey", forHTTPHeaderField: apiKey)
        print(request.allHTTPHeaderFields)
        let task = URLSession.shared.dataTask(with: request) { (data, res, err) in
            if let err = err {
                //self.handleClientError(error)
                print("client error")
                return
            }

            guard let httpResponse = res as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                //self.handleServerError(response)
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
               let data = data,
               let string = String(data: data, encoding: .utf8) {
                print(string)
            }
            
            guard let data = data else {return}
            print(data)
        }
        task.resume()
    }
}
