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
    
    public func presentDayCalendarEvents() -> [EKEvent] {
        let calendar = Calendar.current
        
        var todayComponents = DateComponents()
        todayComponents.day = 1
        if let today = calendar.date(byAdding: todayComponents, to: Date(), wrappingComponents: false) {
            let predicate = store.predicateForEvents(withStart: today, end: today, calendars: nil)
            let events = store.events(matching: predicate)
            return events
        }
        return []
    }
    
}
