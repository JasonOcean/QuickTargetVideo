//
//  PhotosContainer.swift
//  QuickTargetVideo
//
//  Created by Jason on 16/3/8.
//  Copyright © 2016年 Jason. All rights reserved.
//

import Foundation

class PhotosContainerView : UIView {
    
//    @property (nonatomic,strong) NSArray *images;
//    
   
    var singleTap : UITapGestureRecognizer!
    @IBAction func mytest(sender: AnyObject) {}
    
    var _photos : [UIImage] = []
    var photos : [UIImage] {
        
        get {
            return _photos
        }
        
        set {
            _photos = newValue
            
            for oldView in self.subviews {
                oldView.removeFromSuperview()
            }
            
//            UITapGestureRecognizer.init(target: self, action:"singleTagFromSearchVC:")
            
            var index : Int = 0
            for photo in _photos {
//                var myGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: SearchController("singleTagFromSearchVC:"))
                var myGesture : UITapGestureRecognizer = singleTap
                let photoV : UIImageView = UIImageView(image: photo)
                photoV.userInteractionEnabled = true
                photoV.contentMode = UIViewContentMode.ScaleAspectFill
                photoV.clipsToBounds = true
                photoV.tag = index
                photoV.userInteractionEnabled = true
                    //NSString(format: "www.baidu.com/s?wd=%d", index)

                photoV.addGestureRecognizer(myGesture)
                
                self.addSubview(photoV)

                index++
            }
        }
    }
    
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
            row = index % maxRow
            col = index / maxCol
            x = width * CGFloat(row)
            y = height * CGFloat(col)
            
            let frame : CGRect = CGRectMake(x, y, width, height)
            subview.frame = frame
            
            index++
        }
    }
}