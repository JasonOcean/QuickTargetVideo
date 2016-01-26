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
    var moviesGroupArray = ["iQiYi", "TuDou", "Sohu"]
    var movieTitles = Dictionary<String, Array<String>>()
    var movieLinks = Dictionary<String, Array<String>>()
    
    @IBOutlet var CurrentTableView: UITableView!
   
    func ResetmoviesArray()
    {
        ///Show loading animation
        let para: NSDictionary = [KVNProgressViewParameterStatus: "Loading...",
            KVNProgressViewParameterBackgroundType: 1,
            KVNProgressViewParameterFullScreen: true]
        KVNProgress.showWithParameters(para as [NSObject : AnyObject])
        
        let maxNum : Int = 3
    
        var session = NSURLSession.sharedSession()
        
        var urliQiYi = NSURL(string: "http://so.iqiyi.com/so/q_" + searchKey!)
        let taskiQiYi = session.dataTaskWithURL(urliQiYi!) {(data, response, error) in
            var sourceContent:String = NSString(data:data!, encoding:NSUTF8StringEncoding)! as String
            var iQiYi = iQiYiSite(source: sourceContent)
                        let iQiYiTitles = iQiYi.FindAllMovies().map{ $0.title }
                        self.movieTitles["iQiYi"] = iQiYiTitles.count>maxNum ? Array(iQiYiTitles[0..<maxNum]) : iQiYiTitles
        
                        let iQiYiLinks = iQiYi.FindAllMovies().map{ $0.link }
                        self.movieLinks["iQiYi"] = iQiYiLinks.count>maxNum ? Array(iQiYiLinks[0..<maxNum]) : iQiYiLinks
            
            dispatch_async(dispatch_get_main_queue(), {
                    self.RefreshTableView()
                });
        }
        taskiQiYi.resume()
        
        var urlTuDou = NSURL(string: "http://www.soku.com/t/nisearch.do?kw=" + searchKey!)
        let taskTuDou = session.dataTaskWithURL(urlTuDou!) {(data, response, error) in
            var sourceContent:String = NSString(data:data!, encoding:NSUTF8StringEncoding)! as String
            var tuDou = TuDouSite(source: sourceContent)
            let tuDouTitles = tuDou.FindAllMovies().map{ $0.title }
            self.movieTitles["TuDou"] = tuDouTitles.count>maxNum ? Array(tuDouTitles[0..<maxNum]) : tuDouTitles
            
            let tuDouLinks = tuDou.FindAllMovies().map{ $0.link }
            self.movieLinks["TuDou"] = tuDouLinks.count>maxNum ? Array(tuDouLinks[0..<maxNum]) : tuDouLinks
            
            dispatch_async(dispatch_get_main_queue(), {
                self.RefreshTableView()
            });
        }
        taskTuDou.resume()
        
        var urlSohu = NSURL(string: "http://so.tv.sohu.com/mts?wd=" + searchKey!)
        let taskSohu = session.dataTaskWithURL(urlSohu!) {(data, response, error) in
            var sourceContent:String = NSString(data:data!, encoding:NSUTF8StringEncoding)! as String
            var sohu = SohuSite(source: sourceContent)
            let sohuTitles = sohu.FindAllMovies().map{ $0.title }
            self.movieTitles["SoHu"] = sohuTitles.count>maxNum ? Array(sohuTitles[0..<maxNum]) : sohuTitles
            
            let sohuLinks = sohu.FindAllMovies().map{ $0.link }
            self.movieLinks["SoHu"] = sohuLinks.count>maxNum ? Array(sohuLinks[0..<maxNum]) : sohuLinks
            
            dispatch_async(dispatch_get_main_queue(), {
                self.RefreshTableView()
            });
        }
        taskSohu.resume()

    }
    
    func RefreshTableView() {
        self.CurrentTableView.reloadData()
        KVNProgress.dismiss()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "MovieGo")
        {
            var path:NSIndexPath = self.tableView.indexPathForSelectedRow!
            let videoPage = segue.destinationViewController as! VideoDetail
            let targetLinkArray = self.GetTargetArray(path.section, type: "link")
            videoPage.linkUrl = targetLinkArray[path.row]

        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.moviesGroupArray[section]
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
        return movieTitles.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let targetArray = self.GetTargetArray(section, type: "title")
        return targetArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let targetArray = self.GetTargetArray(indexPath.section, type: "title")
        
        let cellIdentifyName: String = "MovieTableViewCell"
        var cell: MovieTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifyName) as! MovieTableViewCell
//        cell.movieTitle?.text = movieTitlesArray[indexPath.section][indexPath.row]
        cell.movieTitle?.text = targetArray[indexPath.row]

        return cell
    }
    
    func GetTargetArray(site: Int, type: String) -> Array<String> {
        var target = Array<String>()
        
        movieTitles.indexForKey("")
        
        switch site {
        case 0:
            if(movieTitles.indexForKey("iQiYi") != nil && movieLinks.indexForKey("iQiYi") != nil) {
                target = ((type == "title") ? movieTitles["iQiYi"] : movieLinks["iQiYi"])!
            }
        case 1:
            if(movieTitles.indexForKey("TuDou") != nil && movieLinks.indexForKey("TuDou") != nil) {
                target = ((type == "title") ? movieTitles["TuDou"] : movieLinks["TuDou"])!
            }
        case 2:
            if(movieTitles.indexForKey("SoHu") != nil && movieLinks.indexForKey("SoHu") != nil) {
                target = ((type == "title") ? movieTitles["SoHu"] : movieLinks["SoHu"])!
            }
        default:
            break
        }
        
        return target
    }
}
