//
//  UserStoryTVC.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 18.09.17.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift


class UserStoryTVC: UITableViewController {
    
    //Токен уведомлений
    var notificationToken: NotificationToken?
    //Коллекция друзей
    var friendsRes: Results<Friend>?
    //сервис
    var vkFriendService = VKFriend()
    
    let vkMessageService = VKMessage()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDataOfNewMessage()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Обновление" )
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        
        if checkLogin() {
            pairTableAndRealm()
            self.loadFriend()
        } else {
            performSegue(withIdentifier: "login", sender: self)
        }
    }
    

    
    func updateDataOfNewMessage() {
        let defaults = UserDefaults(suiteName: "group.newsGroup")
        
        vkFriendService.getCountNewFriend { (result) in
            if let count = result {
                defaults?.set(count , forKey: UDConstants.newFriends.rawValue)
            }
        }
        
        vkMessageService.getCountNewMessage { (result) in
            if let count = result {
                defaults?.set(count , forKey: UDConstants.newMessage.rawValue)
            }
        }
        
        
    }
    
    
    
    func checkLogin() -> Bool {
        
        let date = UserDefaults.standard.double(forKey: "date")
        
        if Date().timeIntervalSince1970 - date > 86000 {
            UserDefaults.standard.set(false, forKey: "isLogin")
            
            return false
        } else {
            return true
        }
        
    }
    
    func refresh(_ sender: Any) {
        self.loadFriend()
    }
    
// MARK: TableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsRes?.count ?? 0 //self.friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row: Int = indexPath.row
        
        if let friend = friendsRes?[row] {
        
            cell.textLabel?.text = "\(friend.firstName) \(friend.lastName)"
            
            let data: Data = try! Data(contentsOf: URL(string:  friend.photo)!)
            cell.imageView?.image = UIImage(data: data)
            
            
        }
        

        
        return cell
    }

// MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendPhotos"{
            if let friendPhoto = segue.destination as? FriendPhotoCVC,
                let cell = sender as? UITableViewCell,
                let row = self.tableView.indexPath(for: cell)?.row{
                friendPhoto.friend = friendsRes![row]
            }
        }
    }
    
    @IBAction func unwindLogin(unwindSegue: UIStoryboardSegue){
        pairTableAndRealm()
        self.loadFriend()
    }
    
    
    
//MARK: Network
    func loadFriend() {

        let url = vkFriendService.loadFriend()
        let utilityQueue = DispatchQueue.global(qos: .utility)
        Alamofire.request(url).responseData(queue: utilityQueue){ response in
            
            if let data = response.value{
                let json =  try! JSON(data: data)
                let friends = json["response"].flatMap{Friend(json: $0.1)}
                DispatchQueue.main.async {
                    self.save(friends: friends)
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
//MARK: DataBase
    
    //сохранение данных
    func save(friends array: [Friend]){
        //обработка исключений
        do{
            let realm = try Realm()
            
            let oldFriend = realm.objects(Friend.self)
            
            realm.beginWrite()
            
            realm.delete(oldFriend)
            
            realm.add(array)
            
            try realm.commitWrite()
            
            realm.refresh()
            
        } catch {
            print(error)
        }
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else {
            return
        }
        
        friendsRes = realm.objects(Friend.self)
        notificationToken = friendsRes?.observe{[weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else {return}
            switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(_, let delections, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                    tableView.deleteRows(at: delections.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                
                    tableView.endUpdates()
                    break
                case .error(let error):
                    fatalError("\(error)")
                
            }
        }
        
    }
    


    

}
