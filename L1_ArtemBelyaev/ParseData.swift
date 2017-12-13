//
//  ParseData.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 11.12.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import SwiftyJSON
/*
class ParseData: Operation {
    var outputData: [NewsFeed] = []
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
            let data = getDataOperation.data else { return }
        let json = JSON(data: data)
        let posts: [NewsFeed] = json["response"]["items"].flatMap{
            let id = $0.1["source_id"].intValue
            let title = $0.1["type"].stringValue
            let body = $0.1["post_type"].stringValue
            return PostOP(id: id, title: title, body: body)
            
        }
        
        outputData = posts
    }
}
*/
