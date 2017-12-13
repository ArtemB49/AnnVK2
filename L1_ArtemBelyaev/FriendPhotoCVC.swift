//
//  UserPhotoCVC.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 20.09.17.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class FriendPhotoCVC: UICollectionViewController {
    
    var service = VKPhoto()
    
    //Токен уведомлений
    var notificationToken: NotificationToken?
    
    var photoRes: List<Photo>? = List(){
        didSet{
            print("List--------------------")
        }
    }
    
    var friend: Friend = Friend()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
        self.loadPhoto(url: service.loadPhotos(of: friend))
        self.pairTableAndRealm()
    }
    
//MARK: Network
    
    func loadPhoto( url: URL){
        
        let utilityQueue = DispatchQueue.global(qos: .utility)
        var photos: [Photo] = [];
        
        Alamofire.request(url).responseData(queue: utilityQueue){ response in
            
            if let data = response.value{
                let json =  try! JSON(data: data)
                
                photos = json["response"]["items"].flatMap{Photo(json: $0.1)}
                DispatchQueue.main.async{
                    self.save(photo: photos, by: self.friend)
                }
                
            }
        }
    }
    
    
    
//MARK: CollectionViewDelegate
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoRes?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! PhotoCollectionViewCell
        
        let row = indexPath.row
        
        let photo = photoRes?[row].size_130
        
        let data: Data = try! Data(contentsOf: URL(string: photo!)!)

        item.photo?.image = UIImage(data: data)
        
        return item
    }
    
    
//MARK: DataBase
    
    //сохранение данных
    func save(photo array: [Photo], by friend: Friend){
        //обработка исключений
        do{
            let realm = try Realm()
            
            guard let friend = realm.object(ofType: Friend.self, forPrimaryKey: friend.id) else { return }
            
            let oldPhoto = friend.photos
            
            realm.beginWrite()
            
            realm.delete(oldPhoto)
            
            friend.photos.append(objectsIn: array)
            
            try realm.commitWrite()
            
            realm.refresh()
            
        } catch {
            print(error)
        }
        
    }
    
    var friendID: Int = 0
    
    func pairTableAndRealm() {
        guard let realm = try? Realm(),
            let friend = realm.object(ofType: Friend.self, forPrimaryKey: self.friend.id) else {
            return
        }
        
        self.photoRes = friend.photos
        
        notificationToken = self.photoRes?.observe{[weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else {return}
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let delections, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0)}))
                    collectionView.deleteItems(at: delections.map({ IndexPath(row: $0, section: 0)}))
                    collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0)}))
                
                }, completion: nil)
            case .error(let error):
                fatalError("\(error)")
                
            }
        }
        
    }
}
