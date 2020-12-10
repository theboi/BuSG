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
            fatalError("DataMall API Key missing. Get a key at https://www.mytransport.sg/content/mytransport/home/dataMall.html")
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
        var busRoutesDictForBusStops = [String : [BusRoute]]()
        var busRoutesDictForBusServices = [String : [BusRoute]]()

        /// Fetch BusRoutes from API
        self.fetchStaticData(BusRouteMapperRoot.self) { (busServiceMapperValues: [BusRouteMapperValue]) in
            self.backgroundContext.performAndWait {
                do {
                    var busRoutesDict = [String : BusRoute]()
                    try self.backgroundContext.fetch(BusRoute.fetchRequest()).forEach({ (busRoute: BusRoute) in
                        busRoutesDict["\(busRoute.serviceNo),\(busRoute.direction),\(busRoute.busStopCode)"] = busRoute
                    })
                    for mapper in busServiceMapperValues {
                        var data: BusRoute
                        if let result = busRoutesDict["\(mapper.serviceNo),\(mapper.direction!),\(mapper.busStopCode)"] {
                            data = result
                        } else {
                            data = BusRoute(context: self.backgroundContext)
                        }
                        data.serviceNo = mapper.serviceNo
                        data.rawServiceOperator = mapper.serviceOperator?.rawValue ?? K.nilStr
                        data.direction = Int64(truncatingIfNeeded: mapper.direction ?? 0)
                        data.stopSequence = Int64(truncatingIfNeeded: mapper.stopSequence ?? 0)
                        data.busStopCode = mapper.busStopCode
                        data.distance = mapper.distance ?? 0
                        data.wdFirstBus = mapper.wdFirstBus ?? K.nilStr
                        data.wdLastBus = mapper.wdLastBus ?? K.nilStr
                        data.satFirstBus = mapper.satFirstBus ?? K.nilStr
                        data.satLastBus = mapper.satLastBus ?? K.nilStr
                        data.sunFirstBus = mapper.sunFirstBus ?? K.nilStr
                        data.sunLastBus = mapper.sunLastBus ?? K.nilStr
                    }
                    try self.backgroundContext.save()

                    try self.backgroundContext.fetch(BusRoute.fetchRequest()).forEach({ (busRoute: BusRoute) in
                        busRoutesDictForBusStops[busRoute.busStopCode, default: []].append(busRoute)
                        busRoutesDictForBusServices[busRoute.serviceNo, default: []].append(busRoute)
                    })
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
            self.fetchStaticData(BusStopMapperRoot.self) { (busStopMapperValues: [BusStopMapperValue]) in
                self.backgroundContext.performAndWait {
                    do {
                        var busStopDict = [String : BusStop]()

                        try self.backgroundContext.fetch(BusStop.fetchRequest()).forEach({ (busStop: BusStop) in
                            busStopDict[busStop.busStopCode] = busStop
                        })
                        for mapper in busStopMapperValues {
                            var data: BusStop
                            if let result = busStopDict[mapper.busStopCode] {
                                data = result
                            } else {
                                data = BusStop(context: self.backgroundContext)
                            }
                            data.busStopCode = mapper.busStopCode
                            data.roadName = mapper.roadName ?? K.nilStr
                            data.roadDesc = mapper.roadDesc ?? K.nilStr
                            data.latitude = mapper.latitude ?? 0
                            data.longitude = mapper.longitude ?? 0
                            data.busRoutes = NSSet(array: busRoutesDictForBusStops[mapper.busStopCode] ?? [])
                        }
                        try self.backgroundContext.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
                // TODO: ADD ENUMS FOR RAW CONVERSION
                
                // Fetch BusServices from API
                self.fetchStaticData(BusServiceMapperRoot.self) { (busServiceMapperValues: [BusServiceMapperValue]) in
                    self.backgroundContext.performAndWait {
                        do {
                            var busServiceDict = [String : BusService]()

                            try self.backgroundContext.fetch(BusService.fetchRequest()).forEach({ (busService: BusService) in
                                busServiceDict["\(busService.serviceNo),\(busService.direction)"] = busService
                            })
                            for mapper in busServiceMapperValues {
                                var data: BusService
                                if let result = busServiceDict["\(mapper.serviceNo),\(mapper.direction)"] {
                                    data = result
                                } else {
                                    data = BusService(context: self.backgroundContext)
                                }
                                data.serviceNo = mapper.serviceNo
                                data.rawServiceOperator = mapper.serviceOperator?.rawValue ?? K.nilStr
                                data.direction = Int64(truncatingIfNeeded: mapper.direction)
                                data.rawCategory = mapper.category?.rawValue ?? K.nilStr
                                data.originCode = mapper.originCode ?? K.nilStr
                                data.destinationCode = mapper.destinationCode ?? K.nilStr
                                data.amPeakFreq = mapper.amPeakFreq ?? K.nilStr
                                data.amOffpeakFreq = mapper.amOffpeakFreq ?? K.nilStr
                                data.pmPeakFreq = mapper.pmPeakFreq ?? K.nilStr
                                data.pmOffpeakFreq = mapper.pmOffpeakFreq ?? K.nilStr
                                data.loopDesc = mapper.loopDesc ?? K.nilStr
                                data.busRoutes = NSSet(array: busRoutesDictForBusServices[mapper.serviceNo] ?? [])
                            }
                            try self.backgroundContext.save()
                            print("DONE FETCH")
                            completion?(())
                        } catch {
                            fatalError("Failure to save context: \(error)")
                        }
                    }
                } // BusServices
            } // BusStops
        } // BusRoutes
    }
    
    public func getBusStop(with busStopCode: String) -> BusStop? {
        do {
            let req = BusStop.fetchRequest() as NSFetchRequest<BusStop>
            req.predicate = NSPredicate(format: "busStopCode == %@", busStopCode)
            return try context.fetch(req).first
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
    }
    
    public func getBusService(with serviceNo: String) -> BusService? {
        do {
            let req = BusService.fetchRequest() as NSFetchRequest<BusService>
            req.predicate = NSPredicate(format: "serviceNo == %@", serviceNo)
            return try context.fetch(req).first
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
    }
    
    public func getBusStops(nearby coordinate: CLLocationCoordinate2D) -> [BusStop] {
        do {
            let req = BusStop.fetchRequest() as NSFetchRequest<BusStop>
            
            let rad = K.nearbyCoordRadius
            
            let predicate = NSPredicate(format: "latitude <= %@ && latitude >= %@ && longitude <= %@ && longitude >= %@", argumentArray: [coordinate.latitude+rad, coordinate.latitude-rad, coordinate.longitude+rad, coordinate.longitude-rad])
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
    
    public func getSuggestedServices() -> [BusService] {
        let events = EventProvider.shared.presentDayCalendarEvents()
        events.forEach { (event) in
            event.structuredLocation?.geoLocation?.coordinate
        }
        self.getBusStop(with: "10079")?.busServices ?? []
        return []
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
