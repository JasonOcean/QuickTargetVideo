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
    var moviesArray = Array<Array<String>>()
    var moviesTitleArray = ["iQiYi", "YouKu", "Letv"]
    
    func GetMoviesArray() -> Array<Array<String>>
    {
//        moviesArray = [
//            ["Runing iQiYi!", "I'm coming", "Hurry up", "Wait a moment, traffic jam..."],
//            ["Running YouKu!", "Hi boss!", "Any idea to be as BAT?", "Hi this is MaYun, what did you say? "],
//            ["Running Letv!", "Letv movie...", "Letv cloudy...", "Letv sport...", "..."]
//        ]
        
        moviesArray = []
        
        var iQiYi = iQiYiSite(keyword: searchKey!)
        let iQiYiTitles = iQiYi.FindAllMovies().map{ $0.title }
        moviesArray.append(iQiYiTitles)
        
        return moviesArray
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "MovieGo")
        {
            var path:NSIndexPath = self.tableView.indexPathForSelectedRow!
            let controller = segue.destinationViewController as! VideoDetail
            controller.searchContent = moviesArray[path.section][path.row]
            presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.moviesTitleArray[section]
    }
    
    override func viewDidLoad() {
        GetMoviesArray()

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
        return moviesArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return moviesArray[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifyName: String = "MovieTableViewCell"
        var cell: MovieTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifyName) as! MovieTableViewCell
        cell.movieTitle?.text = moviesArray[indexPath.section][indexPath.row]
        
        return cell
    }
}
