//
//  DataMallProvider.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import UIKit

class Provider {
    
    static let shared = Provider()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var apiKey: String {
        guard let apiKey = ProcessInfo.processInfo.environment[K.datamallEnvVar] else {
            assertionFailure("DataMall API Key missing. Get a key at https://www.mytransport.sg/content/mytransport/home/dataMall.html")
            return "ERROR"
        }
        return apiKey
    }
    
    public func updateBusData() {
        
    }
    
    public func getBusArrivals(for busStop: String, completionBlock: @escaping ([String]) -> Void) throws {
        var request = URLRequest(url: URL(string: K.apiUrl.busArrival, with: [
            URLQueryItem(name: "BusStopCode", value: busStop)
        ])!)
        request.setValue(apiKey, forHTTPHeaderField: K.datamallApiKeyHeaderKey)
        let task = URLSession.shared.dataTask(with: request) { (data, res, err) in
            self.handleApiError(res: res, err: err)
            
            let decoder = JSONDecoder()
            
            guard let data = data else {return}
            
            completionBlock([])
        }
        task.resume()
    }
    
    private func handleApiError(res: URLResponse?, err: Error?) {
        if let err = err {
            // TODO: HANDLE CLIENT ERROR (TRY AGAIN)
            return
        }
        
        guard let httpResponse = res as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
            // TODO: HANDLE SERVER ERROR (TRY AGAIN)
            return
        }
        
        let mimeType = httpResponse.mimeType
        assert(mimeType == "application/json")
    }
}
