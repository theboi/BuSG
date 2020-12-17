//
//  BusStop+CoreDataClass.swift
// BuSG
//
//  Created by Ryan The on 4/12/20.
//
//

import Foundation
import CoreData

@objc(BusStop)
public class BusStop: NSManagedObject {
    
    public var accessorBusRoute: BusRoute?

    public var busServices: [BusService] {
        func fetch() -> [BusService] {
            let context = managedObjectContext!
            let routeReq: NSFetchRequest<BusRoute> = BusRoute.fetchRequest()
            routeReq.predicate = NSPredicate(format: "busStopCode == %@", busStopCode)
            do {
                let busRoutes = try context.fetch(routeReq)
                return try busRoutes.map({ (busRoute) -> BusService in
                    let stopReq: NSFetchRequest<BusService> = BusService.fetchRequest()
                    stopReq.predicate = NSPredicate(format: "serviceNo == %@", busRoute.serviceNo)
                    do {
                        let busService = try context.fetch(stopReq).first!
                        busService.accessorBusRoute = busRoute
                        busRoute.busStop = self
                        busRoute.busService = busService
                        try context.save()
                        return busService
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }).sorted {
                    $0.serviceNo.localizedStandardCompare($1.serviceNo) == .orderedAscending
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        if let busRoutes = busRoutes, busRoutes.count > 0 {
            var busServices: [BusService] = []
            for busRoute in (busRoutes.allObjects as! [BusRoute]) {
                if let busService = busRoute.busService {
                    busService.accessorBusRoute = busRoute
                    busServices.append(busService)
                } else { return fetch() }
            }
            return busServices.sorted {
                $0.serviceNo.localizedStandardCompare($1.serviceNo) == .orderedAscending
            }
        }
        return fetch()
    }
    
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var roadDesc: String {
        rawRoadDesc.capitalized
    }
    
    public var roadName: String {
        rawRoadName.capitalized
    }
}
