//
//  EventProvider.swift
//  BuSG
//
//  Created by Ryan The on 8/12/20.
//

import EventKit

class EventProvider {
    
    static let shared = EventProvider()
    
    lazy var store: EKEventStore = {
        let store = EKEventStore()
        store.requestAccess(to: .reminder) { granted, error in
            
        }
        return store
    }()
    
}
