//
//  EmojiTrackerHelper.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-28.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//

import UIKit

// MARK:- Methods used to help collect and manipulate emotion data
//struct of the components of the bar graph
struct BarEntry {
    let color: UIColor
    
    /// Ranged from 0.0 to 1.0
    let height: Float
    
    /// To be shown on top of the bar
    let textValue: String
    
    /// To be shown at the bottom of the bar
    let title: String
}
