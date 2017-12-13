//
//  PostPhoto.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 15.11.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation


class WallPhoto {
    
    var ownerID: Int
    var ownerPhoto: String
    var ownerName: String
    var photoArray: [Attachment]?
    var likes: Int
    var reposts: Int
    var commentCount: Int
    
    
    init(ownerID: Int, ownerPhoto: String, ownerName: String,
         photoArray: [Attachment]?, likes: Int, reposts: Int, comments: Int) {
        self.ownerID = ownerID
        self.ownerPhoto = ownerPhoto
        self.ownerName = ownerName
        self.photoArray = photoArray
        self.likes = likes
        self.reposts = reposts
        self.commentCount = comments
    }
    
}
