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
    var moviesGroupArray = ["iQiYi", "Letv", "YouKu"]
    
    func ResetmoviesArray()
    {
        movieTitlesArray = []
        
        var iQiYi = iQiYiSite(keyword: searchKey!)
        let iQiYiTitles = iQiYi.FindAllMovies().map{ $0.title }
        movieTitlesArray.append(iQiYiTitles)
        
        let iQiYiLinks = iQiYi.FindAllMovies().map{ $0.link }
        movieLinksArray.append(iQiYiLinks)
        
        var letv = LetvSite(keyword: searchKey!)
        let letvTitles = letv.FindAllMovies().map{ $0.title }
        movieTitlesArray.append(letvTitles)
        
        let letvLinks = letv.FindAllMovies().map{ $0.link }
        movieLinksArray.append(letvLinks)
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
        ResetmoviesArray()

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
