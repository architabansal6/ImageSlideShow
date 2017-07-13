//
//  NetworkHelper.swift
//  FlickrSlideshow
//
//  Created by Archita Bansal on 7/7/17.
//  Copyright © 2017 archita. All rights reserved.
//

import UIKit

class NetworkHelper: NSObject {

    static let sharedInstance = NetworkHelper()
    typealias SuccessHandler = (_ data:AnyObject) -> Void
    typealias ErrorHandler = (_ error:AnyObject) -> Void

    
    func getData(_ urlString:String, params:[String:AnyObject]?, onSuccess:SuccessHandler?, onFail:ErrorHandler?){
        let url = URL.init(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if(params != nil){
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
            }
            catch{
                
            }
        }
        requestData(request, onSuccess: onSuccess, onFail: onFail)
    }
    
    func requestData(_ request:URLRequest,onSuccess:SuccessHandler?,onFail:ErrorHandler?){
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if error == nil{
                let res = response as! HTTPURLResponse!
                print(res!.statusCode)
                print(NSString(data: data!,encoding: String.Encoding.utf8.rawValue) ?? "No Body")
                switch res!.statusCode{
                case 200 :
                    fallthrough
                    
                case 201 :
                    fallthrough
                case 204 :
                    if data != nil {
                        do{
                            if let jsonResult = try NSString(data: data!,encoding: String.Encoding.utf8.rawValue) as? NSString{
                                onSuccess!(NSString(data: data!,encoding: String.Encoding.utf8.rawValue) ?? "No Body")
                                return
                            }
                        }
                        catch{
                            onSuccess!(data as AnyObject)
                            return
                        }
                    }
                    onFail!(data! as AnyObject)
                    return
                    
                case 401 :
                    if data != nil {
                        do{
                            
                            if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary{
                            }
                        }
                        catch{
                            onFail!(data! as AnyObject)
                        }
                    }
                    onFail!("Invalid Credentials" as AnyObject)
                    return
                    
                default:
                    onFail!("Internal Server error" as AnyObject)
                    return
                }
            }
            else{
                onFail!(error! as AnyObject)
                
            }
        })
        task.resume()
    }
    

    
}
