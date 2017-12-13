//
//  ReloadTableController.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 11.12.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation

class ReloadTableController: Operation {
    var controller: NewsTVC
    
    init(controller: NewsTVC) {
        self.controller = controller
    }
    
    override func main() {
        guard let parseData = dependencies.first as? NewsParserV2 else {
            return
        }
        controller.news = parseData.outputData
        controller.tableView.reloadData()
    }
}
