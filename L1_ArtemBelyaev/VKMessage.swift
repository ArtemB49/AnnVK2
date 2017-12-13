//
//  VKMessage.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 13.12.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class VKMessage {
    
    func getCountNewMessage(completion: @escaping (Int?) -> Void){
        var urlCompoments = URLComponents();
        urlCompoments.scheme = "https"
        urlCompoments.host = VKConstans.host.rawValue
        urlCompoments.path = VKConstans.getMessages.rawValue
        urlCompoments.queryItems = [
            URLQueryItem(name: "count", value: "50"),
            URLQueryItem(name: "version", value: "5.69"),
            URLQueryItem(name: "preview_length", value: "5")
        ]
        
        Alamofire.request(urlCompoments.url!).responseData(queue: DispatchQueue.global(qos: .utility)) { (response) in
            if let data = response.value {
                let json = try! JSON(data: data)
                let array = json["response"].arrayValue
                var count = 0
                for item in array {
                    if item["read_state"].intValue == 1 {
                        count = count + 1
                    }
                }
                
                completion(count)
                
            }
        }
    }
}
