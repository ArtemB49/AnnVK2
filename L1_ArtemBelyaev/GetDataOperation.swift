//
//  GetDataOperation.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 11.12.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import Alamofire

class GetDataOperation: AsyncOperation {
    
    private var request: DataRequest = Alamofire.request("")
    var data: Data?
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()){ [weak self] response in
            self?.data = response.data
            self?.state = .finished
            
        }
    }
    
    init(request: DataRequest){
        self.request = request
    }


}
