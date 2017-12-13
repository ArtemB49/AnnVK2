//
//  ProrotypeNewsTVC.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 25.10.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import UIKit
import Alamofire

class NewsTVC: UITableViewController {
    
    var news:[NewsFeed] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    let service = VKNewsFeed()
    
    let emptyImage = "http://bipbap.ru/wp-content/uploads/2017/05/VOLKI-krasivye-i-ochen-umnye-zhivotnye.jpg"

    override func viewDidLoad() {
        super.viewDidLoad()
        let opq = OperationQueue()
        let url = service.generateUrl()
        let request = Alamofire.request(url)
        let getDataOperation = GetDataOperation(request: request)
        opq.addOperation(getDataOperation)
        
        let parseData = NewsParserV2()
        parseData.addDependency(getDataOperation)
        opq.addOperation(parseData)
        
        let reloadTC = ReloadTableController(controller: self)
        reloadTC.addDependency(parseData)
        OperationQueue.main.addOperation(reloadTC)
        
        
        
        
        // загрузка новостей
        /*
        service.loadNews(url: service.generateUrl(), completion: { [weak self] result in
            if let result = result{
                self?.news = result
            }
        })
         */

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "protoCell", for: indexPath) as! NewsTableViewCell
        
        let newsItem = news[indexPath.row]
        
        if newsItem.text.count > 100{
            let index = newsItem.text.index(newsItem.text.startIndex, offsetBy: 100)
            cell.baseText.text = newsItem.text.substring(to: index)
        } else {
            cell.baseText.text = newsItem.text
        }

        let srcPhoto = newsItem.ownerPhoto
        
        if (srcPhoto != ""){
            let data: Data = try! Data(contentsOf: URL(string: srcPhoto)!)
            cell.headerImage.image = UIImage(data: data)
        }
        
        if let items = newsItem.items {
            let postPhotoUrl = (items[0].value != "") ? items[0].value : emptyImage
         
            let getCacheImage = GetCacheImage(url:postPhotoUrl)
            let setImageToRow = SetImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
            setImageToRow.addDependency(getCacheImage)
            queue.addOperation(getCacheImage)
            OperationQueue.main.addOperation(setImageToRow)
        }
        
        //изображение поста
        
        
        
        cell.headerLbl.text = newsItem.title
        
        cell.likeLbl.text = "❤️ \(newsItem.offers.like)"
        cell.repostLbl.text = "📢 \(newsItem.offers.repost)"
        cell.commentsLbl.text = "💬 \(newsItem.offers.comments)"
        
        return cell
    }
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()


}
