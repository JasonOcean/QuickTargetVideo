//
//  MovieTableViewController.swift
//  QuickTargetVideo
//
//  Created by Jason on 15/11/10.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    var searchKey: String?
    var moviesGroupArray: [String] = []
    var movieItemsDictionary = [String : [MovieItem]]()
    let TopItemsCount = 3
    
    @IBOutlet var CurrentTableView: UITableView!
   
    func ResetmoviesArray()
    {
        ///Show loading animation
        let para: NSDictionary = [KVNProgressViewParameterStatus: "Loading...",
            KVNProgressViewParameterBackgroundType: 1,
            KVNProgressViewParameterFullScreen: true]
        KVNProgress.showWithParameters(para as [NSObject : AnyObject])
    
        let session = NSURLSession.sharedSession()
        
        let urliQiYi = NSURL(string: "http://so.iqiyi.com/so/q_" + searchKey!)
        let taskiQiYi = session.dataTaskWithURL(urliQiYi!) {(data, response, error) in
            let sourceContent:String = NSString(data:data!, encoding:NSUTF8StringEncoding)! as String
            let iQiYi = iQiYiSite(source: sourceContent)
            self.moviesGroupArray.append("爱奇艺")
            self.movieItemsDictionary["爱奇艺"] = Array(iQiYi.FindAllMovies().prefix(self.TopItemsCount))
            
            dispatch_async(dispatch_get_main_queue(), {
                    self.RefreshTableView()
                });
        }
        taskiQiYi.resume()
        
        let urlTuDou = NSURL(string: "http://www.soku.com/t/nisearch.do?kw=" + searchKey!)
        let taskTuDou = session.dataTaskWithURL(urlTuDou!) {(data, response, error) in
            let sourceContent:String = NSString(data:data!, encoding:NSUTF8StringEncoding)! as String
            let tuDou = TuDouSite(source: sourceContent)
            self.moviesGroupArray.append("土豆")
            self.movieItemsDictionary["土豆"] = Array(tuDou.FindAllMovies().prefix(self.TopItemsCount))
            
            dispatch_async(dispatch_get_main_queue(), {
                self.RefreshTableView()
            });
        }
        taskTuDou.resume()
        
        let urlSohu = NSURL(string: "http://so.tv.sohu.com/mts?wd=" + searchKey!)
        let taskSohu = session.dataTaskWithURL(urlSohu!) {(data, response, error) in
            let sourceContent:String = NSString(data:data!, encoding:NSUTF8StringEncoding)! as String
            let sohu = SohuSite(source: sourceContent)
            self.moviesGroupArray.append("搜狐视频")
            self.movieItemsDictionary["搜狐视频"] = Array(sohu.FindAllMovies().prefix(self.TopItemsCount))
            
            dispatch_async(dispatch_get_main_queue(), {
                self.RefreshTableView()
            });
        }
        taskSohu.resume()
        
        let urlYouKu = NSURL(string: "http://www.soku.com/search_video/q_" + searchKey!)
        let taskYouKu = session.dataTaskWithURL(urlYouKu!) {(data, response, error) in
            let sourceContent:String = NSString(data:data!, encoding:NSUTF8StringEncoding)! as String
            let youku = YouKuSite(source: sourceContent)
            self.moviesGroupArray.append("优酷")
            self.movieItemsDictionary["优酷"] = Array(youku.FindAllMovies().prefix(self.TopItemsCount))
            
            dispatch_async(dispatch_get_main_queue(), {
                self.RefreshTableView()
            });
        }
        taskYouKu.resume()
        
        let urlLetv = NSURL(string: "http://so.letv.com/s?wd=" + searchKey!)
        let taskLetv = session.dataTaskWithURL(urlLetv!) {(data, response, error) in
            let sourceContent:String = NSString(data:data!, encoding:NSUTF8StringEncoding)! as String
            let letv = LetvSite(source: sourceContent)
            self.moviesGroupArray.append("乐视TV")
            self.movieItemsDictionary["乐视TV"] = Array(letv.FindAllMovies().prefix(self.TopItemsCount))
            
            dispatch_async(dispatch_get_main_queue(), {
                self.RefreshTableView()
            });
        }
        taskLetv.resume()
        
        let urlPPTV = NSURL(string: "http://search.pptv.com/s_video?kw=" + searchKey!)
        let taskPPTV = session.dataTaskWithURL(urlPPTV!) {(data, response, error) in
            let sourceContent:String = NSString(data:data!, encoding:NSUTF8StringEncoding)! as String
            let pptv = PPTVSite(source: sourceContent)
            self.moviesGroupArray.append("PPTV聚力")
            self.movieItemsDictionary["PPTV聚力"] = Array(pptv.FindAllMovies().prefix(self.TopItemsCount))
            
            dispatch_async(dispatch_get_main_queue(), {
                self.RefreshTableView()
            });
        }
        taskPPTV.resume()
        
        let url56 = NSURL(string: "http://so.56.com/all/" + searchKey! + "/")
        let task56 = session.dataTaskWithURL(url56!) {(data, response, error) in
            let sourceContent:String = NSString(data:data!, encoding:NSUTF8StringEncoding)! as String
            let fivesix = FiveSixSite(source: sourceContent)
            self.moviesGroupArray.append("56视频")
            self.movieItemsDictionary["56视频"] = Array(fivesix.FindAllMovies().prefix(self.TopItemsCount))
            
            dispatch_async(dispatch_get_main_queue(), {
                self.RefreshTableView()
            });
        }
        task56.resume()
    }
    
    func RefreshTableView() {
        self.CurrentTableView.reloadData()
        KVNProgress.dismiss()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "MovieGo")
        {
            let path:NSIndexPath = self.tableView.indexPathForSelectedRow!
            let videoPage = segue.destinationViewController as! VideoDetail
            
            let link = self.movieItemsDictionary[self.moviesGroupArray[path.section]]![path.row].link
            videoPage.linkUrl = link
            
            //The link from todou is a relative path, then we need to add its main site address "www.soku.com"
            if((self.moviesGroupArray[path.section] == "TuDou" || self.moviesGroupArray[path.section] == "YouKu")
                && (link as NSString).substringToIndex(1)=="/") {
                videoPage.linkUrl = "http://soku.com/" + link
            }
            
            if(self.moviesGroupArray[path.section] == "YouKu" && (link as NSString).substringToIndex(1)=="/") {
                    videoPage.linkUrl = "http://soku.com/" + link
            }
        }
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.moviesGroupArray[section]
//    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var iconName: String
        
        switch self.moviesGroupArray[section] {
        case "爱奇艺":
            iconName = "iqiyi.png"
        case "土豆":
            iconName = "tudou.png"
        case "搜狐视频":
            iconName = "sohu.png"
        case "优酷":
            iconName = "youku.png"
        case "乐视TV":
            iconName = "letv.png"
        case "PPTV聚力":
            iconName = "pptv.png"
        case "56视频":
            iconName = "56.png"
        default:
            iconName = "iqiyi.jpg"
        }
        
        let iconRaw : UIImage = UIImage(named: iconName)!
        let icon = CommonHelper.ResizeImage(iconRaw, targetSize: CGSizeMake(130, 130))
        let headerView: UIView = UIView.init(frame: CGRectMake(0, 0, tableView.bounds.size.width, icon.size.height+20))
        let sectionHeaderBG: UIImageView = UIImageView.init(image: icon)
        headerView.addSubview(sectionHeaderBG)
        
        return headerView
    }
    
    override func viewDidLoad() {
        self.ResetmoviesArray()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.moviesGroupArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionName = self.moviesGroupArray[section]
        if(self.movieItemsDictionary[sectionName] == nil)
        {
            return 0;
        }else
        {
            return self.movieItemsDictionary[sectionName]!.count
        }
    }
    
    func ClipTextUnderASCII(text: String, targetLength: Int) -> String {
        var flag:Int=0
        var lenASCII=0
        for v in text.unicodeScalars {
            flag += 1
            if v.isASCII() {
                lenASCII+=1
            }
            else {
                lenASCII+=2
            }
            
            if lenASCII>=targetLength {
              return  (NSString.init(format: "%@%@", (text as NSString).substringToIndex(flag), "...")) as String
            }
        }
        
        return text;
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifyName: String = "MovieTableViewCell"
        let cell: MovieTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifyName) as! MovieTableViewCell
        
        let sectionName = self.moviesGroupArray[indexPath.section]
        let movieItem = self.movieItemsDictionary[sectionName]?[indexPath.row]
        let maxLength: Int = 25
        cell.movieTitle?.text = ClipTextUnderASCII((movieItem?.title)!, targetLength: maxLength)
        
        cell.movieImageView.contentMode = .ScaleAspectFit
        downloadImage(NSURL(string:(movieItem?.img)!)!, imageView: cell.movieImageView!)
        //print(movieItem?.title,movieItem?.img)
        return cell
    }
    
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL, imageView view:UIImageView){
        //print("Download Started")
        //print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                //print(response?.suggestedFilename ?? "")
                //print("Download Finished")
                view.image = UIImage(data: data)
            }
        }
    }
    
}
