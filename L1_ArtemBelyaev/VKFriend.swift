//
//  VKFriend.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 16.10.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class VKFriend {
    
    
    
    func loadFriend() -> URL {
        
        var urlCompoments = URLComponents();
        urlCompoments.scheme = "https"
        urlCompoments.host = VKConstans.host.rawValue
        urlCompoments.path = VKConstans.getFriends.rawValue
        urlCompoments.queryItems = [
            URLQueryItem(name: "user_id", value: "17790124"),
            URLQueryItem(name: "order", value: "hints"),
            URLQueryItem(name: "count", value: "100"),
            URLQueryItem(name: "fields", value: "photo_50")
        ]
        
        return urlCompoments.url!
        
    }
    
    func getFriend(by id: Int) -> Friend {
        
        var urlCompoments = URLComponents();
        urlCompoments.scheme = "https"
        urlCompoments.host = VKConstans.host.rawValue
        urlCompoments.path = VKConstans.getUser.rawValue
        urlCompoments.queryItems = [
            URLQueryItem(name: "user_ids", value: String(id)),
            URLQueryItem(name: "version", value: "5.69"),
            URLQueryItem(name: "fields", value: "photo_50")
        ]
        var friend = Friend()
        Alamofire.request(urlCompoments).responseData { response in
            if let data = response.value {
                let json = try! JSON(data: data)
                let friendJSON = json["response"]
                friend = Friend(json: friendJSON)
            }
        }
        
        return friend
    }
    
    func getCountNewFriend(completion: @escaping (Int?) -> Void){
        var urlCompoments = URLComponents();
        urlCompoments.scheme = "https"
        urlCompoments.host = VKConstans.host.rawValue
        urlCompoments.path = VKConstans.getCountNewUser.rawValue
        urlCompoments.queryItems = [
            URLQueryItem(name: "out", value: "0"),
            URLQueryItem(name: "version", value: "5.69")
        ]
        
        Alamofire.request(urlCompoments.url!).responseData(queue: DispatchQueue.global(qos: .utility)) { (response) in
            if let data = response.value {
                let json = try! JSON(data: data)
                let count = json["response"]["count"].intValue
                completion(count)
            }
        }
    }
    
    
    
}
