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
    
//    func CollectBodyContent()
//    {
//        do
//        {
//            self.myRegex = try! NSRegularExpression(pattern: bodyPattern, options: NSRegularExpressionOptions.CaseInsensitive)
//            
//            let results = myRegex.matchesInString(sourceHtml as String,
//                options: NSMatchingOptions.Anchored,
//                range: NSMakeRange(0, sourceHtml.length))
//            
//            if(results.count>0)
//            {
//                self.bodyText = self.sourceHtml.substringWithRange(results[0].range)
//            }
//        }
//        catch {}
//    }
    
    func GetBodyContent() -> [String]
    {
        
//        do { let regex = try NSRegularExpression(pattern: regex, options: [])
//            let nsString = text as NSString
//            let results = regex.matchesInString(text, options: [], range: NSMakeRange(0, nsString.length))
//            return results.map { nsString.substringWithRange($0.range)} }
//        catch let error as NSError
//        {
//            print("invalid regex: \(error.localizedDescription)")
//            return []
//        }
        
        do
        {
            self.myRegex = try! NSRegularExpression(pattern: bodyPattern, options: NSRegularExpressionOptions.CaseInsensitive)
            
            let results = myRegex.matchesInString(sourceHtml as String,
                options: NSMatchingOptions.Anchored,
                range: NSMakeRange(0, sourceHtml.length))
            
            if(results.count>0)
            {
                return results.map{sourceHtml.substringWithRange($0.range)}
            }
        }
        catch {}
        
        return []
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
    let currentWebView: UIWebView = UIWebView()
    var iQiYiMovies: [String]?
    
    init(keyword: String)
    {
        var source = ""
        var contentUrl: String = "http://so.iqiyi.com/so/q_" + keyword
        contentUrl = contentUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        //var contentUrl = "http://www.baidu.com/"
        
        if let cUrl = NSURL(string: contentUrl) {
            do {
                let ss = try NSString(contentsOfURL: cUrl, encoding: NSUTF8StringEncoding )
                source = ss as String
                
                print(ss.length)
            }
            catch {}
            
//            let request = NSURLRequest(URL: cUrl)
//            currentWebView.loadRequest(request)
//            let htmlcontent = currentWebView.stringByEvaluatingJavaScriptFromString("document.documentElement")
//
//            print(htmlcontent)
        }
        
        let bodyPattern: String = "<h3 class=\"result_title\">{.|\\s}*?</h3>"
        super.init(source: source, patternStr: bodyPattern)

        
    }
    
    func GetSingleMovieItem(parentText: String) -> MovieItem
    {
        self.titlePattern = "<a [\\s\\S]*? title=\"{.|\\s}*?\"[^>]*?>[\\s\\S]*?</a>"
        self.linkPattern = "<a [\\s\\S]*? href=\"{.|\\s}*?\"[^>]*?>[\\s\\S]*?</a>"
        
        
        let t:String = self.GetTargetContent(self.titlePattern, pText:parentText)
        let l:String = self.GetTargetContent(self.linkPattern, pText:parentText )
        let item: MovieItem = MovieItem(tiltleContent: t, linkContent: l)
        
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