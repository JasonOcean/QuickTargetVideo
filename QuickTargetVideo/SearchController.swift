//
//  DataViewController.swift
//  QuickTargetVideo
//
//  Created by Jason on 15/11/3.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

import UIKit


class SearchController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var hotVideoTag: UILabel!
    
    @IBOutlet weak var myTableView: UITableView!
    var HotVideoItems : [MovieItem] = []
    var IsViewLoaded = false
    var IsWarned = false

    //just a test
    override func viewDidLoad() {
        super.viewDidLoad()
        IsViewLoaded = false
        IsWarned = false
    
        self.LoadHotVedios()
        
        let logo = UIImage(named: "Onevideo_Title.png")
        let logoNew = CommonHelper.ResizeImage(logo!, targetSize: CGSizeMake(400, 50))
        let logoView = UIImageView(image: logoNew)
        self.navigationItem.titleView = logoView
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "AutoRefresh", userInfo: nil, repeats: true)
    }
    
    func AutoRefresh() {
        if !IsViewLoaded {
            self.LoadHotVedios()
            dispatch_async(dispatch_get_main_queue()) { self.myTableView.reloadData()}
        }
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
    
    @IBAction func singleTagFromSearchVC(sender: UIGestureRecognizer){
        let videoDetailController = storyboard?.instantiateViewControllerWithIdentifier("VideoDetail") as! VideoDetail
        videoDetailController.linkUrl = self.HotVideoItems[sender.view!.tag].link
        self.navigationController?.pushViewController(videoDetailController, animated: true)
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
    
    func GetImageViewBasedOnLinkImg(imgUrl : String) -> UIImage {
        if !CommonHelper.isConnectedToNetwork() {
            CommonHelper.ShowAlert("网络异常", content: "网络不给力，请稍后重试")
            return UIImage()
        }
        
        let url = NSURL(string: imgUrl)
        let data : NSData = NSData(contentsOfURL: url!)!
        let image : UIImage = UIImage(data: data)!
        
        return image
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.HotVideoItems.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let hotCell:HotVideoTabCell = self.myTableView!.dequeueReusableCellWithIdentifier("HotVideoCell") as! HotVideoTabCell
//        hotCell.hotVideoIndex.text = String(indexPath.row + 1)
        hotCell.hotVideoTitle.text = self.HotVideoItems[indexPath.row].title
        
        let singleTapGesture = UITapGestureRecognizer.init(target: self, action:"singleTagFromSearchVC:")
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        hotCell.tag = indexPath.row
        hotCell.addGestureRecognizer(singleTapGesture)
        
        return hotCell
    }
    
    func LoadHotVedios() {
        if !(IsWarned || CommonHelper.isConnectedToNetwork()) {
            CommonHelper.ShowAlert("网络异常", content: "网络不给力，请稍后重试")
            IsWarned=true
            return
        }
        
        var source: String!
        let url = NSURL(string: "http://www.iqiyi.com/")
        do {
            let abc = try NSString(contentsOfURL: url!, encoding:NSUTF8StringEncoding)
            source = abc.stringByReplacingOccurrencesOfString("\\", withString: "")
            
            //self.HotVideoItems = self.UpgradeToShortTitle(HotVideosPage(source: source).FindAllMovies())
            self.HotVideoItems = HotVideosPage(source: source).FindAllMovies()
            
            IsViewLoaded = true
        }
        catch {
            
            if !IsWarned {
                CommonHelper.ShowAlert("网络异常", content: "网络不给力，请稍后重试")
                IsWarned = true
            }
        }
    }
}

