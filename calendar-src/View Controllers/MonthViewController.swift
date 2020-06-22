//
//  MonthViewController.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-21.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//

import UIKit

class MonthViewController: UIViewController {
    @IBOutlet weak var MonthLabel: UILabel!
    @IBOutlet weak var YearLabel: UILabel!
    @IBOutlet weak var monthCollectionView:UICollectionView!
    //using a dict :- String:[(Int,String,Int)]() ---> key: month; value: an array of 3 tuples (isAvailable, Day, Date
    var theMonth = [myDay]()
    var cellNumberTapped:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
        setupGestures()
        setupData()
    }
    
    // function for initiating swipe left and swipe right gestures -- moving across calendar
    private func setupGestures(){
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(previousBtnPressed(_:)))
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(nextBtnPressed(_:)))
        rightSwipeGesture.direction = .right
        leftSwipeGesture.direction = .left
        self.monthCollectionView.addGestureRecognizer(rightSwipeGesture)
        self.monthCollectionView.addGestureRecognizer(leftSwipeGesture)
    }
    
    // function for populating the collection view model
    private func setupData(){
        // just some text data
        theMonth = populateWithPrevMonthDays(monthDays: getAllDaysOfTheMonth(indexFromCurrentMonth: AppDelegate.currentIndex/4), indexFromCurrentMonth: AppDelegate.currentIndex/4)
        MonthLabel.text = theMonth[15].month
        YearLabel.text = String(theMonth[15].year)
        monthCollectionView.reloadData()
    }
    
    // function for setting up the view
    private func setupView() {
        let width = (view.frame.size.width) / 8
        let layout = monthCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        AppDelegate.currentIndex += 4
        setupData()
        monthCollectionView.reloadData()
    }
    @IBAction func previousBtnPressed(_ sender: Any) {
        AppDelegate.currentIndex -= 4
        setupData()
        monthCollectionView.reloadData()
    }
    @IBAction func todayBtnPressed(_ sender: Any) {
        AppDelegate.currentIndex = 0
        setupData()
        monthCollectionView.reloadData()
    }
    
}
extension MonthViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theMonth.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthCollectionCell", for: indexPath) as! MonthCollectionViewCell
        if theMonth[indexPath.row].month != theMonth[15].month
        {
            cell.label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.label.text = String(theMonth[indexPath.row].day)
        }
        else
        {
            cell.label.text = String(theMonth[indexPath.row].day)
            // checking current date
            let date = Date()
            let calendar = Calendar.current
            if(Int(cell.label.text!) == calendar.component(.day, from: date) && convertToIntMonth(month: theMonth[15].month) == calendar.component(.month, from: date) && theMonth[15].year == calendar.component(.year, from: date)){
                cell.labelView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                cell.label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.labelView.layer.cornerRadius = cell.labelView.frame.height/2
            }
            else {
                cell.labelView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                cell.label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
        let events = AppDelegate.monthsCollection.eventsFor(_day: theMonth[indexPath.row].day, _month: theMonth[indexPath.row].month, _year: theMonth[indexPath.row].year)
        if(events.count > 0){
            cell.counterView.isHidden = false
            cell.counterLabel.isHidden = false
            cell.counterView.layer.cornerRadius = cell.counterView.frame.height/2
            cell.counterLabel.text = String(events.count)
        }
        else {
            cell.counterView.isHidden = true
            cell.counterLabel.text = ""
            cell.counterLabel.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // MARK:- Day View Seguing - Manual seguing by creating an instance of the vc to be segued to. Pushing on nav controller because vc embedded in nav controller.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DayViewController") as! DayViewController
        vc.titleText = theMonth[indexPath.row].month + " " + String(theMonth[indexPath.row].day) + ", " + String(theMonth[indexPath.row].year)
        vc.month = theMonth[indexPath.row].month
        vc.day = theMonth[indexPath.row].day
        vc.year = theMonth[indexPath.row].year
        vc.weekDay = theMonth[indexPath.row].dayOfWeek
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


