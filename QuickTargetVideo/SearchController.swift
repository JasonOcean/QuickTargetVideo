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
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var colorArray = [UIColor.greenColor(),UIColor.blueColor(), UIColor.purpleColor(),UIColor.redColor(),UIColor.grayColor(),UIColor.magentaColor(),UIColor.brownColor()]
        var titlesArray = ["甄嬛传","琅琊榜","中国式结婚","雪豹","蜡笔小新","麻辣父子","GTO","芈月传","一起结婚吧"]
        var frameArray = ["{{54, 92}, {120, 50}}","{{26, 228}, {120, 30}}","{{132, 124}, {120, 30}}","{{64, 146}, {120, 30}}","{{180, 175}, {120, 30}}","{{54, 190}, {120, 30}}","{{132, 238}, {120, 30}}","{{170, 269}, {120, 30}}","{{47, 290}, {120, 30}}"]
        
        let labels = getLabelsInView(self.view)
        var i = 0
        for label in labels {
            label.text = titlesArray[i++]
            label.textColor = colorArray[random()%colorArray.count];
            label.font = UIFont.systemFontOfSize(CGFloat(random() % 15) + 12.0);
            label.frame = CGRectZero;
            label.center = self.view.center;
        }
        
        i = 0
        for label in labels {
            UIView.animateWithDuration(2, animations: {
                label.frame = CGRectFromString(frameArray[i++])
                }, completion:nil)
            
        }

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print(searchBar.text, terminator: "")
        searchBar.resignFirstResponder()
        
        let movieListController = storyboard?.instantiateViewControllerWithIdentifier("MovieList") as! MovieTableViewController
        movieListController.searchKey = searchBar.text
        presentViewController(movieListController, animated: true, completion: nil)
    }
}

