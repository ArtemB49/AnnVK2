//
//  Friend.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 20.09.17.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Friend: Object { 
    
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var photo: String = ""
    
    let photos = List<Photo>()
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["user_id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photo = json["photo_50"].stringValue
    }
    
    override static func primaryKey() -> String?{
        return "id"
    }
}
