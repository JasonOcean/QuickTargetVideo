//
//  DataViewController.swift
//  QuickTargetVideo
//
//  Created by Jason on 15/11/3.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var CurrentView: UIView!
    var HotVideoTitles : [String]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
    }
    
    func LoadHotVedios() {
//        let url = NSURL(string: "http://www.iqiyi.com/")
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
//            let sourceContent:String = NSString(data:data!, encoding:NSUTF8StringEncoding)! as String
//            var hotVideos = HotVideosPage(source: sourceContent)
//            self.HotVideoTitles = hotVideos.FindAllMovies().map{ $0.title }
//            
//            dispatch_async(dispatch_get_main_queue(),{
//                self.BindingHotVideos()
////                self.CurrentView.reloadInputViews()
//            })
//        }
//        
//        task.resume()
        
        var source: String!
        let url = NSURL(string: "http://www.iqiyi.com/")
        do {
            let abc = try NSString(contentsOfURL: url!, encoding:NSUTF8StringEncoding)
            source = abc.stringByReplacingOccurrencesOfString("\\", withString: "")
        }
        catch {}
        
        var hotVideos = HotVideosPage(source: source)
        self.HotVideoTitles = hotVideos.FindAllMovies().map{ $0.title }
//        self.HotVideoTitles = hotVideos.FindAllMovies().map{ $0.link }
        
        self.BindingHotVideos()
    }
    
    func getLabelsInView(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UILabel {
                results += [labelView]
            } else {
                //results += getLabelsInView(subview)
            }
        }
        return results
    }
    
    func BindingHotVideos() {
        var colorArray = [UIColor.greenColor(),UIColor.blueColor(), UIColor.purpleColor(),UIColor.redColor(),UIColor.grayColor(),UIColor.magentaColor(),UIColor.brownColor()]
        //var titlesArray = ["甄嬛传","琅琊榜","中国式结婚","雪豹","蜡笔小新","麻辣父子","GTO","芈月传","一起结婚吧"]
        var frameArray = ["{{54, 292}, {320, 250}}","{{26, 228}, {320, 30}}","{{132, 254}, {320, 160}}","{{64, 146}, {320, 30}}","{{180, 225}, {320, 80}}","{{54, 320}, {320, 160}}","{{132, 538}, {320, 330}}","{{170, 469}, {320, 230}}","{{47, 390}, {320, 130}}"]
        
        if(!self.HotVideoTitles.isEmpty) {
            let labels = getLabelsInView(self.view)
            var i = 0
            for label in labels {
                label.text = HotVideoTitles[i++]
                label.textColor = colorArray[random()%colorArray.count];
                label.font = UIFont.systemFontOfSize(CGFloat(random() % 15) + 20.0);
                label.center = self.view.center;
                label.numberOfLines = 1
            }
            
            i = 0
            for label in labels {
                UIView.animateWithDuration(2, animations: {
                    label.frame = CGRectFromString(frameArray[i++])
                    }, completion:nil)
                
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.LoadHotVedios()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print(searchBar.text, terminator: "")
        searchBar.resignFirstResponder()
        
        let movieListController = storyboard?.instantiateViewControllerWithIdentifier("MovieList") as! MovieTableViewController
        movieListController.searchKey = searchBar.text?.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        self.navigationController?.pushViewController(movieListController, animated: true)
    }
}

