//
//  Event.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-21.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//

import UIKit

var globalID = -1

class Event {
    var image:UIImage
    var startTime:Date
    var endTime:Date
    var alert:Date
    var title:String
    var emotionBefore:Emoji?
    var emotionAfter:Emoji?
    var completed = false // always initially false
    var hasNotification: Bool!
    
    var beginEventAlertID = "begin-#"
    var atEventAlertID = "atEvent-#"
    init(_image:UIImage, _startTime:Date, _endTime:Date, _alert:Date, _title:String, _emotionBefore:Emoji?, _emotionAfter:Emoji?, _hasNotification:Bool){
        image = _image; startTime = _startTime; endTime = _endTime;
        alert = _alert; title = _title; emotionBefore = _emotionBefore;
        emotionAfter = _emotionAfter; hasNotification = _hasNotification
        updateIdentifiers()
    }
    static func == (event1:Event, event2:Event) -> Bool {
        if(event1.title == event2.title &&
            event1.startTime == event2.startTime &&
            event1.endTime == event2.endTime){
            return true
        }
        return false
    }
   func toggleComplete() {
        completed = !completed
    }
    private func updateIdentifiers() {
        globalID += 1
        beginEventAlertID += String(globalID)
        atEventAlertID += String(globalID)
    }
    func getAtEventID() -> String {
        return atEventAlertID
    }
    func getBeginEventID() -> String {
        return beginEventAlertID
    }
}
