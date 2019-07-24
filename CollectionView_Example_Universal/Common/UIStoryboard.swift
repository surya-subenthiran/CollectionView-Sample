//
//  UIStoryboard.swift
//  CollectionView_Example_Universal
//
//  Created by TalCon on 22/07/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard.init(name: Storyboard.main.rawValue, bundle: .main)
    }
}
