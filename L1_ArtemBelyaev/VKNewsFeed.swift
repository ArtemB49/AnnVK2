//
//  VKNewsFeed.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 18.10.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift


class VKNewsFeed {
    
    var token = UserDefaults.standard.string(forKey: "token") ?? nil
    
    var groups:[Group] = []
    
    func generateUrl() -> URL {
        
        var urlCompoments = URLComponents();
        urlCompoments.scheme = "https"
        urlCompoments.host = VKConstans.host.rawValue
        urlCompoments.path = VKConstans.getNewsFeed.rawValue
        urlCompoments.queryItems = [
            URLQueryItem(name: "filters", value: "post,photo,photo_tag, wall_photo"),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "v", value: "5.60")
        ]
        
        return urlCompoments.url!
        
    }
    
    
    func loadNews( url: URL, completion: @escaping ([NewsFeed]?) -> Void){
        
        let parser = NewsParser.instance
        
        //let utilityQueue = DispatchQueue.global(qos: .utility)
        
        Alamofire.request(url).responseData{ response in
            
            if let data = response.value{
                let json = try! JSON(data: data)
                
                var newsArray: [NewsFeed] = []
                
                for item in json["response"]["items"].arrayValue{
                    if let news = parser.getNews(json: item){
                        newsArray.append(news)
                        
                    }
                    
                    
                }
                //print(json["response"]["items"].arrayValue)
                completion(newsArray)
                
            }
        }
        
    }
    
}
