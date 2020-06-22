//
//  Month.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-21.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//

import UIKit

class Day{
    let weekDay:String!
    let day:Int
    var events = [Event]()
    
    init(_weekDay:String, _day:Int) {
        weekDay=_weekDay; day=_day;
    }
   func addEvent(event:Event) {
        events.append(event)
    }
   func removeEvent(event:Event){
        let hasEvent = events.contains{$0 == event}
        if  hasEvent {
            let index = events.firstIndex {$0 == event}
            if let _index = index {
                events.remove(at: _index)
            }
        }
    }
    
    func toggleEventNotifications() {
        for event in events {
            event.hasNotification = !event.hasNotification
        }
    }
    
    static func == (day0:Day, day1:Day) -> Bool{
        if(day0.day == day1.day){
            return true
        }
        return false
    }
}

class Month{
    var days = [Day]()
    var month:String!
    var year:Int
    
    // MARK:- Initializer
    
    init(_days:Day, _month:String, _year:Int) {
        days.append(_days); month = _month; year = _year;
    }
    
    init(_month:String, _year:Int) {
        month = _month; year = _year;
    }
    
    // MARK:- Methods
    
    func addADay(_day:Day){
        days.append(_day)
    }
    
    func removeEventOnDay(_day:Int, _event:Event) -> Bool{
        let dayIndex = days.firstIndex{$0.day == _day}
        if let _dayIndex = dayIndex {
            days[_dayIndex].removeEvent(event: _event)
            
            // MARK:- Memory vs Speed here 
            
            if days[_dayIndex].events.count == 0 {
                days.remove(at: _dayIndex)
                print("Removed the day obj, since there are no more events on day")
            }
            return true
        }
        return false
    }
    
    func addEventOnDay(_day:Int, _event:Event) -> Bool {
        let dayIndex = days.firstIndex{$0.day == _day}
        if let _dayIndex = dayIndex {
            days[_dayIndex].addEvent(event: _event)
            return true
        }
        return false
    }
    
    static func == (month0:Month, month1:Month) -> Bool {
        if(month0.month == month1.month &&
            month1.year == month0.year){
            return true
        }
        return false
    }
    
    func getEventsFor(_day:Int) -> [Event]{
        let indexDay = days.firstIndex{$0 == Day(_weekDay: "", _day: _day)}
        if let index = indexDay{
            return days[index].events
        }
        print("no events")
        return []
    }
    
    func toggleEventNotifications() {
        for day in days {
            day.toggleEventNotifications()
        }
    }
}

class MonthsCollection {
    var months = [Month]()
    
    // MARK:- Methods
    
    func remove(_day:Int, _month:String, _year:Int) {
        
    }
    
    func addEvent(_weekDay:String, _day:Int, _month:String, _year:Int, _event:Event) {
        
        let indexMonth = months.firstIndex{$0 == Month(_month: _month, _year: _year)}
        if let index = indexMonth {
            let day = Day(_weekDay: _weekDay, _day: _day)
            day.addEvent(event: _event)
            if months[index].addEventOnDay(_day: _day, _event: _event){
                    
                // FOR DEBUGGING -- If app crashes something may have happened here
                
                print("day exists. successfully added event.")
                print("\(months.last!.days.last!.events.last!.title)  \(months.last!.days.last!.day) \(months.last!.month!) \(months.last!.year)")
                print("Current num of months: \(months.count)")

            }else{
                months[index].addADay(_day: day)
                    
                // FOR DEBUGGING -- If app crashes something may have happened here
                    
                print("day does not exist. successfully added event.")
                print("\(months.last!.days.last!.events.last!.title)  \(months.last!.days.last!.day) \(months.last!.month!) \(months.last!.year)")
                print("Current num of months: \(months.count)")

            }
        }
        else{
            let day = Day(_weekDay: _weekDay, _day: _day)
            day.addEvent(event: _event)
            let month = Month(_days: day, _month: _month, _year: _year)
            months.append(month)
            
            // FOR DEBUGGING -- If app crashes something may have happened here
            
            print("Created a new day for \(months.last!.month!). And created a new event")
            print("\(months.last!.days.last!.events.last!.title)  \(months.last!.days.last!.day) \(months.last!.month!) \(months.last!.year)")
            print("Current num of months: \(months.count)")
        }
    }
    
    func removeEventOn(_weekDay:String, _day:Int, _month:String, _year:Int, _event:Event) {
        // can someone do this...
        let indexMonth = months.firstIndex{$0 == Month(_month: _month, _year: _year)}
        if let index = indexMonth {
            if months[index].removeEventOnDay(_day: _day, _event: _event){
                print("Successfully removed an event")
            }
        }
    }
    
    func sortByYear() {
        months.sort{$0.year < $1.year}
    }
    
    func eventsFor(_day:Int, _month:String, _year:Int) -> [Event] {
        let indexMonth = months.firstIndex{$0 == Month(_month: _month, _year: _year)}
        if let index = indexMonth {
            return months[index].getEventsFor(_day: _day)
        }
        return []
    }
    
    func toggleAllEventNotifications() {
        // code
        for month in months {
            month.toggleEventNotifications()
        }
    }
}
