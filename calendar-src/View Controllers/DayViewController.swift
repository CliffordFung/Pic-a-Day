//
//  DayViewController.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-23.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//  Problems: not chaning the time picker's default time -> chack didSelectCell -> if collecitonView ==  collectionView2

import UIKit

import UIKit

class DayViewController: UIViewController {

    var times = ["12:00 AM","12:30 AM", "01:00 AM", "01:30 AM", "2:00 AM", "2:30 AM", "03:00 AM", "03:30 AM","04:00 AM","4:30 AM","5:00 AM","5:30 AM","6:00 AM","6:30 AM", "7:00 AM", "7:30 AM", "8:00 AM","8:30 AM", "9:00 AM", "9:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "12:00 PM","12:30 PM", "1:00 PM", "1:30 PM", "2:00 PM", "2:30 PM", "3:00 PM", "3:30 PM","4:00 PM","4:30 PM","5:00 PM","5:30 PM","6:00 PM","6:30 PM", "7:00 PM", "7:30 PM", "8:00 PM","8:30 PM", "9:00 PM", "9:30 PM", "10:00 PM", "10:30 PM", "11:00 PM", "11:30 PM"]

    var titleText:String!
    // day data
    var weekDay:String!
    var day:Int!
    var month:String!
    var year:Int!
    // MARK:- Outlets
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var SelectedDate: UINavigationItem!
 
    
    @IBAction func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = titleText
        navigationController?.isNavigationBarHidden = false
        // load the data for the day here
        // would be ideal to cache the data here *
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView1.reloadData()
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "AlertPopupViewController", bundle: nil)
        if let navvc = storyBoard.instantiateInitialViewController() as? UINavigationController {
            if let popup = navvc.topViewController as? AlertPopupViewController {
                popup.day = day
                popup.weekDay = weekDay
                popup.month = month
                popup.year = year
                
                // animation
                open()
                self.navigationController?.pushViewController(popup, animated: false)
            }
        }
    }
    private func open(){
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
    
    private func open2() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromLeft
        navigationController?.view.layer.add(transition, forKey: kCATransition)
    }

    
}
extension DayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return AppDelegate.monthsCollection.eventsFor(_day: day, _month: month, _year: year).count
        }
        else {
            return times.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        if collectionView == collectionView1{
            let cell = collectionView1.dequeueReusableCell(withReuseIdentifier: "DayCollectionCell", for: indexPath) as! DayCell
            
            // NEEDS WORK HERE:- AppDelegate.monthsCollection.sortEventsFor()
            
            let events = AppDelegate.monthsCollection.eventsFor(_day: day, _month: month, _year: year)
            cell.imageView.image = events[indexPath.row].image
            cell.label.text = events[indexPath.row].title
            return cell
        }
        else {
            let cell = collectionView2.dequeueReusableCell(withReuseIdentifier: "TimestampCollectionCell", for: indexPath) as! TimestampCell
            cell.label.text = times[indexPath.row]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionView2{
            let storyBoard = UIStoryboard(name: "AlertPopupViewController", bundle: nil)
            if let navvc = storyBoard.instantiateInitialViewController() as? UINavigationController {
                if let popup = navvc.topViewController as? AlertPopupViewController {
                    
                    // NEEDS WORK HERE: - does not change the time as wanted

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat =  "h:mm a"
                    let date = dateFormatter.date(from: times[indexPath.row])
                    // popup.startTimePicker?.date = date
                    if let _date = date {
                        popup.date = _date
                        popup.weekDay = weekDay
                        popup.day = day
                        popup.month = month
                        popup.year = year
                    }
                    //
                    open()
                    self.navigationController?.pushViewController(popup, animated: false)
                }
            }
        }
        else if collectionView ==  collectionView1 {
            let storyBoard = UIStoryboard(name: "EventPopupViewController", bundle: nil)
            if let navvc = storyBoard.instantiateInitialViewController() as? UINavigationController {
                if let popup = navvc.topViewController as? EventPopupViewController {
                    let events = AppDelegate.monthsCollection.eventsFor(_day: day, _month: month, _year: year)
                    let event = AppDelegate.monthsCollection.eventsFor(_day: day, _month: month, _year: year)[indexPath.row]
                    popup.isCompleted = events[indexPath.row].completed
                    popup.index = indexPath.row
                    popup.weekDay = weekDay
                    popup.day = day
                    popup.month = month
                    popup.year = year
                    popup.image = event.image
                    popup.eventTitle = event.title
                    // animation
                    open2()
                    self.navigationController?.pushViewController(popup, animated: false)
                }
            }
        }
    }
    
    // MARK:- for centering the cell in the collection view
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == collectionView1 {
            let cellWidth: CGFloat = 400 // Your cell width
            let numberOfCells:CGFloat = 1.0
            let edgeInsets = (view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
            return UIEdgeInsets(top:300, left: 0, bottom: 300, right: edgeInsets)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
        
}
