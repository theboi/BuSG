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
    
    private let backgroundContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    
    private var apiKey: String {
        guard let apiKey = ProcessInfo.processInfo.environment[K.datamallEnvVar] else {
            assertionFailure("DataMall API Key missing. Get a key at https://www.mytransport.sg/content/mytransport/home/dataMall.html")
            return "ERROR"
        }
        return apiKey
    }
    
    /// Fetch bus data in Service nested structures with skip until DataMall API returns empty array (aka no more entries)
    private func fetchData<T: BusApiServiceRoot>(_ T_Type: T.Type, withPrevious array: [T.Value] = [], withSkip skip: Int = 0, completion: CompletionHandler<[T.Value]>) {
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
                fatalError("Failure to decode JSON into Objects: \(error)")
            }
        }.resume()
    }
    
    /// Update bus data from DataMall servers. Runs asynchronous.
    public func updateBusData(completion: CompletionHandler<Void> = nil) {
        
        self.fetchData(BusStopServiceRoot.self) { (busStopServiceValues: [BusStopServiceValue]) in
            
            for service in busStopServiceValues {
                var data: BusStop
                let req: NSFetchRequest<BusStop> = BusStop.fetchRequest()
                req.predicate = NSPredicate(format: "busStopCode == %@", service.busStopCode)
                
                do {
                    let result = try self.backgroundContext.fetch(req)
                    // Update if already present, else Create
                    if result.count > 0 {
                        data = result[0]
                    } else {
                        data = BusStop(context: self.backgroundContext)
                    }
                    data.busStopCode = service.busStopCode
                    data.roadName = service.roadName ?? "NULL"
                    data.roadDesc = service.roadDesc ?? "NULL"
                    data.latitude = service.latitude ?? 0
                    data.longitude = service.longitude ?? 0
                } catch {
                    fatalError("Failure to fetch context: \(error)")
                }
            }
            
            // TODO: ADD ENUMS FOR RAW CONVERSION
            do {
                try self.backgroundContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            // Fetch BusServices from API
            self.fetchData(BusServiceServiceRoot.self) { (busServiceServiceValues: [BusServiceServiceValue]) in
                
                for service in busServiceServiceValues {
                    var data: BusService
                    let req: NSFetchRequest<BusService> = BusService.fetchRequest()
                    req.predicate = NSPredicate(format: "serviceNo == %@", service.serviceNo)
                    
                    do {
                        let result = try self.backgroundContext.fetch(req)
                        if result.count > 0 {
                            data = result[0]
                        } else {
                            data = BusService(context: self.backgroundContext)
                        }
                        data.serviceNo = service.serviceNo
                        data.rawServiceOperator = service.serviceOperator?.rawValue ?? "NULL"
                        data.direction = Int64(truncatingIfNeeded: service.direction ?? 0)
                        data.rawCategory = service.category?.rawValue ?? "NULL"
                        data.originCode = service.originCode ?? "NULL"
                        data.destinationCode = service.destinationCode ?? "NULL"
                        data.amPeakFreq = service.amPeakFreq ?? "NULL"
                        data.amOffpeakFreq = service.amOffpeakFreq ?? "NULL"
                        data.pmPeakFreq = service.pmPeakFreq ?? "NULL"
                        data.pmOffpeakFreq = service.pmOffpeakFreq ?? "NULL"
                        data.loopDesc = service.loopDesc ?? "NULL"
                    } catch {
                        fatalError("Failure to fetch context: \(error)")
                    }
                }
                
                do {
                    try self.backgroundContext.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
                
                // Fetch BusRoutes from API
                self.fetchData(BusRouteServiceRoot.self) { (busServiceServiceValues: [BusRouteServiceValue]) in
                    for service in busServiceServiceValues {
                        var data: BusRoute

                        let req = BusRoute.fetchRequest() as NSFetchRequest<BusRoute>
                        req.predicate = NSPredicate(format: "serviceNo == %@ && busStopCode == %@", service.serviceNo, service.busStopCode)

                        do {
                            let result = try self.backgroundContext.fetch(req)
                            if result.count > 0 {
                                data = result[0]
                            } else {
                                data = BusRoute(context: self.backgroundContext)
                            }
                            data.serviceNo = service.serviceNo
                            data.rawServiceOperator = service.serviceOperator?.rawValue ?? "NULL"
                            data.direction = Int64(truncatingIfNeeded: service.direction ?? 0)
                            data.stopSequence = Int64(truncatingIfNeeded: service.stopSequence ?? 0)
                            data.busStopCode = service.busStopCode
                            data.distance = service.distance ?? 0
                            data.wdFirstBus = service.wdFirstBus ?? "NULL"
                            data.wdLastBus = service.wdLastBus ?? "NULL"
                            data.satFirstBus = service.satFirstBus ?? "NULL"
                            data.satLastBus = service.satLastBus ?? "NULL"
                            data.sunFirstBus = service.sunFirstBus ?? "NULL"
                            data.sunLastBus = service.sunLastBus ?? "NULL"

                            // If busStop or busService are invalid (such as CTE for bus 670), ignore that entry and remove it
                        } catch {
                            fatalError("Failure to fetch context: \(error)")
                        }
                    }
                    do {
                        try self.backgroundContext.save()
                        print("Done Updating Bus Data")
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                    completion?(())
                } // BusRoutes
            } // BusServices
        } // BusStops
    }
    
    public func getBusStop(for busStopCode: String, completion: CompletionHandler<BusStop?> = nil) {
        do {
            let req = BusStop.fetchRequest() as NSFetchRequest<BusStop>
            req.predicate = NSPredicate(format: "busStopCode == %@", busStopCode)
            let busStop = try context.fetch(req).first
            if let busStop = busStop {
                completion?(busStop)
            } else {
                completion?(nil)
            }
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
    }
    
    public func getBusService(for serviceNo: String, completion: CompletionHandler<BusService?> = nil) {
        do {
            let req = BusService.fetchRequest() as NSFetchRequest<BusService>
            req.predicate = NSPredicate(format: "serviceNo == %@", serviceNo)
            let out = try context.fetch(req)
            print(out.count)
            let busStop: BusService? = out[0]
            if let busStop = busStop {
                completion?(busStop)
            } else {
                completion?(nil)
            }
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
    }
    
    public func getNearbyBusStops(completion: CompletionHandler<[BusStop]> = nil) {
        do {
            let req = BusStop.fetchRequest() as NSFetchRequest<BusStop>
            
            let cur = LocationProvider.shared.currentLocation.coordinate
            let rad = K.nearbyCoordRadius

            let predicate = NSPredicate(format: "latitude <= %@ && latitude >= %@ && longitude <= %@ && longitude >= %@", argumentArray: [cur.latitude+rad, cur.latitude-rad, cur.longitude+rad, cur.longitude-rad])
            req.predicate = predicate
            
            completion?(try context.fetch(req))
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
    }
    
    public func getBusArrivals(for busStop: String, completion: CompletionHandler<[String]> = nil) {
        
    }
    
    private func handleApiError(res: URLResponse?, err: Error?) {
        if let err = err {
            fatalError(err.localizedDescription)
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
