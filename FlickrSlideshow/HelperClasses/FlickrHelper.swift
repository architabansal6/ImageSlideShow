//
//  FlickrHelper.swift
//  FlickrSlideshow
//
//  Created by Archita Bansal on 7/5/17.
//  Copyright © 2017 archita. All rights reserved.
//

import UIKit

class FlickrHelper: NSObject {
   
    static let flickrHelperSharedInstance = FlickrHelper()
    
    typealias SuccessHandler = (_ data:AnyObject) -> Void
    typealias ErrorHandler = (_ error:AnyObject) -> Void
    
     //get photos API call
    func getPhotosList(success:(SuccessHandler)? = nil,fail:(ErrorHandler)? = nil){
        
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=d98f34e2210534e37332a2bb0ab18887&format=json&extras=url_n"
        
        NetworkHelper.sharedInstance.getData(urlString, params: nil, onSuccess: { (data) in
            let str = String(describing: data)
            
            let start = str.index(str.startIndex, offsetBy: 14)
            
            let end = str.index(str.endIndex, offsetBy: -1)
            
            let range = start..<end
            
            let dataDict =  str.substring(with: range)
            
            let json = self.convertStringToDictionary(dataDict)!
            print(json)
            let photosDict = json["photos"] as! NSDictionary
            print(photosDict)
            var photoURLArray = [String]()
            let photos : [NSDictionary] = photosDict.value(forKey: "photo") as! [NSDictionary]
            for photo in (photos){
                photoURLArray.append(photo.value(forKey: "url_n")! as! String)
            }
            print(photoURLArray)
            success!(photoURLArray as AnyObject)
            
        }) { (error) in
            print(error)
            fail!(error)
        }
    }
    
        
    func convertStringToDictionary(_ text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

}
