//
//  CommonHelper.swift
//  QuickTargetVideo
//
//  Created by Jason on 16/7/4.
//  Copyright © 2016年 Jason. All rights reserved.
//

import Foundation

class CommonHelper {
   
    static func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio = targetSize.width / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if widthRatio>heightRatio {
            newSize = CGSizeMake(size.width*heightRatio, size.height*heightRatio)
        }
        else {
            newSize = CGSizeMake(size.width*widthRatio, size.height*widthRatio)
        }
        
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}