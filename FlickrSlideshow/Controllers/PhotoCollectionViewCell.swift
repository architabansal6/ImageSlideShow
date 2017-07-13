//
//  PhotoCollectionViewCell.swift
//  FlickrSearch
//
//  Created by Archita Bansal on 6/15/17.
//  Copyright © 2017 archita. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.contentView.layoutIfNeeded()
//    }

}
