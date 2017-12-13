//
//  TodayViewController.swift
//  TodayNews
//
//  Created by Артем Б on 13.12.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    
    @IBOutlet weak var friendCount: UILabel!
    @IBOutlet weak var messagesCount: UILabel!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        let usetDefaults = UserDefaults(suiteName: "group.newsGroup")
        if let mCount = usetDefaults?.integer(forKey: UDConstants.newMessage.rawValue){
            messagesCount.text = String(mCount)
        }
        if let fCount = usetDefaults?.integer(forKey: UDConstants.newFriends.rawValue){
            friendCount.text = String(fCount)
        }
    }
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
