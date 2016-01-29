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
            self.moviesGroupArray.append("iQiYi")
            self.movieItemsDictionary["iQiYi"] = Array(iQiYi.FindAllMovies().prefix(self.TopItemsCount))
            
            dispatch_async(dispatch_get_main_queue(), {
                    self.RefreshTableView()
                });
        }
        taskiQiYi.resume()
        
        let urlTuDou = NSURL(string: "http://www.soku.com/t/nisearch.do?kw=" + searchKey!)
        let taskTuDou = session.dataTaskWithURL(urlTuDou!) {(data, response, error) in
            let sourceContent:String = NSString(data:data!, encoding:NSUTF8StringEncoding)! as String
            let tuDou = TuDouSite(source: sourceContent)
            self.moviesGroupArray.append("TuDou")
            self.movieItemsDictionary["TuDou"] = Array(tuDou.FindAllMovies().prefix(self.TopItemsCount))
            
            dispatch_async(dispatch_get_main_queue(), {
                self.RefreshTableView()
            });
        }
        taskTuDou.resume()
        
        let urlSohu = NSURL(string: "http://so.tv.sohu.com/mts?wd=" + searchKey!)
        let taskSohu = session.dataTaskWithURL(urlSohu!) {(data, response, error) in
            let sourceContent:String = NSString(data:data!, encoding:NSUTF8StringEncoding)! as String
            let sohu = SohuSite(source: sourceContent)
            self.moviesGroupArray.append("SoHu")
            self.movieItemsDictionary["SoHu"] = Array(sohu.FindAllMovies().prefix(self.TopItemsCount))
            
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
            if(self.moviesGroupArray[path.section] == "TuDou" && (link as NSString).substringToIndex(1)=="/") {
                videoPage.linkUrl = "http://soku.com/" + link
            }
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

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifyName: String = "MovieTableViewCell"
        let cell: MovieTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifyName) as! MovieTableViewCell
        
        let sectionName = self.moviesGroupArray[indexPath.section]
        let movieItem = self.movieItemsDictionary[sectionName]?[indexPath.row]
        cell.movieTitle?.text = movieItem?.title
        
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
