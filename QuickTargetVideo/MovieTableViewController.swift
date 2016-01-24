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
    var movieTitlesArray = Array<Array<String>>()
    var movieLinksArray = Array<Array<String>>()
    var moviesGroupArray = ["iQiYi", "TuDou", "Sohu"]
    
    @IBOutlet var CurrentTableView: UITableView!
   
    func ResetmoviesArray()
    {
        ///Show loading animation
        let para: NSDictionary = [KVNProgressViewParameterStatus: "Loading...",
            KVNProgressViewParameterBackgroundType: 1,
            KVNProgressViewParameterFullScreen: true]
        KVNProgress.showWithParameters(para as [NSObject : AnyObject])
        
        movieTitlesArray = []
        let maxNum : Int = 3
    
        var session = NSURLSession.sharedSession()
        
        var urliQiYi = NSURL(string: "http://so.iqiyi.com/so/q_" + searchKey!)
        let taskiQiYi = session.dataTaskWithURL(urliQiYi!) {(data, response, error) in
            var sourceContent:String = NSString(data:data!, encoding:NSUTF8StringEncoding)! as String
            var iQiYi = iQiYiSite(source: sourceContent)
                        let iQiYiTitles = iQiYi.FindAllMovies().map{ $0.title }
                        self.movieTitlesArray.append(
                            iQiYiTitles.count>maxNum ? Array(iQiYiTitles[0..<maxNum]) : iQiYiTitles
                        )
        
                        let iQiYiLinks = iQiYi.FindAllMovies().map{ $0.link }
                        self.movieLinksArray.append(
                            iQiYiLinks.count>maxNum ? Array(iQiYiLinks[0..<maxNum]) : iQiYiLinks
                        )
            
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
            self.movieTitlesArray.append(
                tuDouTitles.count>maxNum ? Array(tuDouTitles[0..<maxNum]) : tuDouTitles
            )
            
            let tuDouLinks = tuDou.FindAllMovies().map{ $0.link }
            self.movieLinksArray.append(
                tuDouLinks.count>maxNum ? Array(tuDouLinks[0..<maxNum]) : tuDouLinks
            )
            
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
            self.movieTitlesArray.append(
                sohuTitles.count>maxNum ? Array(sohuTitles[0..<maxNum]) : sohuTitles
            )
            
            let sohuLinks = sohu.FindAllMovies().map{ $0.link }
            self.movieLinksArray.append(
                sohuLinks.count>maxNum ? Array(sohuLinks[0..<maxNum]) : sohuLinks
            )
            
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
            videoPage.linkUrl = movieLinksArray[path.section][path.row]
            presentViewController(videoPage, animated: true, completion: nil)
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
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return movieTitlesArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return movieTitlesArray[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifyName: String = "MovieTableViewCell"
        var cell: MovieTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifyName) as! MovieTableViewCell
        cell.movieTitle?.text = movieTitlesArray[indexPath.section][indexPath.row]
        
        return cell
    }
}
