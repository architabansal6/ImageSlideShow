//
//  ImageDownloader.swift
//  FlickrSlideshow
//
//  Created by Archita Bansal on 7/10/17.
//  Copyright © 2017 archita. All rights reserved.
//

import UIKit

import Foundation
import UIKit
class ImageDownload{
    lazy var downloadsInProgress = [Int:Operation]()
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        return queue
    }()
}

class ImageDownloader: Operation {
    
    var imageUrl = String()
    
    init(imageUrl: String) {
        print(imageUrl)
        self.imageUrl = imageUrl
        print(self.imageUrl)
        
    }
    override func main() {
        if self.isCancelled {
            return
        }
        print(self.imageUrl)
        let imageData = NSData.init(contentsOf: URL.init(string: self.imageUrl)!) //make sure your image in this url does exist, otherwise unwrap in a if
        if(imageData == nil)
        {
            //AppSettings.sharedInstance.profileGalleryimagecache.setObject(UIImage(named: "default")!, forKey:imageUrl as AnyObject)
        }
        else
        {
            if self.isCancelled {
                return
            }
            
            if (imageData?.length)! > 0 {
                
                if let image = UIImage(data:imageData! as Data)
                {
                    AppSettings.sharedInstance.profileGalleryimagecache.setObject(image, forKey:imageUrl as AnyObject)
                }
                else
                {
                    AppSettings.sharedInstance.profileGalleryimagecache.setObject(UIImage(named: "default")!, forKey:imageUrl as AnyObject)
                }
            }
            else
            {
                AppSettings.sharedInstance.profileGalleryimagecache.setObject(UIImage(named: "default")!, forKey:imageUrl as AnyObject)
            }
        }
    }
}
