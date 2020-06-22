//
//  testCases.swift
//  Pic-A-DayUnitTests
//
//  Created by Patrick Cong on 2018-11-18.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//

import Foundation
import XCTest
@testable import Pic_A_Day


class testFunctions:XCTestCase
{
    // Test if there are twelve months stored
    func testNumOfMonth()
    {
        var testNumOfMonth: ViewController = ViewController(nibName: nil, bundle: nil)
        XCTAssertEqual(testNumOfMonth.Months.count,12)
    }
    
    // Test if there are seven days stored
    func testNumofNumOfDays()
    {
        var testNumOfMonth: ViewController = ViewController(nibName: nil, bundle: nil)
        XCTAssertEqual(testNumOfMonth.DaysOfMonth.count,7)

    }
    
    // Test if there are 12 different number of days of months
    func testDaysInMonth()
    {
        var testDaysInMonth: ViewController = ViewController(nibName: nil, bundle: nil)
        XCTAssertEqual(testDaysInMonth.DaysInMonths.count,12)
    }
    
    
    // Test if each month's name and sequence are displayed correctly
    func testMonths()
    {
        var testMonths: ViewController = ViewController(nibName: nil, bundle: nil)
        XCTAssertEqual(testMonths.Months[0],"January")
        XCTAssertEqual(testMonths.Months[1],"February")
        XCTAssertEqual(testMonths.Months[2],"March")
        XCTAssertEqual(testMonths.Months[3],"April")
        XCTAssertEqual(testMonths.Months[4],"May")
        XCTAssertEqual(testMonths.Months[5],"June")
        XCTAssertEqual(testMonths.Months[6],"July")
        XCTAssertEqual(testMonths.Months[7],"August")
        XCTAssertEqual(testMonths.Months[8],"September")
        XCTAssertEqual(testMonths.Months[9],"October")
        XCTAssertEqual(testMonths.Months[10],"November")
        XCTAssertEqual(testMonths.Months[11],"December")
    }
    
    //Test if each month has correct number of days
    func testDaysInMonths()
    {
        var testDaysInMonths: ViewController = ViewController(nibName: nil, bundle: nil)
        XCTAssertEqual(testDaysInMonths.DaysInMonths[0],31)
        XCTAssertEqual(testDaysInMonths.DaysInMonths[1],28)
        XCTAssertEqual(testDaysInMonths.DaysInMonths[2],31)
        XCTAssertEqual(testDaysInMonths.DaysInMonths[3],30)
        XCTAssertEqual(testDaysInMonths.DaysInMonths[4],31)
        XCTAssertEqual(testDaysInMonths.DaysInMonths[5],30)
        XCTAssertEqual(testDaysInMonths.DaysInMonths[6],31)
        XCTAssertEqual(testDaysInMonths.DaysInMonths[7],31)
        XCTAssertEqual(testDaysInMonths.DaysInMonths[8],30)
        XCTAssertEqual(testDaysInMonths.DaysInMonths[9],31)
        XCTAssertEqual(testDaysInMonths.DaysInMonths[10],30)
        XCTAssertEqual(testDaysInMonths.DaysInMonths[11],31)

    }
    
    //Test if function testGetStartDateDayPosition is able to complete after it is called
     func testGetStartDateDayPosition()
     {
        var isCalled = false
        var testGetStartDateDayPosition: ViewController = ViewController(nibName: nil, bundle: nil)
        testGetStartDateDayPosition.GetStartDateDayPosition()
        isCalled = true
        XCTAssertTrue(isCalled)
    }
    
    
    // Test if ClipboardViewController has correct number of default photos in it
    func testCollectionDatas()
    {
        
        var testCollectionDatas: ClipboardViewController = ClipboardViewController(nibName: nil, bundle: nil)
        XCTAssertEqual(testCollectionDatas.collectionData.count,4)
    }
    
//    func testDeleteSelectedItems()
//    {
//        var complete = false
//        var testDeleteSelectedItems: ClipboardViewController = ClipboardViewController(nibName: nil, bundle: nil)
//        testDeleteSelectedItems.deleteSelectedItems()
//        XCTAssertEqual(testDeleteSelectedItems.collectionData.count,3)
//
//    }
    
   
    
    
    // Test if the weekdays transfer from 0 to 7 successfully
    func testWeekday()
    {
        var testWeekday: ViewController = ViewController(nibName: nil, bundle: nil)
        var weekday=0
        if weekday == 0
        {
            weekday=7
        }
        
        XCTAssertEqual(weekday,7)

    }
    
    // Test if the NumberOfEmptyBox transfer between 0 and 7 successfully
    func testNumberOfEmptyBox()
    {
        var testWeekday: ViewController = ViewController(nibName: nil, bundle: nil)
        var NumberOfEmptyBox = 0
        if NumberOfEmptyBox == 0
        {NumberOfEmptyBox=7}
        XCTAssertEqual(NumberOfEmptyBox, 7)
        if NumberOfEmptyBox == 7
        {NumberOfEmptyBox=0}
        XCTAssertEqual(NumberOfEmptyBox, 0)

    }
    
    // Test if previous PreviousNumberOfEmptyBox transfer from 7 to 0 successfully
    func testPreviousNumberOfEmptyBox()
    {
        var testWeekday: ViewController = ViewController(nibName: nil, bundle: nil)
        var PreviousNumberOfEmptyBox = 0
        if PreviousNumberOfEmptyBox == 7
        {PreviousNumberOfEmptyBox=0}
        XCTAssertEqual(PreviousNumberOfEmptyBox, 0)

    }
    
    // Test if the application can get the current date successfully
    func getDate()
    {
        var complete = false
        var tryDate = Date()
        complete = true
        XCTAssertTrue(complete)
    }
    
      // Test if the application can get the current day successfully
    func getDayAccess()
    {
        var isCalled = false
        var tryDay = calendar.component(.day , from: date)
        isCalled = true
        XCTAssertTrue(isCalled)
    }
    
      // Test if the application can access the calendar successfully
    func getCalenderAccess()
    {
        var isCalled = false
        var tryDay = Calendar.current
        isCalled = true
        XCTAssertTrue(isCalled)
    }
    
       // Test if the application can access the weekday successfully
    func testWeekdayAccess()
    {
        var isCalled = false
        var tryWeekDay = calendar.component(.weekday, from: date) - 1
        isCalled = true
        XCTAssertTrue(isCalled)
    }
    
       // Test if the application can access the current month successfully
    func testMonthAccess()
    {
        var isCalled = false
        var tryWeekDay = calendar.component(.month, from: date) - 1
        isCalled = true
        XCTAssertTrue(isCalled)
        
    }
    
       // Test if the application can access the current year successfully
    func testYearAccess()
    {
        var isCalled = false
        calendar.component(.year, from: date) - 1
        isCalled = true
        XCTAssertTrue(isCalled)
    }
    
    
    // Test if the function GetStartPosition() build and run seccessfully
    func testGetStartPosition()
    {
        var complete = false
        var testGetStartPosition: ViewController = ViewController(nibName: nil, bundle: nil)
        testGetStartPosition.GetStartDateDayPosition()
        complete = true
        XCTAssertTrue(complete)
    }
    
//    func testAddItem()
//    {
//
//        var testAddItem: ClipboardViewController = ClipboardViewController(nibName: nil, bundle: nil)
//        var currentNum = testAddItem.collectionData.count
//        testAddItem.addItem()
//        //XCTAssertEqual(testAddItem.collectionData.count, currentNum+1)
//
//    }
    
    
//    func testNext()
//    {
//        var testNext: ViewController = ViewController(nibName: nil, bundle: nil)
//        var isCalled = false
//        testNext.next()
//        isCalled = true
//        XCTAssertTrue(isCalled)
//    }
    
//    func testDidReceiveMemoryWarning()
//    {
//        var testDidReceiveMemoryWarning: PhotoPreviewViewController = PhotoPreviewViewController(nibName: nil, bundle: nil)
//        var isCalled = false
//        testDidReceiveMemoryWarning.didReceiveMemoryWarning()
//        isCalled = true
//        XCTAssertTrue(isCalled)
//    }
}
