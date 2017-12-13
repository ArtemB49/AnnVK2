//
//  Post.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 10.12.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation

class Post {
    
    var ownerID: Int
    var ownerPhoto: String
    var ownerName: String
    var text: String
    var attachments: [Attachment]?
    var likes: Int
    var reposts: Int
    var commentCount: Int
    
    
    init(ownerID: Int, ownerPhoto: String, ownerName: String, text: String,
         attachments: [Attachment]?,
         likes: Int, reposts: Int, comments: Int) {
        self.ownerID = ownerID
        self.ownerPhoto = ownerPhoto
        self.ownerName = ownerName
        self.text = text
        self.attachments = attachments
        self.likes = likes
        self.reposts = reposts
        self.commentCount = comments
    }
    
}
