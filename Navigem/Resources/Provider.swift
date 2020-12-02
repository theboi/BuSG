//
//  DataMallProvider.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import UIKit

typealias CompletionHandler<T> = ((T) -> Void)?

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
    
    public func updateBusData(completion: CompletionHandler<[String]> = nil) {
        // Get data from API and put into BusServiceService and BusStopService
        let busServiceServices: BusStopServiceRoot?
        let busStopServices: BusStopServiceRoot?
        
        var req = URLRequest(url: URL(string: K.apiUrl.busStops, with: [])!)
        completion?([])
        
        // Transfer data into Core Data
        for busServiceService in busServiceServices {
            let busServiceData = BusService(context: context)
        }
    }
    
    public func getBusData(completion: CompletionHandler<[String]> = nil) {
        do {
            try context.fetch(BusStop.fetchRequest())
            try context.fetch(BusService.fetchRequest())
        } catch {
            // TODO: CATCH
        }
        
        completion?([])
    }
    
    public func getBusArrivals(for busStop: String, completion: CompletionHandler<[String]> = nil) {
        var req = URLRequest(url: URL(string: K.apiUrl.busArrival, with: [
            URLQueryItem(name: "BusStopCode", value: busStop)
        ])!)
        req.setValue(apiKey, forHTTPHeaderField: K.datamallApiKeyHeaderKey)
        let task = URLSession.shared.dataTask(with: req) { (data, res, err) in
            self.handleApiError(res: res, err: err)
            
            let decoder = JSONDecoder()
            
            guard let data = data else {return}
            
            completion?([])
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
