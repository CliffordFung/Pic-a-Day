//
//  EmojiTrackerViewController.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-23.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//

import UIKit


class EmojiTrackerViewController: UIViewController {
    
    @IBOutlet weak var BasicBarChart: BasicBarChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //creates an instance of the bar chart
    override func viewDidAppear(_ animated: Bool) {
        let dataEntries = generateDataEntries()
        BasicBarChart.dataEntries = dataEntries
    }
    //sets the set into bar chart instance
    func generateDataEntries() -> [BarEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [BarEntry] = []
        for i in 1..<31 {
            let value = (arc4random() % 8) + 1
            let height: Float = Float(value) / 8.0
            
            let formatter = "\(i) Nov"
            var date = Date();
            date.addTimeInterval(TimeInterval(24*60*60*i))
            result.append(BarEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: formatter))
        }
        return result
    }
}
