//
//  ClipboardCollectionViewCell.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-22.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//

import UIKit

class ClipboardCollectionViewCell: UICollectionViewCell {
   
    // MARK:- Variables
    
    var isEditing: Bool = false {
        didSet {
            selectionImage.isHidden = !isEditing
        }
    }
    
    // MARK:- Outlets
    
    @IBOutlet weak var mainImage : UIImageView!
    
    @ IBOutlet weak var selectionImage: UIImageView!
    
    // MARK:- Methods
    
    override var isSelected: Bool {
        didSet {
            selectionImage.image = isSelected ? UIImage(named: "Checked") : UIImage(named: "Unchecked")
        }
    }
}
