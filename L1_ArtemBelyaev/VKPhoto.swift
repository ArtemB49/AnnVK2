//
//  VKPhoto.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 11.10.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class VKPhoto {
    
    var token = UserDefaults.standard.string(forKey: "token") ?? nil
    
    func loadPhotos(of friend: Friend) -> URL  {
        
        var urlCompoments = URLComponents();
        urlCompoments.scheme = "https"
        urlCompoments.host = VKConstans.host.rawValue
        urlCompoments.path = "/method/photos.getAll"
        urlCompoments.queryItems = [
            URLQueryItem(name: "owner_id", value: String(friend.id)),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        
        
        return urlCompoments.url!
    }
}
