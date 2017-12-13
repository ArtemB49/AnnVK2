//
//  NewsParser.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 12.11.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

enum PostType:String {
    case Post = "post"
    case WallPhoto = "wall_photo"
    
}

class NewsParser {
    
    static let instance = NewsParser()
    
    private init(){}
    
    let friendService = VKFriend()
    let groupService = VKGroups()
    
    let emptyImage = "http://bipbap.ru/wp-content/uploads/2017/05/VOLKI-krasivye-i-ochen-umnye-zhivotnye.jpg"
    
    
    
    
    
    func getNews(json: JSON) -> NewsFeed? {
        let postType = json["type"].stringValue
        
        switch postType {
        case "wall_photo":
            let wallPhoto = self.createPhotoPost(by: json)
            let newsFeed = NewsFeed(by: wallPhoto)
            return newsFeed
        case "post":
            let post = self.createPost(by: json)
            let newsFeed = NewsFeed(by: post)
            return newsFeed
        default:
            print("bob")
            return nil
        }

    }
    
    
    // посты типа wall photo
    func createPhotoPost(by json: JSON) -> WallPhoto{
        let items = json["photos"]["items"].arrayValue
        
        var imageArray: [Attachment] = []
        
        for item in items {
            imageArray.append(Attachment(type: "photo", value: item["photo_807"].stringValue))
        }
        
        let ownerData = getOwnerData(ownerID: json["source_id"].intValue)
        
        
        let wallPhoto = WallPhoto(ownerID: json["source_id"].intValue,
                                  ownerPhoto: ownerData.photo,
                                  ownerName: ownerData.name,
                                  photoArray: imageArray,
                                  likes: json["likes"]["count"].intValue,
                                  reposts: json["reposts"]["count"].intValue,
                                  comments: json["comments"]["count"].intValue)
        
        return wallPhoto
        
        
    }
    
    // посты типа post
    
    func createPost(by json: JSON) ->  Post{
        let attachmentsJSON = json["attachments"].arrayValue
        
        let attachments: [Attachment]? = createAttachments(json: attachmentsJSON)
        
       
        
        let ownerData = getOwnerData(ownerID: json["source_id"].intValue)
        
        let post = Post(ownerID: json["source_id"].intValue,
                        ownerPhoto: ownerData.photo,
                        ownerName: ownerData.name,
                        text: json["text"].stringValue,
                        attachments: attachments ?? nil,
                        likes: json["likes"]["count"].intValue,
                        reposts: json["reposts"]["count"].intValue,
                        comments: json["comments"]["count"].intValue)
        
        return post
    }
    
    func getOwnerData(ownerID: Int) -> (name:String, photo:String) {
        
        let result: (String, String) = ("bob", emptyImage)
        if (ownerID > 0){

            // Друг

            if let friend = getFriend(by: ownerID){
               return ("\(friend.firstName) \(friend.lastName)", friend.photo)
            } else {
                return result
            }
            
            
            
        } else {

            // Группа
            
            if let group = getGroup(by: abs(ownerID)){
                return (group.name, group.size_50)
            } else {
                return result
            }
        }
    }
   
    
    
    
//    получить друга
    
    func getFriend(by id: Int) -> Friend? {
        do {
            let realm = try Realm()
            return realm.object(ofType: Friend.self, forPrimaryKey: id)
        } catch {
            print(error)
            return nil
        }
        
    }
    
//    получить группу
    func getGroup(by id: Int) -> Group? {
        do {
            let realm = try Realm()
            return realm.object(ofType: Group.self, forPrimaryKey: id)
        } catch {
            print(error)
            return nil
        }
    }
    
//    партинг прикрепленных материалов к посту
    
    func createAttachments(json array: [JSON]) -> [Attachment]? {
        var result:[Attachment] = []
        for item in array {
            switch (item["type"].stringValue) {
            case "video":
                result.append(Attachment(type: "video", value: item["video"]["photo_320"].stringValue))
            case "photo":
                result.append(Attachment(type: "photo", value: item["photo"]["photo_130"].stringValue))
            default:
                result.append(Attachment(type: "other", value: emptyImage))
            }
        }
        return (result.isEmpty) ? nil : result
    }
    
}
