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
    private func fetchStaticData<T: BusApiMapperRoot>(_ T_Type: T.Type, withPrevious array: [T.Value] = [], withSkip skip: Int = 0, completion: CompletionHandler<[T.Value]>) {
        var array = array
        var req = URLRequest(url: URL(string: T.apiUrl, with: [URLQueryItem(name: K.apiQueries.skip, value: String(skip))])!)
        req.setValue(apiKey, forHTTPHeaderField: K.apiQueries.apiKeyHeader)
        URLSession.shared.dataTask(with: req) { (data, res, err) in
            self.handleApiError(res: res, err: err)
            let decoder = JSONDecoder()
            do {
                let busStopMapperRoot = try decoder.decode(T.self, from: data!)
                array.append(contentsOf: busStopMapperRoot.value)
                if !busStopMapperRoot.value.isEmpty {
                    self.fetchStaticData(T_Type, withPrevious: array, withSkip: skip + 500, completion: completion)
                    return
                }
                completion?(array)
            } catch {
                fatalError("Failure to decode JSON into Objects: \(error)")
            }
        }.resume()
    }
    
    /// Update static bus data from DataMall servers such as available Bus Services, Bus Stops and Bus Routes. Runs asynchronous.
    public func updateStaticData(completion: CompletionHandler<Void> = nil) {
        
        self.fetchStaticData(BusStopMapperRoot.self) { (busStopServiceValues: [BusStopMapperValue]) in
            
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
                    data.roadName = service.roadName ?? K.nilStr
                    data.roadDesc = service.roadDesc ?? K.nilStr
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
            self.fetchStaticData(BusServiceMapperRoot.self) { (busServiceServiceValues: [BusServiceMapperValue]) in
                
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
                        data.rawServiceOperator = service.serviceOperator?.rawValue ?? K.nilStr
                        data.direction = Int64(truncatingIfNeeded: service.direction ?? 0)
                        data.rawCategory = service.category?.rawValue ?? K.nilStr
                        data.originCode = service.originCode ?? K.nilStr
                        data.destinationCode = service.destinationCode ?? K.nilStr
                        data.amPeakFreq = service.amPeakFreq ?? K.nilStr
                        data.amOffpeakFreq = service.amOffpeakFreq ?? K.nilStr
                        data.pmPeakFreq = service.pmPeakFreq ?? K.nilStr
                        data.pmOffpeakFreq = service.pmOffpeakFreq ?? K.nilStr
                        data.loopDesc = service.loopDesc ?? K.nilStr
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
                self.fetchStaticData(BusRouteMapperRoot.self) { (busServiceServiceValues: [BusRouteMapperValue]) in
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
                            data.rawServiceOperator = service.serviceOperator?.rawValue ?? K.nilStr
                            data.direction = Int64(truncatingIfNeeded: service.direction ?? 0)
                            data.stopSequence = Int64(truncatingIfNeeded: service.stopSequence ?? 0)
                            data.busStopCode = service.busStopCode
                            data.distance = service.distance ?? 0
                            data.wdFirstBus = service.wdFirstBus ?? K.nilStr
                            data.wdLastBus = service.wdLastBus ?? K.nilStr
                            data.satFirstBus = service.satFirstBus ?? K.nilStr
                            data.satLastBus = service.satLastBus ?? K.nilStr
                            data.sunFirstBus = service.sunFirstBus ?? K.nilStr
                            data.sunLastBus = service.sunLastBus ?? K.nilStr
                            
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
    
    public func mapStaticData() {
        DispatchQueue(label: "com.ryanthe.background").async {
            do {
                let req: NSFetchRequest<BusRoute> = BusRoute.fetchRequest()
                
                for busRoute in try self.backgroundContext.fetch(req) {
                    
                    if let _ = busRoute.busService, let _ = busRoute.busStop { continue }

                    let busStopReq = BusStop.fetchRequest() as NSFetchRequest<BusStop>
                    busStopReq.predicate = NSPredicate(format: "busStopCode == %@", busRoute.busStopCode)
                    let busStop = try self.backgroundContext.fetch(busStopReq).first
                    
                    let busServiceReq = BusService.fetchRequest() as NSFetchRequest<BusService>
                    busServiceReq.predicate = NSPredicate(format: "serviceNo == %@", busRoute.serviceNo)
                    let busService = try self.backgroundContext.fetch(busServiceReq).first
                    
                    // If busStop or busService are invalid (such as CTE for bus 670), ignore that entry and remove it
                    if let busStop = busStop, let busService = busService {
                        busRoute.busStop = busStop
                        busRoute.busService = busService
                    } else {
                        self.backgroundContext.delete(busRoute)
                    }
                }
                try self.backgroundContext.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    public func getBusStop(for busStopCode: String) -> BusStop {
        do {
            let req = BusStop.fetchRequest() as NSFetchRequest<BusStop>
            req.predicate = NSPredicate(format: "busStopCode == %@", busStopCode)
            return try context.fetch(req).first!
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
    }
    
    public func getBusService(for serviceNo: String) -> BusService {
        do {
            let req = BusService.fetchRequest() as NSFetchRequest<BusService>
            req.predicate = NSPredicate(format: "serviceNo == %@", serviceNo)
            return try context.fetch(req).first!
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
    
    public func getBusArrivals(for busStopCode: String, completion: CompletionHandler<BusArrivalRoot> = nil) {
        var req = URLRequest(url: URL(string: K.apiUrls.busArrivals, with: [
            URLQueryItem(name: K.apiQueries.busStopCode, value: busStopCode)
        ])!)
        req.setValue(apiKey, forHTTPHeaderField: K.apiQueries.apiKeyHeader)
        URLSession.shared.dataTask(with: req) { (data, res, err) in
            self.handleApiError(res: res, err: err)
            do {
                let busArrivalMapperRoot = try JSONDecoder().decode(BusArrivalRoot.self, from: data!)
                completion?(busArrivalMapperRoot)
            } catch {
                fatalError("Failure to decode JSON into Objects: \(error)")
            }
        }.resume()
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
