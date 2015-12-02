//
//  MovieTableViewCell.swift
//  QuickTargetVideo
//
//  Created by Jason on 15/11/11.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

import UIKit
import Foundation

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitle : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
