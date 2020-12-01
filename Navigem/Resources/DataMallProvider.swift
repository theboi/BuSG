//
//  DataMallProvider.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import Foundation

class DataMallProvider {
    
    static private func handleClientError(_ error: Error) {
        
    }
    
    static private func handleServerError(_ response: URLResponse) {
        
    }
    
    static func getBusArrivals(for busStop: String, completionBlock: @escaping ([String]) -> Void) throws {
        var request = URLRequest(url: URL(string: K.apiUrl.busArrival, with: [
            URLQueryItem(name: "BusStopCode", value: busStop)
        ])!)
        guard let apiKey = ProcessInfo.processInfo.environment[K.datamallEnvVar] else {
            throw ApiKeyError.missing
        }
        request.setValue(apiKey, forHTTPHeaderField: "AccountKey")
        let task = URLSession.shared.dataTask(with: request) { (data, res, err) in
            if let err = err {
                self.handleClientError(err)
                return
            }

            guard let httpResponse = res as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self.handleServerError(res!)
                return
            }
            
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
               let data = data,
               let string = String(data: data, encoding: .utf8) {
                print(string)
            }
            
            let decoder = JSONDecoder()
            
            guard let data = data else {return}
            
            completionBlock([])
        }
        task.resume()
    }
}
