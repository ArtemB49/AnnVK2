//
//  VK.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 24.09.17.
//  Copyright © 2017 Артем Б. All rights reserved.
//


import UIKit
import SwiftyVK


class MySwiftyVK:  VKDelegate {
    
    
    func vkWillAuthorize() -> Set<VK.Scope> {
        var vkSet: Set<VK.Scope> = Set<VK.Scope>()
        vkSet.insert(.friends)
        return vkSet
    }
    
     func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        //Called when the user is log in.
        //Here you can start to send requests to the API.
        //Init
        print("Has been autorized")
//        Друзья пользователя
        
    }
    
    func loadFriend() {
        var friendArray:[Friend] = [];
        VK.API.Friends.get([VK.Arg.order: "name", VK.Arg.offset: "100", VK.Arg.fields:"photo_50"]).send(
            onSuccess: {response in
                
                let items = response["items"].arrayValue
                print(items)
                
                for item in items {
//                    let friend = Friend(id: item["id"].intValue, firstName: item["first_name"].stringValue, lastName: item["last_name"].stringValue, photo: item["photo_50"].stringValue)
//                    friendArray.append(friend)
                }
        },
            onError: {error in print(error)}
        )
        
    }
    
    
    
    func newfunc() {
        //           Фотографии пользователя
        VK.API.Photos.get([VK.Arg.ownerId: "38376069", VK.Arg.albumId: "wall"]).send(
            onSuccess: {response in print(response)},
            onError: {error in print(error)}
        )
        //        Павел Дуров
        VK.API.Users.get([VK.Arg.userId : "1"]).send(
            onSuccess: {response in print(response)},
            onError: {error in print(error)}
        )
        //        Группы
        VK.API.Groups.get([VK.Arg.extended: "1"]).send(
            onSuccess: {response in print(response)},
            onError: {error in print(error)}
        )
        //        Поиск по группам
        VK.API.Groups.search([VK.Arg.q: "Auto"]).send(
            onSuccess: {response in print(response)},
            onError: {error in print(error)}
        )
    }
    
     func vkAutorizationFailedWith(error: AuthError) {
        //Called when SwiftyVK could not authorize. To let the application know that something went wrong.
    }
    
     func vkDidUnauthorize() {
        //Called when user is log out.
    }
    
    func vkShouldUseTokenPath() -> String? {
        // ---DEPRECATED. TOKEN NOW STORED IN KEYCHAIN---
        //Called when SwiftyVK need know where a token is located.
        return nil//Path to save/read token or nil if should save token to UserDefaults
    }
    
     func vkWillPresentView() -> UIViewController {
        //Only for iOS!
        //Called when need to display a view from SwiftyVK.
        //UIViewController that should present authorization view controller
        return ViewController()
    }
    

    

}



