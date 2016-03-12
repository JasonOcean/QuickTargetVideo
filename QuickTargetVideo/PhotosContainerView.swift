//
//  PhotosContainer.swift
//  QuickTargetVideo
//
//  Created by Jason on 16/3/8.
//  Copyright © 2016年 Jason. All rights reserved.
//

import Foundation

class PhotosContainerView : UIView {
    
    var singleTap : UITapGestureRecognizer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let myFrame : CGRect = self.bounds
        let maxRow : Int32 = 2
        let maxCol : Int32 = 2
        let width : CGFloat = myFrame.size.width / CGFloat(maxRow)
        let height : CGFloat = myFrame.size.height / CGFloat(maxCol)
        
        var row : Int32
        var col : Int32
        var x : CGFloat
        var y : CGFloat
        var index : Int32 = 0
        for subview in self.subviews {
            let r = index / 2
            row = r % maxRow
            col = r / maxCol
            x = width * CGFloat(row)
            y = height * CGFloat(col)
            
            if(subview is UIImageView) {
                subview.frame = CGRectMake(x, y, width-15, height-25)
            }
            else if(subview is UILabel) {
                subview.frame = CGRectMake(x, y + height - 20, width - 15, 20)
            }
            
            index++
        }
    }
}

class SingleHotVideoView : UIView {
    @IBOutlet weak var hotVideoTitle : UILabel?
    @IBOutlet weak var hotVideoImage : UIImageView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let f : CGRect = self.bounds
        let lableFrame : CGRect = CGRectMake(f.origin.x + 2, f.origin.y + 2, f.size.width - 5, 10)
        let imageViewFrame : CGRect = CGRectMake(f.origin.x + 2, f.origin.y + 15, f.size.width - 5, f.size.height - 15)
        
        hotVideoTitle?.frame = lableFrame
        hotVideoImage?.frame = imageViewFrame
        
        self.addSubview(hotVideoTitle!)
        self.addSubview(hotVideoImage!)
    }
}