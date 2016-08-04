//
//  VideoDetail.swift
//  QuickVideo
//
//  Created by GTCC on 10/13/15.
//  Copyright © 2015 ATCC. All rights reserved.
//

import Foundation
import UIKit
class VideoDetail : UIViewController
{
    var linkUrl : String = ""
    @IBOutlet weak var currentWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if !CommonHelper.isConnectedToNetwork() {
            CommonHelper.ShowAlert("网络异常", content: "网络不给力，请稍后重试")
            return
        }
        
        let url = NSURL(string: linkUrl)
        let request = NSURLRequest(URL: url!)
        currentWebView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}