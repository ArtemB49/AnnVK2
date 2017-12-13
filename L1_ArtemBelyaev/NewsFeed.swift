//
//  NewsFeeed.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 18.10.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewsFeed {
    
    let serviceGroup = VKGroups()
    
    var title = ""
    var text = ""
    var type = ""
    var userID = 0
    var sourceID = 0
    var ownerPhoto = ""
    var offers: (like: Int, repost: Int, comments: Int) = (0,0,0)
    var items: [Attachment]?
    
    
    init(json: JSON){
        self.title = json["title"].stringValue
        self.text = json["text"].stringValue
        self.type = json["type"].stringValue
        self.sourceID = json["source_id"].intValue
        self.ownerPhoto = ""
        self.items = nil

    }
    
    init(by wallPhoto: WallPhoto){
        self.title = wallPhoto.ownerName
        self.ownerPhoto = wallPhoto.ownerPhoto
        self.text = "bob"
        self.type = "wall_photo"
        self.items = wallPhoto.photoArray
        self.userID = wallPhoto.ownerID
        self.sourceID = 0
        self.offers = (wallPhoto.likes, wallPhoto.reposts, wallPhoto.commentCount)
        
    }
    
    init(by post: Post){
        self.title = post.ownerName
        self.ownerPhoto = post.ownerPhoto
        self.text = post.text
        self.type = "post"
        self.items = post.attachments
        self.userID = post.ownerID
        self.sourceID = 0
        self.offers = (post.likes, post.reposts, post.commentCount)
    }
    
}
