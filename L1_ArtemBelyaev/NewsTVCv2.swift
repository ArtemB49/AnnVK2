//
//  NewsTVCv2.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 11.12.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import UIKit
import Alamofire

class NewsTVCv2: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let opq = OperationQueue()
        let url = newsService.generateUrl()
        let request = Alamofire.request(url)
        let getDataOperation = GetDataOperation(request: request)
        opq.addOperation(getDataOperation)
        
        let parseData = NewsParserV2()
        parseData.addDependency(getDataOperation)
        opq.addOperation(parseData)
        
        /*let reloadTC = ReloadTableController(controller: self)
        reloadTC.addDependency(parseData)
        OperationQueue.main.addOperation(reloadTC)
 */
        

    }
    
    var posts: [NewsFeed] = []
    let newsService = VKNewsFeed()


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = posts[indexPath.row].title

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }


}
