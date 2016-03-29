//
//  DataViewController.swift
//  QuickTargetVideo
//
//  Created by Jason on 15/11/3.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

import UIKit

class SearchController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var hotVideoView: PhotosContainerView!
    
    @IBOutlet weak var myTableView : UITableView?
    
    @IBOutlet weak var hotVideoTag: UILabel!
    
    var HotVideoItems : [MovieItem] = []
    var HotVideoItems56 : [MovieItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let singleTapGesture = UITapGestureRecognizer.init(target: self, action:"singleTagFromSearchVC:")
//        singleTapGesture.numberOfTapsRequired = 1
//        singleTapGesture.numberOfTouchesRequired = 1
//        hotVideoView.singleTap = singleTapGesture
        
//        self.Load56HotVedios()
        self.LoadHotVedios()
    }
    
    func Load56HotVedios() {
        let session = NSURLSession.sharedSession()
        let urlSohu = NSURL(string: "http://www.56.com/")
        let task56 = session.dataTaskWithURL(urlSohu!) {(data, response, error) in
            let encode : UInt = NSUTF8StringEncoding
            let sourceContent:String = NSString(data:data!, encoding:encode)! as String
            let hot56 = HotVideosPage56(source: sourceContent)
            self.HotVideoItems56 = hot56.FindAllMovies()
            
            dispatch_async(dispatch_get_main_queue(), {
                self.Bind56HotVideosSubView()
                self.hotVideoTag.hidden = false
            });
        }
        task56.resume()
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
        
//        videoDetailController.linkUrl = self.HotVideoItems56[sender.view!.tag].link
        videoDetailController.linkUrl = self.HotVideoItems[sender.view!.tag].link
        self.navigationController?.pushViewController(videoDetailController, animated: true)
    }
    
    func Bind56HotVideosSubView() {
        for oldView in self.hotVideoView.subviews {
            oldView.removeFromSuperview()
        }
        
        var index : Int = 0
        for item in self.HotVideoItems56 {
            if(index < 4) {
                let myGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "singleTagFromSearchVC:")
                let img = GetImageViewBasedOnLinkImg(item.img)
                let photoV : UIImageView = UIImageView(image: img)
                photoV.userInteractionEnabled = true
                photoV.contentMode = UIViewContentMode.ScaleAspectFill
                photoV.clipsToBounds = true
                photoV.tag = index
                photoV.userInteractionEnabled = true
                photoV.addGestureRecognizer(myGesture)
                self.hotVideoView.addSubview(photoV)
                
                let title : UILabel = UILabel()
                title.text = item.title
                self.hotVideoView.addSubview(title)
            }
            
            index++
        }
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
        let url = NSURL(string: imgUrl)
        let data : NSData = NSData(contentsOfURL: url!)!
        let image : UIImage = UIImage(data: data)!
        
        return image
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.HotVideoItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let hotCell:HotVideoTabCell = self.myTableView!.dequeueReusableCellWithIdentifier("HotVideoCell") as! HotVideoTabCell
        hotCell.hotVideoIndex.text = String(indexPath.row + 1)
        hotCell.hotVideoTitle.text = self.HotVideoItems[indexPath.row].title
        
        let singleTapGesture = UITapGestureRecognizer.init(target: self, action:"singleTagFromSearchVC:")
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        hotCell.tag = indexPath.row
        hotCell.addGestureRecognizer(singleTapGesture)
        
        return hotCell
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
    }
}

