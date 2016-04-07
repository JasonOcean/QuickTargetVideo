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
    var img = ""
    
    init(tiltleContent: String, linkContent: String, imgContent: String)
    {
        self.title = tiltleContent
        self.link = linkContent
        self.img = imgContent
    }
}

class RegexHelper
{
    var sourceHtml:NSString = ""
    var bodyPattern = ""
    var titlePattern = ""
    var linkPattern = ""
    var imgPattern = ""
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
            
            if(results.count>0) {
                let p : String = NSString(CString: pText, encoding: NSUTF8StringEncoding) as! String
                
                //Filter both the beginning and end "
                if  isFilterQuote {
                    return (p as NSString).substringWithRange(NSMakeRange(results[0].range.location+1, results[0].range.length-2))
                }
                else {
                    return (p as NSString).substringWithRange(results[0].range)
                }
            }
        }
        catch{}
    
        return ""
    }
    
    //Following is the steps to catch:
    //1. Get [title="***"]
    //2. Get [""] from above string,
    func GetSingleMovieItem(parentText: String, titleP: String?, linkP: String?) -> MovieItem
    {
        self.titlePattern = titleP==nil ? "(title=\"(.+?)\")|(title=\"\")": titleP!
        self.linkPattern = linkP==nil ? "href=[\\s]*?\"(.|\\s)*?\"" : linkP!
        self.imgPattern = "src=\"(.+?)\""
        
        let t:String = self.GetTargetContent(self.titlePattern, pText:parentText, isFilterQuote: false)
        let l:String = self.GetTargetContent(self.linkPattern, pText:parentText,isFilterQuote: false)
        let img:String = self.GetTargetContent(self.imgPattern, pText:parentText,isFilterQuote: false)
        let ll:String = self.GetTargetContent("\"(.|\\s)*?\"", pText:l, isFilterQuote: true).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let item: MovieItem = MovieItem(
            tiltleContent: self.GetTargetContent("[\"'](.+?)[\"']", pText:t, isFilterQuote: true),
            linkContent: ll,
            imgContent: self.GetTargetContent("[\"'](.+?)[\"']", pText:img, isFilterQuote: true)
        )
        
        return item
    }
    
    func FindAllMovies() -> [MovieItem]
    {
        var movies: [MovieItem] = []
        self.bodyTexts = self.GetBodyContent()
        for c in self.bodyTexts{
            let item:MovieItem = self.GetSingleMovieItem(c, titleP: nil, linkP: nil)
            
//            if(item.link != "" && item.link != "###" && item.img != "" && item.title != "") {
            if(item.link != "" && item.link != "###" && item.title != "") {
                movies.append(item)
            }
        }
        
        return movies
    }
}

class iQiYiSite: RegexHelper
{
    init(source: String)
    {
        let bodyPattern: String = "(<div class=\"site-piclist_pic\">[\\s\\S]*?</div>)|(<li class=\"list_item\" [\\s\\S]*?>[\\s\\S]*?</li>)"
        super.init(source: source, patternStr: bodyPattern)
    }
}

class TuDouSite: RegexHelper
{
    init(source: String)
    {
        let bodyPattern: String = "(<div class=\"s_poster\">[\\s\\S]*?<div class=\"s_link\">[\\s\\S]*?</div>)|(<div class=\"v\" data-type=\"tipHandle\">(.|\\s)*?<div class=\"v-link\" (.|\\s)*?>(.|\\s)*?</div>)"
        super.init(source: source, patternStr: bodyPattern)
    }
    
    override func GetSingleMovieItem(parentText: String, titleP: String?, linkP: String?) -> MovieItem {
        let titlePattern : String = "( title=\"(.+?)\")|( _log_title='(.+?)')|( _log_title=\"(.+?)\")"
        let linkPattern: String = "(href=[\\s]*?\"(.|\\s)*?\")|(href=\"(.|\\s)*?\")"
        return super.GetSingleMovieItem(parentText, titleP: titlePattern, linkP: linkPattern)
    }
}

class YouKuSite: RegexHelper
{
    init(source: String)
    {
//        let bodyPattern: String = "(<div class=\"s_poster\">[\\s\\S]*?<div class=\"s_link\">[\\s\\S]*?</div>)"
        let bodyPattern: String = "(<div class=\"s_poster\">[\\s\\S]*?<div class=\"s_link\">[\\s\\S]*?</div>)|(<div class=\"((v)|(v on))\" data-type=\"tipHandle\">[\\s\\S]*?<div class=\"v-link\">[\\s\\S]*?</div>)|(<ul class=\"((v)|(v v_last))\"[\\s\\S]*?</ul>)"
        
//        "(<div class=\"vmidl\">[\\s\\S]*?<li class=\"v-link\">[\\s\\S]*?</div>)"
        
        super.init(source: source, patternStr: bodyPattern)
    }
    
    override func GetSingleMovieItem(parentText: String, titleP: String?, linkP: String?) -> MovieItem {
        let titlePattern : String = "( title=\"(.+?)\")|( _log_title='(.+?)')|( _log_title=\"(.+?)\")"
        let linkPattern: String = "(href=[\\s]*?\"(.|\\s)*?\")|(href=\"(.|\\s)*?\")"
        return super.GetSingleMovieItem(parentText, titleP: titlePattern, linkP: linkPattern)
    }
}

class SohuSite: RegexHelper
{
    init(source: String)
    {
        let bodyPattern: String = "(<div class=\"(ssItem cfix)\">(.|\\s)*?</div>)|(<div class=\"pic170\" >(.|\\s)*?</div>)"
        super.init(source: source, patternStr: bodyPattern)
    }
}

class LetvSite: RegexHelper
{
    init(source: String)
    {
        let bodyPattern: String = "(<div class=\"So-detail Comic-so\" (.|\\s)*?>[\\s\\S]*?<div class=\"so-cont\">[\\s\\S]*?<div>[\\s\\S]*?</div>)|(<div class=\"So-detail Movie-so\" (.|\\s)*?>[\\s\\S]*?<div class=\"so-cont\">[\\s\\S]*?<div>[\\s\\S]*?</div>)|(<div class=\"So-detail Tv-so\" (.|\\s)*?>[\\s\\S]*?<div class=\"so-cont\">[\\s\\S]*?<div>[\\s\\S]*?</div>)"
        
//        let bodyPattern: String = "<div class=\"(So-detail Comic-so)|(So-detail Movie-so)\" (.|\\s)*?>[\\s\\S]*?<div class=\"so-cont\">[\\s\\S]*?<div>[\\s\\S]*?</div>"
        
        super.init(source: source, patternStr: bodyPattern)
    }
    
    override func GetSingleMovieItem(parentText: String, titleP: String?, linkP: String?) -> MovieItem {
        let titlePattern : String = "( title=\"(.+?)\")|( _log_title='(.+?)')|( _log_title=\"(.+?)\")"
        let linkPattern: String = "(href=[\\s]*?\"(.|\\s)*?\")|(href=\"(.|\\s)*?\")"
        return super.GetSingleMovieItem(parentText, titleP: titlePattern, linkP: linkPattern)
    }
}

class PPTVSite: RegexHelper
{
    init(source: String)
    {
        let bodyPattern: String = "(<li class=\"\">[\\s\\S]*? <p class=\"cf\"> [\\s\\S]*?</li>)|(<li class=\"hidden \">[\\s\\S]*?</li>)|(<div class=\"bpic fl\">[\\s\\S]*?</div>)"
        
        super.init(source: source, patternStr: bodyPattern)
    }
}

class FiveSixSite: RegexHelper
{
    init(source: String)
    {
        let bodyPattern: String = "(<div class=\"ssItem cfix\">[\\s\\S]*?<div class=\"pic\">[\\s\\S]*?</div>)|(<div class=\"pic170\" >[\\s\\S]*?</div>)|(<div class=\"star-pic\">[\\s\\S]*?</div>)|(<div class=\"show-pic\">[\\s\\S]*?</div>)"
        
        super.init(source: source, patternStr: bodyPattern)
    }
}

class HotVideosPage: RegexHelper
{
    var HotVideos: [String]?
    
    init(source: String)
    {
        let bodyPattern: String = "<a rseat=\"(.+?)\" class=\"mod_focus-index_item\" (.+?)></a>"
        super.init(source: source, patternStr: bodyPattern)
    }
    
    override func GetSingleMovieItem(parentText: String, titleP: String?, linkP: String?) -> MovieItem {
        let titlePattern : String = "alt=\"(.+?)\""
        let linkPattern: String = "href=[\\s]*?\"(.|\\s)*?\""
        return super.GetSingleMovieItem(parentText, titleP: titlePattern, linkP: linkPattern)
    }
}

class HotVideosPage56: RegexHelper
{
    var HotVideos: [String]?
    
    init(source: String)
    {
        let bodyPattern: String = "<li [\\s\\S]*? fragtype=\"1\">(.|\\s)*?</li>"
        super.init(source: source, patternStr: bodyPattern)
    }
    
    override func GetSingleMovieItem(parentText: String, titleP: String?, linkP: String?) -> MovieItem {
        let titlePattern : String = "alt=\"(.+?)\""
        let linkPattern: String = "href=[\\s]*?\"(.|\\s)*?\""
        return super.GetSingleMovieItem(parentText, titleP: titlePattern, linkP: linkPattern)
    }
}