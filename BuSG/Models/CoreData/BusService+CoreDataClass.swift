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
    
    private var _busStops = [BusStop]()
    
    public var busStops: [BusStop] {
        get {
            if _busStops.count > 0 { return _busStops }
            if let busRoutes = busRoutes?.allObjects as? [BusRoute] {
                _busStops = busRoutes.filter {
                    return $0.direction == accessorBusRoute?.direction
                }.sorted {
                    return $0.stopSequence < $1.stopSequence
                }.compactMap {
                    return $0.busStop
                }
                
                print(_busStops.map({ (busStop) -> Int64 in
                    busStop.accessorBusRoute?.stopSequence ?? -100
                }))
                
            }
            return _busStops
        }
    }
    
    public var originBusStop: BusStop? {
        ApiProvider.shared.getBusStop(with: originCode)
    }
    
    public var destinationBusStop: BusStop? {
        ApiProvider.shared.getBusStop(with: destinationCode)
    }
    
}
