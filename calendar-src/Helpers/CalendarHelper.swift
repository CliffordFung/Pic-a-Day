//
//  CalendarHelper.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-22.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//

import UIKit
struct myDay{
    let dayOfWeek:String
    let day:Int
    let month:String
    let year:Int
    init(_dayOfWeek:String,_day:Int,_month:String,_year:Int) {
        dayOfWeek=_dayOfWeek; day=_day; month=_month; year=_year
    }
}

func firstDayOfTheMonth(indexFromCurrentMonth:Int) -> Int{
    
    let calendar = Calendar.current
    let day = Calendar.current.date(byAdding: .month, value: indexFromCurrentMonth, to: Date())!
    // for "last month" just use -1, for "next month" just use 1, etc
    let cal = calendar.dateComponents([.year, .month], from: day)
    let FDOM = calendar.date(from: cal)!
    // 1=Sunday, 2=Monday, etc
    let theDay = calendar.component(.weekday, from: FDOM)
    return theDay
}

func numberOfDaysOfTheMonth(indexFromCurrentMonth:Int) ->Int {
    let cal = Calendar.current
    let day = Calendar.current.date(byAdding: .month, value: indexFromCurrentMonth, to: Date())!
    let r = cal.range(of: .day, in: .month, for: day)!
    let kDays = r.count
    return kDays
}

func convertToDayOfWeek(dayAsNum:Int) -> String {
    switch dayAsNum {
    case 1:
        return "Sunday"
    case 2:
        return "Monday"
    case 3:
        return "Tuesday"
    case 4:
        return "Wednesday"
    case 5:
        return "Thursday"
    case 6:
        return "Friday"
    case 7:
        return "Saturday"
    default:
        break
    }
    return ""
}

func convertToIntMonth(month: String) -> Int {
    switch month {
    case "January":
        return 1
    case "February":
        return 2
    case "March":
        return 3
    case "April":
        return 4
    case "May":
        return 5
    case "June":
        return 6
    case "July":
        return 7
    case "August":
        return 8
    case "September":
        return 9
    case "October":
        return 10
    case "November":
        return 11
    case "December":
        return 12
        
    default:
        break
    }
    return 0
}

func stringMonth(indexFromCurrentMonth:Int) -> String {
    //let now = Date()
    let now = Calendar.current.date(byAdding: .month, value: indexFromCurrentMonth, to: Date())
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "LLLL"
    let nameOfMonth = dateFormatter.string(from: now!)
    return nameOfMonth
}

func stringYear(indexFromCurrentMonth:Int) -> String {
    //let now = Date()
    let currentMonth = stringMonth(indexFromCurrentMonth: 0)
    let monthAsInt = convertToIntMonth(month: currentMonth)
    // logic for offset
    var offset:Int!
    if indexFromCurrentMonth+monthAsInt<0 {
        offset = -(1 + abs(indexFromCurrentMonth+monthAsInt)/12)
    }
    else{
        offset = (indexFromCurrentMonth+monthAsInt-1)/12
    }
    let now = Calendar.current.date(byAdding: .year, value: offset, to: Date())
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY"
    let year = dateFormatter.string(from: now!)
    return year
}

//
func getAllDaysOfTheMonth(indexFromCurrentMonth: Int) -> [myDay] {
    var daysOfMonth = [myDay]()
    var dayOfMonth = firstDayOfTheMonth(indexFromCurrentMonth: indexFromCurrentMonth)-1
    let year = stringYear(indexFromCurrentMonth: indexFromCurrentMonth)
    let month = stringMonth(indexFromCurrentMonth: indexFromCurrentMonth)
    let numberOfDays = numberOfDaysOfTheMonth(indexFromCurrentMonth: indexFromCurrentMonth)
    for i in 1..<numberOfDays+1{
        let stringDayOfMonth = convertToDayOfWeek(dayAsNum: dayOfMonth+1)
        let day = myDay(_dayOfWeek: stringDayOfMonth, _day: i, _month: month, _year: Int(year)!)
        dayOfMonth = (dayOfMonth+1)%7
        daysOfMonth.append(day)
    }
    return daysOfMonth
}
func convertToIntDay(_dayOfWeek:String) -> Int{
    switch _dayOfWeek {
    case "Sunday":
        return 1
    case "Monday":
        return 2
    case "Tuesday":
        return 3
    case "Wednesday":
        return 4
    case "Thursday":
        return 5
    case "Friday":
        return 6
    case "Saturday":
        return 7
    default:
        break
    }
    return 0
}

func populateWithPrevMonthDays(monthDays: [myDay], indexFromCurrentMonth:Int) -> [myDay]{
    let previousMonthLastDay = numberOfDaysOfTheMonth(indexFromCurrentMonth: indexFromCurrentMonth-1)
    var tempMonthDays = [myDay]()
    let firstDay = monthDays[0].dayOfWeek
    let firstDayInt = convertToIntDay(_dayOfWeek:firstDay)
    let yearDate = Calendar.current.date(byAdding: .month, value: indexFromCurrentMonth-1, to: Date())!
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY"
    let year = formatter.string(from: yearDate)
    for i in 1..<firstDayInt{
        let day = myDay(_dayOfWeek: convertToDayOfWeek(dayAsNum: i), _day: previousMonthLastDay-(firstDayInt-i-1), _month: stringMonth(indexFromCurrentMonth: indexFromCurrentMonth-1), _year: Int(year)!)
        tempMonthDays.append(day)
    }
    tempMonthDays.append(contentsOf: monthDays)
    return tempMonthDays
}





func theDays(days:[Date]) -> [myDay]{
    var daysToBeReturned = [myDay]()
    let formatter = DateFormatter()
    formatter.dateFormat = "eeee-dd-MMMM-yyyy"
    for date in days {
        let stringDay = formatter.string(from: date)
        let splitDay = stringDay.components(separatedBy: "-")
        let aDay = myDay(_dayOfWeek: splitDay[0], _day: Int(splitDay[1])!, _month: splitDay[2], _year: Int(splitDay[3])!)
        daysToBeReturned.append(aDay)
    }
    return daysToBeReturned
}

func getAllDaysOfTheWeek(indexFromCurrentWeek:Int) -> [myDay] {
    let day = Calendar.current.date(byAdding: .day, value: 7*indexFromCurrentWeek, to: Date())!
    let calendar = Calendar.current
    let dayOfWeek = calendar.component(.weekday, from: day)
    let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: day)!
    let days = (weekdays.lowerBound ..< weekdays.upperBound)
        .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: day) }
    return theDays(days: days)
}
// MARK:- Function used for uploading to server

func convertTimeToString(datePicker:UIDatePicker) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .medium
    return formatter.string(from: datePicker.date)
}

func convertAlertToString(datePicker:UIDatePicker) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .medium
    return formatter.string(from: datePicker.date)
}


// MARK:- Converting Date obj to a struct of two ints and an string


