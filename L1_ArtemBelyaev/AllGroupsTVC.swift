//
//  AllGroupsTVC.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 21.09.17.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AllGroupsTVC: UITableViewController, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serch.delegate = self
    }
    
    @IBOutlet weak var serch: UISearchBar!{
        didSet{
            loadPhoto(url: service.searc(value: serch.text!))
        }
    }
    
    var service = VKGroups()
    
    var groups: [Group] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    func loadPhoto( url: URL){
        
        Alamofire.request(url).responseData{ response in
            
            if let data = response.value{
                let json =  try! JSON(data: data)
                
                
                self.groups = json["response"]["items"].flatMap{Group(json: $0.1)}
                
                
                print(json)
                
                
                
            }
        }
    }
    
    
//MARK: UISearcBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadPhoto(url: service.searc(value: searchBar.text!))
    }

//MARK: UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let group = groups[indexPath.row]
        
        cell.textLabel?.text = group.name
        
        let data: Data = try! Data(contentsOf: URL(string: group.size_50)!)
        cell.imageView?.image = UIImage(data: data)
        
        return cell
    }
    

}
