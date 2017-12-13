//
//  News.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 25.10.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import SwiftyJSON

class News {
    
    let serviceGroup = VKGroups()
    
    var baseText: String
    var image: String
    var sourceID: Int
    var postType: String
    var group: Group
    
    init(json: JSON) {
        self.baseText = json["text"].stringValue
        self.postType = json["type"].stringValue
        self.sourceID = json["source_id"].intValue
        self.image = ""
        self.group = self.sourceID < 0 ? serviceGroup.getRealmGroup(by: abs(self.sourceID)) : Group()
    }
    
    init(text: String, image: String, sourceID: Int, postType: String) {
        self.baseText = text
        self.image = ""
        self.sourceID = sourceID
        self.postType = postType
        self.group = Group()
    }
    
    
}

