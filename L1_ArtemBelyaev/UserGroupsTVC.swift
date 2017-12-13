//
//  FriendGroupsTVC.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 21.09.17.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

class UserGroupsTVC: UITableViewController {
    
    var service = VKGroups()
    
    //Токен уведомлений
    var notificationToken: NotificationToken?
    
    var groups: Results<Group>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Обновление" )
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        pairTableAndRealm()
        self.loadGroup()
        
    }
    
    func loadGroup(){
        
        let url = service.loadGroup()
        
        Alamofire.request(url).responseData{ response in
            
            if let data = response.value{
                let json =  try! JSON(data: data)
                
                let groups = json["response"]["items"].flatMap{Group(json: $0.1)}
                
                self.save(group: groups)
                
                self.scro {
                    
                }
                
                
            }
        }
        
    }
    
    func scro(closu: () -> Void) {}
    
    func refresh(_ sender: Any) {
        self.loadGroup()
    }
    
    
//MARK: UITableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let groups = self.groups else {
            return cell
        }
        
        let group = groups[indexPath.row]
        
        cell.textLabel?.text = group.name
        
        let data: Data = try! Data(contentsOf: URL(string: group.size_50)!)
        cell.imageView?.image = UIImage(data: data)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //если была нажата кнопка удалить
        if editingStyle == .delete {
            
            
            //и удаляем строку из таблицы
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue){
        
/*        if segue.identifier == "addGroup"{
            
            let allGroupController = segue.source as! AllGroupsTVC
            if let indexPath = allGroupController.tableView.indexPathForSelectedRow{
              let group = allGroupController.allGroups[indexPath.row]
                
                
                for item in userGroups {
                    if item.name == group.name {
                        return
                    }
                }
                
                    userGroups.append(group)
                    
                    tableView.reloadData()
                
                
            }
        } */
    }
    
//MARK: DataBase
    
    //сохранение данных
    func save(group array: [Group]){
        //обработка исключений
        do{
            let realm = try Realm()
            
            let oldGroup = realm.objects(Group.self)
            
            realm.beginWrite()
            
            realm.delete(oldGroup)
            
            realm.add(array)
            
            try realm.commitWrite()
            
        } catch {
            print(error)
        }
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else {
            return
        }
        
        self.groups = realm.objects(Group.self)
        notificationToken = self.groups?.observe{[weak self] (changes: RealmCollectionChange) in
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
