//
//  Sources.swift
//  QuickTargetVideo
//
//  Created by Jason on 15/11/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

//import Foundation
//class SourcesController:  {
//    
//    @IBOutlet weak var searchBar: UISearchBar!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        searchBar.becomeFirstResponder()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        print(searchBar.text)
//        searchBar.resignFirstResponder()
//        
//        let controller = storyboard?.instantiateViewControllerWithIdentifier("VideoDetail") as VideoDetail
//        controller.searchContent = searchBar.text!
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
//}