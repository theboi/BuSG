//
//  BusService+CoreDataClass.swift
//  Navigem
//
//  Created by Ryan The on 4/12/20.
//
//

import UIKit
import CoreData

@objc(BusService)
public class BusService: NSManagedObject {
    
    public var busStops: [BusStop] {
        func fetchImmediately() -> [BusStop] {
            let context = self.managedObjectContext!
            let routeReq: NSFetchRequest<BusRoute> = BusRoute.fetchRequest()
            routeReq.predicate = NSPredicate(format: "serviceNo == %@", serviceNo)
            do {
                let busRoutes = try context.fetch(routeReq)
                return busRoutes.map({ (busRoute) -> BusStop in
                    let stopReq: NSFetchRequest<BusStop> = BusStop.fetchRequest()
                    stopReq.predicate = NSPredicate(format: "busStopCode == %@", busRoute.busStopCode)
                    do {
                        let busStop = try context.fetch(stopReq).first!
                        busRoute.busService = self
                        busRoute.busStop = busStop
                        return busStop
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                })
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        if let busRoutes = busRoutes, busRoutes.count > 0 {
            var busStops: [BusStop] = []
            for busRoute in (busRoutes.allObjects as! [BusRoute]) {
                if let busStop = busRoute.busStop {
                    busStops.append(busStop)
                } else { return fetchImmediately() }
            }
            return busStops
        } else { return fetchImmediately() }
    }
    
}
