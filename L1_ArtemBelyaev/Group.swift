//
//  Group.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 21.09.17.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Group: Object {
    
    @objc dynamic var groupID: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var size_50: String = ""

    
    convenience init(json: JSON) {
        self.init()
        self.groupID = json["id"].intValue
        self.name = json["name"].stringValue
        self.size_50 = json["photo_50"].stringValue
    }
    
    override static func primaryKey() -> String?{
        return "groupID"
    }
}
