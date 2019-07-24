//
//  DamageArea.swift
//  CollectionView_Example_Universal
//
//  Created by TalCon on 23/07/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class DamageArea: NSObject {
    var photos: [DamageAreaPhoto]
    
    var defaultPhotos: [[String: Any]] = [
        [
            "title": "Front Side",
            "isMandatory": true
        ],
        [
            "title": "Back Side",
            "isMandatory": true
        ],
        [
            "title": "Left Side",
            "isMandatory": true
        ],
        [
            "title": "Right Side",
            "isMandatory": true
        ]
    ]
    
    override init() {
        photos = []
        super.init()
        
        reload()
    }
    
    func reload() {
        photos.removeAll()
        for photoDict in defaultPhotos {
            if let photo = DamageAreaPhoto(dictionary: photoDict) {
                photos.append(photo)
            }
        }
    }
}

extension DamageArea {
    func photo(for indexPath: IndexPath) -> DamageAreaPhoto {
        return photos[indexPath.row]
    }
}

extension DamageArea {
    func validate() -> Bool {
        var validated = true
        for photo in photos {
            if !photo.validate() {
                validated = false
            }
        }
        return validated
    }
}
