//
//  VKGroups.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 11.10.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class VKGroups{
    
    var token = UserDefaults.standard.string(forKey: "token") ?? nil
    
    func loadGroup() -> URL  {
        
        var urlCompoments = URLComponents();
        urlCompoments.scheme = "https"
        urlCompoments.host = VKConstans.host.rawValue
        urlCompoments.path = "/method/groups.get"
        urlCompoments.queryItems = [
            
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "count", value: "100"),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        return urlCompoments.url!
    }
    
    func searc(value: String) -> URL  {
        
        var urlCompoments = URLComponents();
        urlCompoments.scheme = "https"
        urlCompoments.host = VKConstans.host.rawValue
        urlCompoments.path = "/method/groups.search"
        urlCompoments.queryItems = [
            
            URLQueryItem(name: "q", value: value),
            URLQueryItem(name: "count", value: "100"),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        return urlCompoments.url!
    }
    
    func getGroup(by id: Int, completion: @escaping (Group) -> Void){
        
        var urlCompoments = URLComponents();
        urlCompoments.scheme = "https"
        urlCompoments.host = VKConstans.host.rawValue
        urlCompoments.path = "/method/groups.getById"
        urlCompoments.queryItems = [
            
            URLQueryItem(name: "group_id", value: String(id)),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.69")
        ]
        
        let url = urlCompoments.url!
        
        Alamofire.request(url).responseData{ response in
            
            print("22")
            
            if let data = response.value{
                let json =  try! JSON(data: data)
                print(json)
                
                let group = Group(json: json["response"])
                
                //let groups = json["response"].flatMap{Group(json: $0.1)}
                
                completion(group)
            }
        }
    }
}
    /*
    func getGroup(by id: Int) -> Group?{
        
        var urlCompoments = URLComponents();
        urlCompoments.scheme = "https"
        urlCompoments.host = VKConstans.host.rawValue
        urlCompoments.path = "/method/groups.getById"
        urlCompoments.queryItems = [
            
            URLQueryItem(name: "group_id", value: String(id)),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let group: Group = nil
        
        Alamofire.request(urlCompoments.url!).responseJSON { (json) in
            if let json = json as JSON{
                group = Group(json: json["response"])
            }
        }
        
       // let group: Group? = executeRequest(with: urlCompoments.url!)
        
        /*let myQueue = DispatchQueue(label: "bib")
        myQueue.sync {
            executeRequest(with: urlCompoments.url!, completionClosure: { (response) in
                group = response
            })
        }*/
        
        
        return group
    }

 
 */

/*
func executeRequest(with url: URL) -> Group {
    let configuration = URLSessionConfiguration.default
    //наша собственная сессия
    let session =  URLSession(configuration: configuration)
    //указываем метод
     //создаем запрос
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    //задача для запуска
    let tesk = session.dataTask(with: request) { (data, response, error) in
        //в замыкании данные полученные от сервера мы преобразуем в json
        let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! JSON
        //выводим в консоль
        let group: Group = Group(json: json!)
        
        return group
        
    }
    //запускаем задачу
    tesk.resume()
}
*/

extension VKGroups {
    func getRealmGroup(by id: Int) -> Group {

        guard let realm = try? Realm() else {
            return Group()
        }
        let group = realm.object(ofType: Group.self, forPrimaryKey: id)

        if let group = group {
            print(group.name)
            return group
        }


        return group!
    }
}
