//
//  NSObject.swift
//  CollectionView_Example_Universal
//
//  Created by TalCon on 22/07/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation

extension NSObject {
    static var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
