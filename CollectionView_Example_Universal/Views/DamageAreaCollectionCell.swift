//
//  DamageAreaCollectionCell.swift
//  CollectionView_Example_Universal
//
//  Created by TalCon on 23/07/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class DamageAreaCollectionCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var validationImageView: UIImageView!
    
    struct ViewData {
        let title: String
        let validation: Validation
        var thumbnail: UIImage
    }
    
    var viewData: ViewData? {
        didSet {
            guard let viewData = self.viewData else {
                return
            }
            titleLabel.text = viewData.title
            thumbnailImageView.image = viewData.thumbnail
            switch viewData.validation {
            case .none:
                validationImageView.image = nil
                validationImageView.isHidden = true
            case .success:
                validationImageView.image = AppImage.validationSuccess
                validationImageView.isHidden = false
            case .fail:
                validationImageView.image = AppImage.validationFail
                validationImageView.isHidden = false
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        thumbnailImageView.image = nil
        validationImageView.image = nil
        validationImageView.isHidden = true
    }
}

extension DamageAreaCollectionCell.ViewData {
    init(damageAreaPhoto: DamageAreaPhoto) {
        self.title = damageAreaPhoto.title
        if let thumbnail = damageAreaPhoto.thumbnail {
            self.thumbnail = thumbnail
        } else {
            self.thumbnail = AppImage.noImage
        }
        self.validation = damageAreaPhoto.validation
    }
}
