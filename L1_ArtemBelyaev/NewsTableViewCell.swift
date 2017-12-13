//
//  PrototypeNewsTableViewCell.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 25.10.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var headerImage: UIImageView!{
        didSet{
            headerImage.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    @IBOutlet weak var headerLbl: UILabel!{
        didSet{
            headerLbl.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    @IBOutlet weak var baseText: UITextView!{
        didSet{
            baseText.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    
    @IBOutlet weak var likeLbl: UILabel!{
        didSet{
            likeLbl.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    
    @IBOutlet weak var repostLbl: UILabel!{
        didSet{
            repostLbl.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    
    @IBOutlet weak var commentsLbl: UILabel!{
        didSet{
            commentsLbl.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    
    @IBOutlet weak var postImage: UIImageView!{
        didSet{
            postImage.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    
}
