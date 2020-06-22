//
//  WeekViewController.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-21.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.


import UIKit

class WeekViewController: UIViewController {
    
    @IBOutlet weak var weekTableView: UITableView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    // MARK:- Variables
    var model = [[UIImage]]()
    var theWeek = [myDay]()
    
    // dict to store the offsets of corresponding rows -- used for remembering where we last scrolled to in each row
    var storedOffsets = [Int:CGFloat]()
    
    // MARK:- Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupData()
        for item in model {
            print("item count: \(item.count)")
        }
        let cell = weekTableView.dequeueReusableCell(withIdentifier: "weekTableCell") as! WeekTableViewCell
        cell.collectionView.reloadData()
    }
    
    @IBAction func nextBtnPressed(_ sender: Any){
        AppDelegate.currentIndex += 1
        setupData()
        weekTableView.reloadData()
    }
    
    @IBAction func previousBtnPressed(_ sender: Any){
        AppDelegate.currentIndex -= 1
        setupData()
        weekTableView.reloadData()
    }
    @IBAction func todayBtnPressed(_ sender: Any){
        AppDelegate.currentIndex = 0
        setupData()
        weekTableView.reloadData()
    }
    private func setupData(){
        theWeek = getAllDaysOfTheWeek(indexFromCurrentWeek: AppDelegate.currentIndex)
        yearLabel.text = String(theWeek[0].year)
        monthLabel.text = theWeek[0].month
        model.removeAll()
        for day in theWeek {
            let events = AppDelegate.monthsCollection.eventsFor(_day: day.day, _month: day.month, _year: day.year)
            var imageArr = [UIImage]()
            for event in events {
                if let data = event.image as Data?{
                    imageArr.append(UIImage(data: data)!)
                }
            }; model.append(imageArr)
        }
    }
    
}

extension WeekViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate{
    
    // MARK:- Table View Protocols
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weekTableCell", for: indexPath) as! WeekTableViewCell
        cell.dayLabel.text = String(theWeek[indexPath.row].day)
        cell.weekdayLabel.text = theWeek[indexPath.row].dayOfWeek
        let date = Date()
        let calendar = Calendar.current
        if(Int(convertToIntMonth(month: monthLabel.text!)) == calendar.component(.month, from: date) && Int(cell.dayLabel.text!) == calendar.component(.day, from: date) && theWeek.last?.year == calendar.component(.year, from: date)){
            print("Month")
            cell.dayLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            cell.weekdayLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            cell.todayHighlight.isHidden = false
        }
        else {
            cell.dayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.weekdayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.todayHighlight.isHidden = true
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.view.frame.height/8.35)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // this function sets the collection view's data source and delegate
        guard let tableViewCell = cell as? WeekTableViewCell else {return}
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        
        // coalesce the offset to 0 if there is no initial offset
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK:- Day View Seguing - Manual seguing by creating an instance of the vc to be segued to. Pushing on nav controller because vc embedded in nav controller.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DayViewController") as! DayViewController
        vc.titleText = theWeek[indexPath.row].month + " " + String(theWeek[indexPath.row].day) + ", " + String(theWeek[indexPath.row].year)
        vc.month = theWeek[indexPath.row].month
        vc.day = theWeek[indexPath.row].day
        vc.year = theWeek[indexPath.row].year
        vc.weekDay = theWeek[indexPath.row].dayOfWeek
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? WeekTableViewCell else { return }
        if(storedOffsets.count > 0) {
            storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
        }
        
    }
    
    // MARK:- Collection View Protocols
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(model.count > 0){
            return model[collectionView.tag].count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekCollectionCell", for: indexPath) as! WeekCollectionViewCell
        if(model.count>0)
        {
            cell.imageView.image = model[collectionView.tag][indexPath.item]
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
