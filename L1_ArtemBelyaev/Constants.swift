//
//  API.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 24.09.17.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation

class Constants {
    static let APP_ID = "6195868"
    static var TOKEN = ""
}

enum VKConstans: String{
    case app_id = "6195868"
    case host = "api.vk.com"
    case getFriends = "/method/friends.get"
    case getNewsFeed = "/method/newsfeed.get"
    case getUser = "/method/users.get"
    case getCountNewUser = "/method/friends.getRequests"
    case getMessages = "/method/messages.get"
}

enum UDConstants: String {
    case newMessage = "message"
    case newFriends = "friends"
}
