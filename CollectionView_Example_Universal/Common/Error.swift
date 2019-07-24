//
//  Error.swift
//  CollectionView_Example_Universal
//
//  Created by TalCon on 22/07/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noNetwork
}

enum ValidationError: Error {
    case imageNotCaptured
    case commentNotEntered
}
