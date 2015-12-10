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
    var searchContent : String = ""
    @IBOutlet weak var currentWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
//         Do any additional setup after loading the view, typically from a nib.
        var content: String = "http://so.iqiyi.com/so/q_" + searchContent
        content = content.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
       
        let url = NSURL(string: content)
        let request = NSURLRequest(URL: url!)
        currentWebView.loadRequest(request)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}