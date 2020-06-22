//
//  WeekTableViewCell.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-21.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//


import UIKit

class WeekTableViewCell: UITableViewCell {
    
    // MARK:- Variables
    
    // computed property used to remember which collection cell was in which table cell position -- since cells are reused -- can be removed
    var collectionViewOffset:CGFloat {
        get {
            return collectionView.contentOffset.x
        }
        set {
            collectionView.contentOffset.x = newValue
        }
    }
    
    // MARK:- Outlets
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var todayHighlight: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    // MARK:- collection view delegate and data source assignment function
    
    func setCollectionViewDataSourceDelegate <D: UICollectionViewDelegate & UICollectionViewDataSource>(dataSourceDelegate:D, forRow row:Int){
        collectionView.delegate=dataSourceDelegate
        collectionView.dataSource=dataSourceDelegate
        collectionView.tag=row
        collectionView.reloadData()
    }
    
}
