//
//  EventPopupViewController.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-29.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//

import UIKit

class EventPopupViewController: UIViewController {

    // MARK: - Variables
    
    var index:Int!
    var isCompleted:Bool!
    var year:Int!
    var month:String!
    var weekDay:String!
    var day:Int!
    var image:UIImage?
    var eventTitle: String?

    // MARK: - Outlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    
    
    @IBOutlet weak var completeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        updateCompleteBtnText()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        eventTitleLabel.text = eventTitle
        dateLabel.text = weekDay + ", " + String(day) + " " + month + String(year) 
        let events = AppDelegate.monthsCollection.eventsFor(_day: day, _month: month, _year: year)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        var time = events[index].startTime
        timeLabel.text = dateFormatter.string(from: time)
        time = events[index].alert
        alertLabel.text = dateFormatter.string(from: time)
    }

    @IBAction func cancelBtnPressed(_ sender: Any) {
        // animation
        close()
        navigationController?.popViewController(animated: false)
    }
    @IBAction func editBtnPressed(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "AlertPopupViewController", bundle: nil)
        if let navvc = storyBoard.instantiateInitialViewController() as? UINavigationController {
            if let popup = navvc.topViewController as? AlertPopupViewController {
                let event = AppDelegate.monthsCollection.eventsFor(_day: day, _month: month, _year: year)[index]
                popup.day = day
                popup.weekDay = weekDay
                popup.month = month
                popup.year = year
                popup.event = event
                popup.currentlyEditing = true
                popup.image = image
                popup.eventTitle = eventTitle
                // animation
                open()
                self.navigationController?.pushViewController(popup, animated: false)
            }
        }
    }
    @IBAction func completeBtnPressed(_ sender: Any) {
        AppDelegate.monthsCollection.eventsFor(_day: day, _month: month, _year: year)[index].toggleComplete()
        isCompleted.toggle()
        updateCompleteBtnText()
        close()
    }
    @IBAction func deleteBtnPressed(_ sender: Any) {
        let event = AppDelegate.monthsCollection.eventsFor(_day: day, _month: month, _year: year)[index]
        AppDelegate.monthsCollection.removeEventOn(_weekDay: weekDay, _day: day, _month: month, _year: year, _event: event)
        navigationController?.popViewController(animated: false)
    }
    
    private func close() {
        // animation
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromRight
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.isNavigationBarHidden = false
        navigationController?.popViewController(animated: false)
    }
    
    private func open() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
    
    private func updateCompleteBtnText() {
        if isCompleted{
            completeBtn.setTitle("Incomplete", for: .normal)
        }
        else {
            completeBtn.setTitle("Complete", for: .normal)
        }
    }
    
}
