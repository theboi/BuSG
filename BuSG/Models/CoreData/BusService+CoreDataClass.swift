//
//  BusService+CoreDataClass.swift
//   BuSG
//
//  Created by Ryan The on 4/12/20.
//
//

import UIKit
import CoreData

@objc(BusService)
public class BusService: NSManagedObject {
    
    public var accessorBusRoute: BusRoute?
    
    public var busStops: [BusStop] {
        if let busRoutes = busRoutes {
            var busStops: [BusStop] = []
            for busRoute in (busRoutes.allObjects as! [BusRoute]) {
                if busRoute.direction != accessorBusRoute?.direction ?? 1 { continue }
                if let busStop = busRoute.busStop {
//                    busStop.accessorBusRoute = busRoute
                    busStops.append(busStop)
                }
            }
            return busStops.sorted {
                return $0.accessorBusRoute!.stopSequence < $1.accessorBusRoute!.stopSequence
            }
        }
        return []
    }
    
    public var originBusStop: BusStop? {
        ApiProvider.shared.getBusStop(with: originCode)
    }
    
    public var destinationBusStop: BusStop? {
        ApiProvider.shared.getBusStop(with: destinationCode)
    }
    
}
