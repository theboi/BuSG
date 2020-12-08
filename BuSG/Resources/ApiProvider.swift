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
        self.fetchStaticData(BusStopMapperRoot.self) { (busStopMapperValues: [BusStopMapperValue]) in
            self.backgroundContext.performAndWait {
                do {
                    try self.backgroundContext.execute(NSBatchDeleteRequest(fetchRequest: BusStop.fetchRequest()))
                    try self.backgroundContext.execute(NSBatchInsertRequest(entity: BusStop.entity(), objects: busStopMapperValues.map({ (service) -> [String : Any] in
                        [
                            "busStopCode": service.busStopCode,
                            "roadName": service.roadName ?? K.nilStr,
                            "roadDesc": service.roadDesc ?? K.nilStr,
                            "latitude": service.latitude ?? 0,
                            "longitude": service.longitude ?? 0,
                        ]
                    })))
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
            // TODO: ADD ENUMS FOR RAW CONVERSION
            
            // Fetch BusServices from API
            self.fetchStaticData(BusServiceMapperRoot.self) { (busServiceMapperValues: [BusServiceMapperValue]) in
                self.backgroundContext.performAndWait {
                    do {
                        try self.backgroundContext.execute(NSBatchDeleteRequest(fetchRequest: BusService.fetchRequest()))
                        try self.backgroundContext.execute(NSBatchInsertRequest(entity: BusService.entity(), objects: busServiceMapperValues.map({ (service) -> [String : Any] in
                            [
                                "serviceNo": service.serviceNo,
                                "rawServiceOperator": service.serviceOperator?.rawValue ?? K.nilStr,
                                "direction": Int64(truncatingIfNeeded: service.direction ?? 0),
                                "rawCategory": service.category?.rawValue ?? K.nilStr,
                                "originCode": service.originCode ?? K.nilStr,
                                "destinationCode": service.destinationCode ?? K.nilStr,
                                "amPeakFreq": service.amPeakFreq ?? K.nilStr,
                                "amOffpeakFreq": service.amOffpeakFreq ?? K.nilStr,
                                "pmPeakFreq": service.pmPeakFreq ?? K.nilStr,
                                "pmOffpeakFreq": service.pmOffpeakFreq ?? K.nilStr,
                                "loopDesc": service.loopDesc ?? K.nilStr,
                            ]
                        })))
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
                
                // Fetch BusRoutes from API
                self.fetchStaticData(BusRouteMapperRoot.self) { (busServiceMapperValues: [BusRouteMapperValue]) in
                    self.backgroundContext.performAndWait {
                        do {
                            try self.backgroundContext.execute(NSBatchDeleteRequest(fetchRequest: BusRoute.fetchRequest()))
                            try self.backgroundContext.execute(NSBatchInsertRequest(entity: BusRoute.entity(), objects: busServiceMapperValues.map({ (service) -> [String : Any] in
                                [
                                    "serviceNo": service.serviceNo,
                                    "rawServiceOperator": service.serviceOperator?.rawValue ?? K.nilStr,
                                    "direction": Int64(truncatingIfNeeded: service.direction ?? 0),
                                    "stopSequence": Int64(truncatingIfNeeded: service.stopSequence ?? 0),
                                    "busStopCode": service.busStopCode,
                                    "distance": service.distance ?? 0,
                                    "wdFirstBus": service.wdFirstBus ?? K.nilStr,
                                    "wdLastBus": service.wdLastBus ?? K.nilStr,
                                    "satFirstBus": service.satFirstBus ?? K.nilStr,
                                    "satLastBus": service.satLastBus ?? K.nilStr,
                                    "sunFirstBus": service.sunFirstBus ?? K.nilStr,
                                    "sunLastBus": service.sunLastBus ?? K.nilStr,
                                ]
                            })))
                            print("Done Updating Bus Data")
                            completion?(())
                        } catch {
                            fatalError("Failure to save context: \(error)")
                        }
                    }
                } // BusRoutes
            } // BusServices
        } // BusStops
    }
    
    public func mapStaticData() {
        print("MAPP")
        DispatchQueue(label: "com.ryanthe.background").async {
            do {
                let req: NSFetchRequest<BusRoute> = BusRoute.fetchRequest()
                
                for busRoute in try self.backgroundContext.fetch(req) {
                    
                    if let _ = busRoute.busService, let _ = busRoute.busStop { continue }
                    
                    let busStopReq = BusStop.fetchRequest() as NSFetchRequest<BusStop>
                    busStopReq.predicate = NSPredicate(format: "busStopCode == %@", argumentArray: [busRoute.busStopCode])
                    let busStop = try self.backgroundContext.fetch(busStopReq).first
                    
                    let busServiceReq = BusService.fetchRequest() as NSFetchRequest<BusService>
                    busServiceReq.predicate = NSPredicate(format: "serviceNo == %@", argumentArray: [busRoute.serviceNo])
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
                print("DONE MAPP")
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    public func getBusStop(for busStopCode: String) -> BusStop? {
        do {
            let req = BusStop.fetchRequest() as NSFetchRequest<BusStop>
            req.predicate = NSPredicate(format: "busStopCode == %@", busStopCode)
            return try context.fetch(req).first
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
    }
    
    public func getBusService(for serviceNo: String) -> BusService? {
        do {
            let req = BusService.fetchRequest() as NSFetchRequest<BusService>
            req.predicate = NSPredicate(format: "serviceNo == %@", serviceNo)
            return try context.fetch(req).first
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
    }
    
    public func getNearbyBusStops() -> [BusStop] {
        do {
            let req = BusStop.fetchRequest() as NSFetchRequest<BusStop>
            
            let cur = LocationProvider.shared.currentLocation.coordinate
            let rad = K.nearbyCoordRadius
            
            let predicate = NSPredicate(format: "latitude <= %@ && latitude >= %@ && longitude <= %@ && longitude >= %@", argumentArray: [cur.latitude+rad, cur.latitude-rad, cur.longitude+rad, cur.longitude-rad])
            req.predicate = predicate
            return try context.fetch(req).sorted(by: { (prevBusStop, nextBusStop) -> Bool in
                let prevBusStopDistance = CLLocation.distance(CLLocation(latitude: prevBusStop.latitude, longitude: prevBusStop.longitude))(from: LocationProvider.shared.currentLocation)
                let nextBusStopDistance = CLLocation.distance(CLLocation(latitude: nextBusStop.latitude, longitude: nextBusStop.longitude))(from: LocationProvider.shared.currentLocation)
                return prevBusStopDistance < nextBusStopDistance
            })
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
    }
    
    public func getSuggestedServices() -> [BusService] {
        self.getBusStop(for: "10079")?.busServices ?? []
    }
    
    public func getBusArrivals(for busStopCode: String, completion: CompletionHandler<BusArrival> = nil) {
        var req = URLRequest(url: URL(string: K.apiUrls.busArrivals, with: [
            URLQueryItem(name: K.apiQueries.busStopCode, value: busStopCode)
        ])!)
        req.setValue(apiKey, forHTTPHeaderField: K.apiQueries.apiKeyHeader)
        URLSession.shared.dataTask(with: req) { (data, res, err) in
            self.handleApiError(res: res, err: err)
            do {
                let busArrivalMapperRoot = try JSONDecoder().decode(BusArrival.self, from: data!)
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
