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
    @IBOutlet weak var hotVideoView: PhotosContainerView!
    
    var HotVideoItems : [MovieItem] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //searchBar.becomeFirstResponder()
        
        let singleTapGesture = UITapGestureRecognizer.init(target: self, action:"singleTagFromSearchVC:")
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        hotVideoView.singleTap = singleTapGesture
    }
    
    override func viewWillLayoutSubviews() {
        hotVideoView.photos = self.GetHotVideoPhotos()
    }
    
    func LoadHotVedios() {
        var source: String!
        let url = NSURL(string: "http://www.iqiyi.com/")
        do {
            let abc = try NSString(contentsOfURL: url!, encoding:NSUTF8StringEncoding)
            source = abc.stringByReplacingOccurrencesOfString("\\", withString: "")
        }
        catch {}
        
        self.HotVideoItems = self.UpgradeToShortTitle(HotVideosPage(source: source).FindAllMovies())
        
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

        var frameArray = ["{{54, 110}, {120, 30}}","{{26, 300}, {120, 30}}","{{192, 124}, {180, 30}}","{{34, 146}, {130, 30}}","{{280, 175}, {130, 30}}","{{54, 190}, {150, 30}}","{{262, 238}, {120, 30}}","{{170, 269}, {120, 30}}","{{40, 250}, {120, 30}}","{{170, 320}, {120, 30}}"]
        
        if(!self.HotVideoItems.isEmpty) {
            let labels = getLabelsInView(self.view)
            var i = 0
            for label in labels {
                label.userInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer.init(target: self, action:"labelTap:")
                label.addGestureRecognizer(tapGesture)
                
                label.text = HotVideoItems[i++].title
                label.textColor = colorArray[random()%colorArray.count]
                label.font = UIFont.systemFontOfSize(CGFloat(random() % 5) + 20.0);
//                label.layer.borderColor = UIColor.redColor().CGColor
//                label.layer.borderWidth = 3.0
                label.center = self.view.center

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
    
    @IBAction func labelTap(sender: AnyObject){
        let label = sender.view as! UILabel
        var items = HotVideoItems.filter({$0.title == label.text})
        
        let videoDetailController = storyboard?.instantiateViewControllerWithIdentifier("VideoDetail") as! VideoDetail
        videoDetailController.linkUrl = items[0].link
        self.navigationController?.pushViewController(videoDetailController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //self.LoadHotVedios()
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
    
    
    ///Splite title by comma, then use the head part as the wanted short title
    func UpgradeToShortTitle(longTitles: [MovieItem])-> [MovieItem]{
        var shortTitles:[MovieItem] = []
        
        for(var i=0; i<longTitles.count; i++) {
            shortTitles.append(longTitles[i])
            let nTitle:NSString = longTitles[i].title as NSString
            let tArray = Array(longTitles[i].title.characters)
            var loc : Int = -1
            for (var k=0; k<tArray.count; k++) {
                if(tArray[k]=="：" || tArray[k]=="，") {
                    if(loc<0) {
                        loc = k
                    }
                }
            }
            
            if(loc>=0) {
                shortTitles[i].title = (nTitle.substringToIndex(loc)) as String
            }
        }
        
        return shortTitles
    }
    
    func GetHotVideoPhotos() -> [UIImage] {
        var photos : NSMutableArray = []
        
        for(var i:Int = 1; i<5; i++) {
            let photoName : String = NSString(format: "%d", i) as String
            let photo:UIImage = UIImage(named: photoName)!
            
            photos.addObject(photo)
        }
        
        return photos.mutableCopy() as! [UIImage]
    }
    
    @IBAction func singleTagFromSearchVC(sender: AnyObject){
        let videoDetailController = storyboard?.instantiateViewControllerWithIdentifier("VideoDetail") as! VideoDetail
        videoDetailController.linkUrl = "http://www.baidu.com"
        self.navigationController?.pushViewController(videoDetailController, animated: true)
    }
}

