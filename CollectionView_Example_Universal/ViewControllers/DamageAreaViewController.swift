//
//  DamageAreaViewController.swift
//  CollectionView_Example_Universal
//
//  Created by Surya Subendran on 21/07/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class DamageAreaViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var commentValidationImageView: UIImageView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    private let reuseIdentifier = DamageAreaCollectionCell.nameOfClass
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 10.0)
    private let damageArea = DamageArea()
    private let itemsPerRow: CGFloat = 2
    private var commentValidation: Validation = .none {
        didSet {
            switch commentValidation {
            case .none:
                commentValidationImageView.image = nil
                commentValidationImageView.isHidden = true
            case .success:
                commentValidationImageView.image = AppImage.validationSuccess
                commentValidationImageView.isHidden = false
            case .fail:
                commentValidationImageView.image = AppImage.validationFail
                commentValidationImageView.isHidden = false
            }
        }
    }
    private var selectedIndexPath: IndexPath? = nil
    private var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.reloadData()
        registerForNotifications()
    }
    
    deinit {
        deRegisterForNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.reloadData()
        commentTextView.layer.cornerRadius = 5.0
        commentTextView.layer.masksToBounds = true
        nextButton.layer.borderWidth = 2.0
        nextButton.layer.borderColor = AppColor.buttonBorder.cgColor
        nextButton.layer.cornerRadius = 10.0
        nextButton.layer.masksToBounds = true
        
        let row = CGFloat(damageArea.photos.count) / itemsPerRow
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightRequired = (row * widthPerItem) + sectionInsets.top * (row + 1)
        collectionHeightConstraint.constant = heightRequired
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if commentTextView.isFirstResponder {
            commentTextView.resignFirstResponder()
        }
        
        var proceedNext = true
        if commentTextView.text.isEmpty {
            self.commentValidation = .fail
            proceedNext = false
        }
        
        if !damageArea.validate() {
            proceedNext = false
        }
        collectionView.reloadData()
        
        if proceedNext {
            let storyboard = UIStoryboard.main
            let uploadFinishedViewController = storyboard.instantiateViewController(withIdentifier: UploadFinishedViewController.nameOfClass) as! UploadFinishedViewController
            navigationController?.pushViewController(uploadFinishedViewController, animated: true)
        }
    }
}

extension DamageAreaViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension DamageAreaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return damageArea.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath) as! DamageAreaCollectionCell
        let photo = damageArea.photo(for: indexPath)
        cell.viewData = DamageAreaCollectionCell.ViewData(damageAreaPhoto: photo)
        return cell
    }
}

extension DamageAreaViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let photo = damageArea.photo(for: indexPath)
        if photo.thumbnail != nil {
            askForRemovingPhoto()
        } else {
            askForGettingPhoto()
        }
    }
}

extension DamageAreaViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.commentValidation = .fail
        } else {
            self.commentValidation = .success
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension DamageAreaViewController {
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reset), name: Notification.Name(rawValue: "Reset"), object: nil)

    }
    
    func deRegisterForNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "Reset"), object: nil)

    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc func reset(notification:NSNotification) {
        commentTextView.text = nil
        commentValidation = .none
        damageArea.reload()
        collectionView.reloadData()
    }
}

extension DamageAreaViewController {
    func askForGettingPhoto() {
        guard let selectedIndexPath = self.selectedIndexPath else {
            return
        }
        
        guard let cell = collectionView.cellForItem(at: selectedIndexPath) else {
            return
        }

        let alert = UIAlertController(title: "Choose", message: "Choose below option to take photo", preferredStyle: .actionSheet)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = cell
            popoverController.sourceRect = cell.bounds
        }
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.captureUsingCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            self.captureUsingGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            self.selectedIndexPath = nil
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func askForRemovingPhoto() {
        guard let selectedIndexPath = self.selectedIndexPath else {
            return
        }
        
        guard let cell = collectionView.cellForItem(at: selectedIndexPath) else {
            return
        }
        
        let alert = UIAlertController(title: "Warning", message: "Do you want to remove photo", preferredStyle: .actionSheet)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = cell
            popoverController.sourceRect = cell.bounds
        }
        
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive , handler:{ (UIAlertAction)in
            self.removePhoto()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            self.selectedIndexPath = nil
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension DamageAreaViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func captureUsingCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func captureUsingGallery() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func removePhoto() {
        guard let selectedIndexPath = self.selectedIndexPath else {
            return
        }
        
        let photo = damageArea.photo(for: selectedIndexPath)
        photo.thumbnail = nil
        photo.largeImage = nil
        photo.validation = .none
        collectionView.reloadData()
        
        self.selectedIndexPath = nil
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        guard let selectedIndexPath = self.selectedIndexPath else {
            return
        }
        
        let photo = damageArea.photo(for: selectedIndexPath)
        photo.largeImage = selectedImage
        photo.thumbnail = Utility.thumbnail(from: selectedImage)
        photo.validation = .success
        collectionView.reloadData()
        
        self.selectedIndexPath = nil
    }
}
