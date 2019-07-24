//
//  UploadFinishedViewController.swift
//  CollectionView_Example_Universal
//
//  Created by TalCon on 22/07/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class UploadFinishedViewController: UIViewController {
    @IBOutlet weak var goHomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        goHomeButton.layer.borderWidth = 2.0
        goHomeButton.layer.borderColor = AppColor.buttonBorder.cgColor
        goHomeButton.layer.cornerRadius = 10.0
        goHomeButton.layer.masksToBounds = true
    }
    
    @IBAction func goHomeTapped(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Reset"), object: nil)
        navigationController?.popViewController(animated: true)
    }
}
