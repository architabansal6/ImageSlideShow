//
//  AppSettings.swift
//  NewsAggregator
//
//  Created by Archita Bansal on 13/03/16.
//  Copyright © 2016 Archita Bansal. All rights reserved.
//

import UIKit

class AppSettings{
    
    static var sharedInstance = AppSettings()
    static let lightGreyForBackground = UIColor(red: 0.969, green: 0.973, blue: 0.976, alpha: 1) 
    
    var paper = "TOI"
    var profileGalleryimagecache = NSCache<AnyObject, AnyObject>()

}
