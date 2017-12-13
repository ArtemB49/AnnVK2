//
//  PostOP.swift
//  L1_ArtemBelyaev
//
//  Created by Артем Б on 11.12.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import UIKit

class GetCacheImage: Operation {
    
    init(url: String) {
        self.url = url
    }
    
    private let url: String
    
    private let cacheLifeTime: TimeInterval = 3600
    
    var outputImage: UIImage?
    
    private static let pathName: String = {
        
        let pathName = "images"
        
        guard let cacheDirectiry = FileManager.default.urls(for: .cachesDirectory,
                                       in: .userDomainMask).first else { return pathName }
        
        let urlInner = cacheDirectiry.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: urlInner.path) {
            try? FileManager.default.createDirectory(at: urlInner, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private lazy var filePath: String? = {
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hasheName = String(describing: self.url.hashValue)
        return cachesDirectory.appendingPathComponent(GetCacheImage.pathName + "/" + hasheName).path
    }()
    
    
    
    override func main() {
        
        guard filePath != nil && !isCancelled else { return }
        
        if getImageFromCache() { return }
        guard !isCancelled else { return }
        
        if !downloadImage() { return }
        guard !isCancelled else { return }
        
        saveImageToCache()
    }
    
    private func getImageFromCache() -> Bool {
        guard let fileName = filePath,
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return false }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName) else { return false }
        
        self.outputImage = image
        return true
        
    }
    
    private func downloadImage() -> Bool {
        
        guard let url = URL(string: url),
            let data = try? Data.init(contentsOf: url),
            let image = UIImage(data: data) else { return false }
        
        self.outputImage = image
        return true
    }
    
    private func saveImageToCache(){
        guard let fileName = filePath,
            let  image = outputImage else { return }
                let data = UIImagePNGRepresentation(image)
                FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
        
    }
    
}
