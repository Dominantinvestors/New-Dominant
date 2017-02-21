//
//  DMCompanyCollectionCell.swift
//  Dominant Investors
//
//  Created by Nekit on 18.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//


import Foundation
import UIKit

class DMCompanyCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var companyImage : UIImageView!
    @IBOutlet weak var companyNameLabel : UILabel!
    @IBOutlet weak var activity : UIActivityIndicatorView!
    
    override func awakeFromNib() {
        activity.hidesWhenStopped = true
        activity.startAnimating()
        super.awakeFromNib()
    }
    
    open func setupWith(model : DMCompanyModel) {
        if (model.companyPictureURL == nil) {
            DMAPIService.sharedInstance.downloadCompanyImageWith(ID: model.id) { (image) in
                DispatchQueue.main.async {
                    model.companyPictureURL = image
                    self.companyImage.image = image
                    self.activity.stopAnimating()
                }
            }
        } else {
            self.companyImage.image = model.companyPictureURL
            self.activity.stopAnimating()
        }
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

