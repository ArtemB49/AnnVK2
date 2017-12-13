//
//  FriendService.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 05.10.17.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import Alamofire

class VKLogin {
    
    typealias loadFriendDataCompletion = () -> Void
    
    
    func executeAutorization() -> URLRequest {

        var urlComp = URLComponents()
        urlComp.scheme = "https"
        urlComp.host = "oauth.vk.com"
        urlComp.path = "/authorize"
        urlComp.queryItems = [
            URLQueryItem(name: "client_id", value: "6195868"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "9355263"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
                
        let urlRequest = URLRequest(url: urlComp.url!)
        
        return urlRequest
        
    }
    
}

/* //        конф по умолчанию
 let configuration = URLSessionConfiguration.default
 //        заголовки alomafife
 configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
 
 //        менеджер сессии
 let sessionManager = SessionManager(configuration: configuration)
 
 //        параметры запроса
 let param: Parameters = [
 " q":  " München,DE",
 " appid":  "b1b15e88fa797225412429c1c50c122a1"
 ]*/

/*Alamofire.request(urlRequest).responseJSON{ response in
 if let value = response.value {
 print(value)
 }
 }*/

