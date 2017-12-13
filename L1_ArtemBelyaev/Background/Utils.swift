//
//  Utils.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 12.12.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation

struct Utils {
    
    let fetchCitiesWeatherGroup = DispatchGroup()
    var timer: DispatchSourceTimer?
    var lastUpdate: Date? {
        get{
            return UserDefaults.standard.object(forKey: "Last Update") as? Date
        }
        
        set{
            UserDefaults.standard.setValue(Date(), forKey: "Last Update")
        }
    }
}
