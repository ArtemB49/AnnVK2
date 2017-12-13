//
//  Photo.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 02.10.17.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Photo: Object {
    
    @objc dynamic var photoID: Int = 0
    @objc dynamic var size_130: String = ""
    @objc dynamic var ownerID: String = ""

    
    convenience init(json: JSON) {
        self.init()
        self.photoID = json["id"].intValue
        self.size_130 = json["photo_130"].stringValue
        self.ownerID = json["owner_id"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "photoID"
    }
}
