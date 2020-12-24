//
//  DataMallProvider.swift
//   BuSG
//
//  Created by Ryan The on 28/11/20.
//

import UIKit
import CoreData
import EventKit

typealias CompletionHandler<T> = ((T) -> Void)?

class ApiProvider {
    
    static let shared = ApiProvider()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let backgroundContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    
    private var apiKey: String {
        Credentials.dataMallApiKey
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
        print("START FETCH")
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
                        data.rawServiceOperator = mapper.serviceOperator!.rawValue
                        data.direction = Int64(truncatingIfNeeded: mapper.direction!)
                        data.stopSequence = Int64(truncatingIfNeeded: mapper.stopSequence!)
                        data.busStopCode = mapper.busStopCode
                        data.distance = mapper.distance ?? 0 /// When API returns null, distance = 0
                        data.rawWdFirstBus = mapper.wdFirstBus!
                        data.rawWdLastBus = mapper.wdLastBus!
                        data.rawSatFirstBus = mapper.satFirstBus!
                        data.rawSatLastBus = mapper.satLastBus!
                        data.rawSunFirstBus = mapper.sunFirstBus!
                        data.rawSunLastBus = mapper.sunLastBus!
                    }
                    try self.backgroundContext.save()
                    
                    try self.backgroundContext.fetch(BusRoute.fetchRequest()).forEach({ (busRoute: BusRoute) in
                        busRoutesDictForBusStops[busRoute.busStopCode, default: []].append(busRoute)
                        busRoutesDictForBusServices["\(busRoute.serviceNo),\(busRoute.direction)", default: []].append(busRoute)
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
                            data.rawRoadName = mapper.roadName!
                            data.rawRoadDesc = mapper.roadDesc!
                            data.latitude = mapper.latitude!
                            data.longitude = mapper.longitude!
                            data.busRoutes = NSSet(array: busRoutesDictForBusStops[mapper.busStopCode]!)
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
                                data.rawServiceOperator = mapper.serviceOperator!.rawValue
                                data.direction = Int64(truncatingIfNeeded: mapper.direction)
                                data.rawCategory = mapper.category!.rawValue
                                data.originCode = mapper.originCode!
                                data.destinationCode = mapper.destinationCode!
                                data.rawAmPeakFreq = mapper.amPeakFreq!
                                data.rawAmOffpeakFreq = mapper.amOffpeakFreq!
                                data.rawPmPeakFreq = mapper.pmPeakFreq!
                                data.rawPmOffpeakFreq = mapper.pmOffpeakFreq!
                                data.rawLoopDesc = mapper.loopDesc!
                                data.busRoutes = NSSet(array: busRoutesDictForBusServices["\(mapper.serviceNo),\(mapper.direction)"] ?? []) /// For some reason data on 36B does not exist
                            }
                            try self.backgroundContext.save()
                            print("DONE FETCH")
                            UserDefaults.standard.setValue(Date().timeIntervalSince1970, forKey: K.userDefaults.lastUpdatedEpoch)
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
    
    public func getBusService(with serviceNo: String, in direction: Int64) -> BusService? {
        do {
            let req = BusService.fetchRequest() as NSFetchRequest<BusService>
            req.predicate = NSPredicate(format: "serviceNo == %@ && direction == %@", argumentArray: [serviceNo, direction])
            return try context.fetch(req).first
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
    }
    
    public func getBusServices(containing searchString: String, completion: CompletionHandler<[BusService]> = nil) {
        DispatchQueue(label: K.backgroundThreadLabel).async {
            do {
                let req = BusService.fetchRequest() as NSFetchRequest<BusService>
                req.predicate = NSPredicate(format: "serviceNo CONTAINS[cd] %@", argumentArray: [searchString])
                completion?(try self.context.fetch(req).sorted {
                    $0.serviceNo.localizedStandardCompare($1.serviceNo) == .orderedAscending
                })
            } catch {
                fatalError("Failure to fetch context: \(error)")
            }
        }
    }
    
    public func getBusStops(nearby coordinate: CLLocationCoordinate2D) -> [BusStop] {
        do {
            let req = BusStop.fetchRequest() as NSFetchRequest<BusStop>
            
            let rad = K.nearbyCoordRadius
            
            let predicate = NSPredicate(format: "latitude <= %@ && latitude >= %@ && longitude <= %@ && longitude >= %@", argumentArray: [coordinate.latitude+rad, coordinate.latitude-rad, coordinate.longitude+rad, coordinate.longitude-rad])
            req.predicate = predicate
            return try context.fetch(req).sorted(by: {
                LocationProvider.shared.distanceFromCurrentLocation(to: CLLocation(coordinate: $0.coordinate)) < LocationProvider.shared.distanceFromCurrentLocation(to: CLLocation(coordinate: $1.coordinate))
            })
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
    }
    
    public func getBusStops(containing searchString: String, completion: CompletionHandler<[BusStop]> = nil) {
        DispatchQueue(label: K.backgroundThreadLabel).async {
            do {
                let req = BusStop.fetchRequest() as NSFetchRequest<BusStop>
                req.predicate = NSPredicate(format: "rawRoadDesc CONTAINS[cd] %@ || rawRoadName CONTAINS[cd] %@ || busStopCode CONTAINS[cd] %@", argumentArray: [searchString, searchString, searchString])
                completion?(try self.context.fetch(req).sorted {
                    $0.roadDesc.localizedStandardCompare($1.roadDesc) == .orderedAscending
                })
            } catch {
                fatalError("Failure to fetch context: \(error)")
            }
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
                if let data = data {
                    let busArrivalMapperRoot = try JSONDecoder().decode(BusArrival.self, from: data)
                    completion?(busArrivalMapperRoot)
                }
            } catch {
                fatalError("Failure to decode JSON into Objects: \(error)")
            }
        }.resume()
    }
    
    public func getSuggestedServices(completion: CompletionHandler<[BusSuggestion]> = nil) {
        
        let events = EventProvider.shared.presentDayCalendarEvents()
        let nearbyBusStops = events.compactMap { (event) -> ([BusStop], EKEvent)? in
            /// If location not stated, event is ignored
            if let coordinate = event.structuredLocation?.geoLocation?.coordinate {
                return (ApiProvider.shared.getBusStops(nearby: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)), event)
            }
            return nil
        }
        let commonBusSuggestions = nearbyBusStops.flatMap { (busStops: [BusStop], event: EKEvent) -> [BusSuggestion] in
            let destinationBusServices = busStops.flatMap { (busStop: BusStop) -> [(BusStop, BusService, EKEvent)] in
                return busStop.busServices.map { (busStop, $0, event) }
            }.uniqued { (busStop, busService, event) -> String in
                busService.serviceNo
            }
            let originBusServices = ApiProvider.shared.getBusStops(nearby: (LocationProvider.shared.currentLocation ?? K.defaultLocation).coordinate).flatMap { (busStop: BusStop) -> [(BusStop, BusService)] in
                return busStop.busServices.map { (busStop, $0) }
            }.uniqued { $1.serviceNo }
            
            let destinationBusServicesDict = destinationBusServices.reduce([String: (BusStop, BusService, EKEvent)]()) { (dict, data) -> [String: (BusStop, BusService, EKEvent)] in
                var dict = dict
                dict[data.1.serviceNo] = data
                return dict
            }
            
            let common = originBusServices.compactMap { (originBusStop, originBusService) -> BusSuggestion? in
                if let (destinationBusStop, _, event) = destinationBusServicesDict[originBusService.serviceNo] {
                    return BusSuggestion(busService: originBusService, originBusStop: originBusStop, destinationBusStop: destinationBusStop, event: event)
                }
                return nil
            }
            return common
        }
        completion?(commonBusSuggestions)
    }
    
    private func handleApiError(res: URLResponse?, err: Error?) {
        if let err = err {
            if let urlError = err as? URLError {
                var message: String
                var imageName: String
                switch urlError {
                case URLError.notConnectedToInternet, URLError.networkConnectionLost:
                    message = "No Internet Connection"
                    imageName = "wifi.exclamationmark"
                default:
                    message = "Unknown Error Occured"
                    imageName = "exclamationmark.circle"
                }
                DispatchQueue.main.async {
                    (UIApplication.shared.delegate as! AppDelegate).window?.present(Toast(message: message, image: UIImage(systemName: imageName), style: .danger))
                }
                return
            }
            DispatchQueue.main.async {
                (UIApplication.shared.delegate as! AppDelegate).window?.present(Toast(message: "Unknown Error Occured", image: UIImage(systemName: "exclamationmark.circle"), style: .danger))
            }
        }
        
        if let httpResponse = res as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            DispatchQueue.main.async {
                (UIApplication.shared.delegate as! AppDelegate).window?.present(Toast(message: "Server Error", image: UIImage(systemName: "server.rack"), style: .danger))
            }
        }
    }
}
