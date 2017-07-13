//
//  PhotosViewController.swift
//  FlickrSearch
//
//  Created by Archita Bansal on 6/15/17.
//  Copyright © 2017 archita. All rights reserved.
//

import UIKit

class PhotosViewController: UICollectionViewController {

    fileprivate var photos = [NSDictionary]()
    fileprivate let reuseIdentifier = "photoCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 30, left: 10 , bottom: 10, right: 10)
    var shouldMakeRequest = false
    var photoURL = [String]()
    let pendingDownloads = ImageDownload()
    var count = 0
    var timer = Timer()
    let batchSize = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shouldMakeRequest = true
        self.configNavigationBar()
        self.prepareDataSource()
        
    }
    
    func configNavigationBar(){
        self.navigationItem.title = "Flickr SlideShow"
        self.navigationController?.navigationBar.backgroundColor = AppSettings.lightGreyForBackground
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
    }
    
    func prepareDataSource(){
        FlickrHelper.flickrHelperSharedInstance.getPhotosList(success: { (data) in
            DispatchQueue.main.async(execute: {
                self.photoURL = data as! [String]
                self.count = self.batchSize
                self.collectionView?.reloadData()
                self.getFirstBatch()
            })
        }) { (error) in
            print(error)
        }
    }
    
    func slideShow(){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.showNextBatch), userInfo: nil, repeats: true)
    }
    
    func showNextBatch(){
        //increment count
        self.count = self.count + batchSize
        self.collectionView?.reloadData()
        self.collectionView?.scrollToItem(at: IndexPath(row:self.count - 1,section:0), at: .bottom, animated: true)
        self.getNextBatch()
    }
    
    func getNextBatch(){
        for item in self.count...self.count + batchSize{
            self.startDownload(url: self.photoURL[item], index: item)
        }
    }
    
    func getFirstBatch(){
        for item in 0...self.count{
            self.startDownload(url: self.photoURL[item], index: item)
        }
    }
    
    func startDownload(url:String,index:Int){
        if let _ = pendingDownloads.downloadsInProgress[index] {
            return
        }
        let downloader = ImageDownloader(imageUrl: url)
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async(execute: {
                if self.count == self.batchSize{
                    self.collectionView?.reloadData()
                    self.slideShow()
                    self.getNextBatch()
                }else{
                    
                }
            })
        }
        pendingDownloads.downloadsInProgress[index] = downloader
        pendingDownloads.downloadQueue.addOperation(downloader)
    }
}

extension PhotosViewController{
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        // Configure the cell
        
        cell.backgroundColor = UIColor.clear
        
        if let imageFromCache = (AppSettings.sharedInstance.profileGalleryimagecache.object(forKey: photoURL[indexPath.row] as AnyObject) as? UIImage){
            cell.imageView.image = imageFromCache
        }else{
            cell.imageView.image = UIImage(named: "default")
        }
        
        return cell
    }

}

extension PhotosViewController:UICollectionViewDelegateFlowLayout{
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenWidth = self.view.frame.width
        let screenHeight = self.view.frame.height
        let width = screenWidth - 20
        let height = (screenHeight - 70)/3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
}
