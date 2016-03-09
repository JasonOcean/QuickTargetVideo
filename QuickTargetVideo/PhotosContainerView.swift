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
            
            var index : Int = 0
            for photo in _photos {
                let photoV : UIImageView = UIImageView(image: photo)
                photoV.userInteractionEnabled = true
//              photoV.contentMode = UIViewContentModeScaleAspectFill
                photoV.contentMode = UIViewContentMode.ScaleAspectFill
                photoV.clipsToBounds = true
                photoV.tag = index
                
                self.addSubview(photoV)
                
//                //添加手势
//                [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage:)]];
                
                index++
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let myFrame : CGRect = self.bounds
        let maxRow : Int32 = 3
        let maxCol : Int32 = 3
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