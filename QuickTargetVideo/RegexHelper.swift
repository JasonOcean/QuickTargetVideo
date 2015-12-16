//
//  RegexHelper.swift
//  QuickTargetVideo
//
//  Created by Jason on 15/11/25.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

import Foundation
import UIKit

class MovieItem
{
    var title = ""
    var link = ""
    
    init(tiltleContent: String, linkContent: String)
    {
        self.title = tiltleContent
        self.link = linkContent
    }
}

class RegexHelper
{
    var sourceHtml:NSString = ""
    var bodyPattern = ""
    var titlePattern = ""
    var linkPattern = ""
    var bodyTexts:[String] = []
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
    
    func GetBodyContent() -> [String]
    {
        do
        {
            self.myRegex = try! NSRegularExpression(pattern: bodyPattern, options: NSRegularExpressionOptions.CaseInsensitive)
            
            let results = myRegex.matchesInString(sourceHtml as String,
                options: NSMatchingOptions.WithTransparentBounds,
                range: NSMakeRange(0, sourceHtml.length))
            
            if(results.count>0)
            {
                return results.map{sourceHtml.substringWithRange($0.range)}
            }
        }
        catch {}
        
        return []
    }
    
    func GetTargetContent(myPattern: String, pText: String, isFilterQuote: Bool) -> String
    {
        do
        {
            self.myRegex = try! NSRegularExpression(pattern: myPattern, options: NSRegularExpressionOptions.CaseInsensitive)
        
            let results = myRegex.matchesInString(pText,
                options: NSMatchingOptions.WithoutAnchoringBounds,
                range: NSMakeRange(0, (pText as NSString).length))
            
            if(results.count>0)
            {                
                //Filter both the beginning and end "
                if  isFilterQuote {
                    return (pText as NSString).substringWithRange(NSMakeRange(results[0].range.location+1, results[0].range.length-2))
                }
                else {
                    return (pText as NSString).substringWithRange(results[0].range)
                }
            }
        }
        catch{}
    
        return ""
    }
    
    //Following is the steps to catch:
    //1. Get [title="***"]
    //2. Get [""] from above string,
    func GetSingleMovieItem(parentText: String) -> MovieItem
    {
        self.titlePattern = "title=\"(.+?)\""
        self.linkPattern = "href=[\\s]*?\"(.|\\s)*?\""
        
        let t:String = self.GetTargetContent(self.titlePattern, pText:parentText, isFilterQuote: false)
        let l:String = self.GetTargetContent(self.linkPattern, pText:parentText,isFilterQuote: false)
        let ll:String = self.GetTargetContent("\"(.|\\s)*?\"", pText:l, isFilterQuote: true).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let item: MovieItem = MovieItem(
            tiltleContent: self.GetTargetContent("\"(.+?)\"", pText:t, isFilterQuote: true),
            linkContent: ll
        )
        
        return item
    }
    
    func FindAllMovies() -> [MovieItem]
    {
        var movies: [MovieItem] = []
        self.bodyTexts = self.GetBodyContent()
        for c in self.bodyTexts{
            movies.append(self.GetSingleMovieItem(c))
        }
        
        return movies
    }
}

class LetvSite: RegexHelper
{
    var letvMovies: [String]?
    
    init(keyword: String)
    {
        var source = ""
        var contentUrl: String = "http://so.letv.com/s?wd=" + keyword
        contentUrl = contentUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        if let cUrl = NSURL(string: contentUrl) {
            do {
                let abc = try NSString(contentsOfURL: cUrl, encoding:NSUTF8StringEncoding)
                source = abc.stringByReplacingOccurrencesOfString("\\", withString: "")
            }
            catch {}
        }
        
        let bodyPattern: String = "<div class=\"So-detail (?!(super_temp|Ent-so))[\\s\\S]*?\">[\\s\\S]*?</div>"
        super.init(source: source, patternStr: bodyPattern)
    }
}

class iQiYiSite: RegexHelper
{
    var iQiYiMovies: [String]?
    
    init(keyword: String)
    {
        var source = ""
        var contentUrl: String = "http://so.iqiyi.com/so/q_" + keyword
        contentUrl = contentUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        if let cUrl = NSURL(string: contentUrl) {
            do {
                let abc = try NSString(contentsOfURL: cUrl, encoding:NSUTF8StringEncoding)
                source = abc.stringByReplacingOccurrencesOfString("\\", withString: "")
            }
            catch {}
        }
        
        let bodyPattern: String = "<h3 class=\"result_title\">[\\s\\S]*?</h3>"
        super.init(source: source, patternStr: bodyPattern)
    }
}