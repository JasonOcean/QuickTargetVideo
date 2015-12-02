//
//  RegexHelper.swift
//  QuickTargetVideo
//
//  Created by Jason on 15/11/25.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

import Foundation

class MovieItem
{
    var title: NSString = ""
    var link: NSString = ""
}

class RegexHelper
{
    var sourceHtml:NSString = ""
    var bodyPattern: String = ""
    var titlePattern = ""
    var linkPattern = ""
    var bodyText = ""
    var myRegex: NSRegularExpression
    
    init(source: String, patternStr: String)
    {
        self.sourceHtml = source
        self.bodyPattern = patternStr

        myRegex = try! NSRegularExpression(pattern: bodyPattern, options: NSRegularExpressionOptions.CaseInsensitive)
    }
    
    func SetSourceHtml(source: String)
    {
        self.sourceHtml = source
    }
    
    func SetbodyPattern(regPattern: String)
    {
        self.bodyPattern = regPattern
    }
    
    func SetBodyContent()
    {
        do
        {
            self.myRegex = try! NSRegularExpression(pattern: bodyPattern, options: NSRegularExpressionOptions.CaseInsensitive)
            
            let results = myRegex.matchesInString(sourceHtml as String,
                options: NSMatchingOptions.Anchored,
                range: NSMakeRange(0, sourceHtml.length))
            
            if(results.count>0)
            {
                self.bodyText = self.sourceHtml.substringWithRange(results[0].range)
            }
        }
        catch {}
    }
    
    func GetTargetContent(myPattern: String, pText: String) -> String
    {
        do
        {
            self.myRegex = try! NSRegularExpression(pattern: myPattern, options: NSRegularExpressionOptions.CaseInsensitive)
        
            let results = myRegex.matchesInString(pText,
                options: NSMatchingOptions.Anchored,
                range: NSMakeRange(0, (pText as NSString).length))
        
            if(results.count>0)
            {
                return (pText as NSString).substringWithRange(results[0].range)
            }
        }
        catch{}
    
        return ""
    }
}
    
class iQiYiSite: RegexHelper
{
    var iQiYiMovies: [String]?
    
    init(source: String)
    {
        let bodyPattern: String = "<h3 class=\"result_title\">{.|\\s}*?</h3>"
        super.init(source: source, patternStr: bodyPattern)
    }
    
    func GetMovieItem(parentText: String) -> MovieItem
    {
        self.titlePattern = ""
        self.linkPattern = ""
        
        let item : MovieItem = MovieItem()
        item.title = self.GetTargetContent(self.titlePattern, pText:parentText)
        item.link = self.GetTargetContent(self.linkPattern, pText:parentText )
        
        return item
    }
    
//    func FindAllMovies()
//    {
////        let movies = self.GetTargetContent()
////        var parent : String
////        
////        if(movies.count>0)
////        {
////            parent = movies[0]
////        }
////        
////        self.SetRegexPattern("")
//        
//    }
}