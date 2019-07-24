//
//  Utility.swift
//  CollectionView_Example_Universal
//
//  Created by Surya Subendran on 21/07/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class Utility: NSObject {
    static func thumbnail(from image: UIImage) -> UIImage {
        let imageData = image.pngData()!
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 300] as CFDictionary
        let source = CGImageSourceCreateWithData(imageData as CFData, nil)!
        let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
        let thumbnail = UIImage(cgImage: imageReference)
        return thumbnail
    }
}
