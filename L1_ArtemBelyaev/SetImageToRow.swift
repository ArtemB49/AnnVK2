//
//  SetImageToRow.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 12.12.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import UIKit

class SetImageToRow: Operation {
    
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: NewsTableViewCell?
    
    init(cell: NewsTableViewCell, indexPath: IndexPath, tableView: UITableView) {
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
    }
    
    override func main() {
        
        guard let tableView = tableView,
            let cell = cell,
            let getCacheImage = dependencies[0] as? GetCacheImage,
            let image = getCacheImage.outputImage else { return }
        
        if let newIndexPath = tableView.indexPath(for: cell),
            newIndexPath == indexPath {
            cell.postImage.image = image
        } else if tableView.indexPath(for: cell) == nil {
            cell.postImage.image = image
        }
    }
}
