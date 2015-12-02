//
//  DataViewController.swift
//  QuickTargetVideo
//
//  Created by Jason on 15/11/3.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

import UIKit

class VideoSourceController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.becomeFirstResponder()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print(searchBar.text, terminator: "")
        searchBar.resignFirstResponder()
        
        //let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let movieListController = storyboard?.instantiateViewControllerWithIdentifier("MovieList") as! MovieTableViewController
        //controller.searchContent = searchBar.text!
        //self.navigationController?.pushViewController(controller, animated: true)
        
        movieListController.searchKey = searchBar.text
        presentViewController(movieListController, animated: true, completion: nil)
        
//        let controller = storyboard?.instantiateViewControllerWithIdentifier("VideoDetail") as VideoDetail
//        controller.searchContent = searchBar.text!
//        self.navigationController?.pushViewController(controller, animated: true)
    }
}

