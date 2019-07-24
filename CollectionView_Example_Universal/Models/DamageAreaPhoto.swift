//
//  DamageAreaPhoto.swift
//  CollectionView_Example_Universal
//
//  Created by TalCon on 23/07/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class DamageAreaPhoto: NSObject {
    let photoID: String
    let title: String
    let isMandatory: Bool
    var thumbnail: UIImage?
    var largeImage: UIImage?
    var validation: Validation
    
    init(photoID: String, title: String, isMandatory: Bool) {
        self.photoID = photoID
        self.title = title
        self.isMandatory = isMandatory
        self.validation = .none
        super.init()
    }
    
    convenience init?(dictionary: [String: Any]) {
        guard let title = dictionary["title"] as? String,
            let isMandatory = dictionary["isMandatory"] as? Bool else {
            return nil
        }
        self.init(photoID: UUID().uuidString,
                  title: title,
                  isMandatory: isMandatory)
    }
}

extension DamageAreaPhoto {
    func validate() -> Bool {
        guard isMandatory else {
            return true
        }
        let validated = (thumbnail != nil && largeImage != nil)
        if validated {
            self.validation = .success
        } else {
            self.validation = .fail
        }
        return validated
    }
}
