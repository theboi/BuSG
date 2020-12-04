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
        let context = self.managedObjectContext!
        let routeReq: NSFetchRequest<BusRoute> = BusRoute.fetchRequest()
        routeReq.predicate = NSPredicate(format: "serviceNo == %@", serviceNo)
        do {
            let busRoutes = try context.fetch(routeReq)
            return busRoutes.map({ (busRoute) -> BusStop in
                let stopReq: NSFetchRequest<BusStop> = BusStop.fetchRequest()
                stopReq.predicate = NSPredicate(format: "busStopCode == %@", busRoute.busStopCode)
                do {
                    return try context.fetch(stopReq).first!
                } catch {
                    fatalError(error.localizedDescription)
                }
            })
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}
