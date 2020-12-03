//
//  DataMallProvider.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import UIKit
import CoreData

typealias CompletionHandler<T> = ((T) -> Void)?

class ApiProvider {
    
    static let shared = ApiProvider()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var apiKey: String {
        guard let apiKey = ProcessInfo.processInfo.environment[K.datamallEnvVar] else {
            assertionFailure("DataMall API Key missing. Get a key at https://www.mytransport.sg/content/mytransport/home/dataMall.html")
            return "ERROR"
        }
        return apiKey
    }
    
    /// Function to fetch bus data in Service nested structures
    private func fetchData<T: ApiServiceRoot>(_ T_Type: T.Type, withPrevious array: [T.T] = [], withSkip skip: Int = 0, completion: CompletionHandler<[T.T]>) {
        var array = array
        var req = URLRequest(url: URL(string: T.apiUrl, with: [URLQueryItem(name: K.apiQueries.skip, value: String(skip))])!)
        req.setValue(apiKey, forHTTPHeaderField: K.apiQueries.apiKeyHeader)
        URLSession.shared.dataTask(with: req) { (data, res, err) in
            self.handleApiError(res: res, err: err)
            let decoder = JSONDecoder()
            do {
                let busStopServiceRoot = try decoder.decode(T.self, from: data!)
                array.append(contentsOf: busStopServiceRoot.value)
                if !busStopServiceRoot.value.isEmpty {
                    self.fetchData(T_Type, withPrevious: array, withSkip: skip + 500, completion: completion)
                    return
                }
                completion?(array)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    public func updateBusData(completion: CompletionHandler<[BusServiceServiceValue]> = nil) {
        // Delete previous Core Data records
        do {
            try context.execute(NSBatchDeleteRequest(fetchRequest: BusService.fetchRequest()))
            try context.execute(NSBatchDeleteRequest(fetchRequest: BusStop.fetchRequest()))
        } catch {
            
        }
        // Get data from API and put into BusServiceService and BusStopService
        fetchData(BusServiceServiceRoot.self) { (busServiceServiceValues: [BusServiceServiceValue]) in
            // Transfer data into Core Data
            busServiceServiceValues.forEach { (service) in
                let data = BusService(context: self.context)
                data.serviceNo = service.serviceNo
                data.rawServiceOperator = service.serviceOperator.rawValue
                data.direction = Int64(truncatingIfNeeded: service.direction)
                data.rawCategory = service.category.rawValue
                data.originCode = service.originCode
                data.destinationCode = service.destinationCode
                data.amPeakFreq = service.amPeakFreq
                data.amOffpeakFreq = service.amOffpeakFreq
                data.pmPeakFreq = service.pmPeakFreq
                data.pmOffpeakFreq = service.pmOffpeakFreq
                data.loopDesc = service.loopDesc
            }
            
            do {
                try self.context.save()
            } catch {
                // TODO: CATCH
            }
        }
        
        fetchData(BusStopServiceRoot.self) { (busStopServiceValues: [BusStopServiceValue]) in
            // Transfer data into Core Data
            busStopServiceValues.forEach { (service) in
                let data = BusStop(context: self.context)
                data.busStopCode = service.busStopCode
                data.roadName = service.roadName
                data.roadDesc = service.roadDesc
                data.latitude = service.latitude
                data.longitude = service.longitude
            }
            
            // TODO: ADD ENUMS FOR RAW CONVERSION

            do {
                try self.context.save()
            } catch {
                // TODO: CATCH
            }
        }
    }
    
    public func getBusData(completion: CompletionHandler<[String]> = nil) {
        do {
            let busStops: [BusStop] = try context.fetch(BusStop.fetchRequest())
            let busServices: [BusService] = try context.fetch(BusService.fetchRequest())
            busServices.forEach { (busService) in
                print(busService.serviceNo)
            }
            //completion?(busStops)
        } catch {
            // TODO: CATCH
        }
        
        
    }
    
    public func getBusArrivals(for busStop: String, completion: CompletionHandler<[String]> = nil) {
        var req = URLRequest(url: URL(string: K.apiUrls.busArrival, with: [
            URLQueryItem(name: K.apiQueries.busStopCode, value: busStop)
        ])!)
        req.setValue(apiKey, forHTTPHeaderField: K.apiQueries.apiKeyHeader)
        URLSession.shared.dataTask(with: req) { (data, res, err) in
            self.handleApiError(res: res, err: err)
            
            let decoder = JSONDecoder()
            
            guard let data = data else {return}
            
            completion?([])
        }.resume()
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
