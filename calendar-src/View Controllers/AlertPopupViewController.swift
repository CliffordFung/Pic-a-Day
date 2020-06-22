//
//  AlertPopupViewController.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-26.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//

import UIKit
import UserNotifications

class AlertPopupViewController: UIViewController {
    // MARK:- Variables
    var image:UIImage? // comes from event clipboard protocol
    var weekDay:String?
    var day:Int?
    var month:String?
    var year:Int?
    var currentlyEditing: Bool?
    var event:Event? // need this for removing an event
    var eventTitle:String?
    var date:Date!
    // MARK:- Outlets
    
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var alertPicker: UIDatePicker!
    @IBOutlet weak var imageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        navigationController?.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _image = image {
            imageBtn.setBackgroundImage(_image, for: .normal)
            imageBtn.setTitle("", for: .normal)
        }
        if let _title = eventTitle {
            eventTextField.text = _title
        }
        if let _date = date {
            startTimePicker.setDate(_date, animated: false)
            let _date = _date.addingTimeInterval(3600)
            endTimePicker.setDate(_date, animated: false)
            // default reminder is 1 hour before event starts
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "H:mm"
            let _date2 = dateFormatter.date(from: "1:00")
            alertPicker.setDate(_date2!, animated: false)
        }
        
    }
    
    @IBAction func imageBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ClipboardViewController") as! ClipboardViewController
        vc.toSetEventImage = true
        vc.imageProtocol = self
        open()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        if let __image = image {
            if let eventTitle = eventTextField.text{
                if eventTitle != "" {
                    if currentlyEditing != nil{
                        // delete the event and then add a new event
                        AppDelegate.monthsCollection.removeEventOn(_weekDay: weekDay!, _day: day!, _month: month!, _year: year!, _event: event!)
                        
                    }
                    let calendar = Calendar.current
                    let hours = calendar.component(.hour, from: alertPicker.date)
                    let mins = calendar.component(.minute, from: alertPicker.date)
                    let alertTime = startTimePicker.date.addingTimeInterval(TimeInterval(-1*(hours*3600+mins*60)))
                    let _event = Event(_image: __image, _startTime: startTimePicker.date, _endTime: endTimePicker.date, _alert: alertTime, _title: eventTitle, _emotionBefore: nil, _emotionAfter: nil, _hasNotification: true)
                    AppDelegate.monthsCollection.addEvent(_weekDay: weekDay!, _day: day!, _month: month!, _year: year!, _event: _event)
                    //  create a notification here
                    // let time = getTimeInSeconds(time: alertPicker)
                    
                    // content -- type of notification
                    let content = UNMutableNotificationContent()
                    content.title = "Event: \(eventTitle)"
                    content.sound = UNNotificationSound.default
                    content.badge = 2
                 
                    // setting date component
                    var dateComponentsAlert = DateComponents()
                    dateComponentsAlert.day = day!; dateComponentsAlert.month = convertToIntMonth(month: month!); dateComponentsAlert.year = year!;
                    dateComponentsAlert.hour = calendar.component(.hour, from: alertTime); dateComponentsAlert.minute = calendar.component(.minute, from: alertTime);
    
                    // setting date components
                    var dateComponentsStart = DateComponents()
                    dateComponentsStart.day = day!; dateComponentsStart.month = convertToIntMonth(month: month!); dateComponentsStart.year = year!;
                    dateComponentsStart.hour = calendar.component(.hour, from: startTimePicker.date); dateComponentsStart.minute = calendar.component(.minute, from: startTimePicker.date);
                    
                    // event trigger
                    let beforeTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsAlert, repeats: false)
                    
                    // event trigger
                    let onEventTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsStart, repeats: false)
                    
                    
                    // creating a request to show the notification
                    // using same identifier overide notification
                    // 1
                    print(_event.getBeginEventID())
                    var request = UNNotificationRequest(identifier: String(_event.getBeginEventID()), content: content, trigger: beforeTrigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    // 2
                    print(_event.getAtEventID())
                    request = UNNotificationRequest(identifier: String(_event.getAtEventID()), content: content, trigger: onEventTrigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    
                    // closing style
                    if currentlyEditing != nil {
                        currentlyEditing = nil
                        close2()
                    }else {
                        close(numberOfPops: 2)
                    }
                }
                else {
                    let alertController = UIAlertController(title: "Missing Title", message: "Please enter a title for the event", preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                    alertController.addAction(dismissAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        else {
            let alertController = UIAlertController(title: "Missing Image", message: "Please set an image for the event", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alertController.addAction(dismissAction)
            self.present(alertController, animated: true)
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        navigationController?.isNavigationBarHidden = false
        let numberOfPops:Int!
        if isEditing {
            numberOfPops = 3
        }
        else{
            numberOfPops = 3
        }
        close(numberOfPops: numberOfPops)
    }
    
    private func close(numberOfPops:Int) {
        // animation
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.isNavigationBarHidden = false
        popBack(numberOfTimes: numberOfPops)
    }
    
    private func close2() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromRight
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.isNavigationBarHidden = false
        popBack(numberOfTimes: 3)
    }
    
    private func open() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
    
    func popBack(numberOfTimes: Int) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count < numberOfTimes else {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - numberOfTimes], animated: false)
                return
            }
        }
    }
}

extension AlertPopupViewController: ImageProtocol {
    func setImage(_image: UIImage) {
        image = _image
        imageBtn.setTitle("", for: .normal)
    }
}
