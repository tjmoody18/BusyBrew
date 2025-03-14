//
//  ShopReviewViewController.swift
//  BusyBrew
//
//  Created by Grace Pan on 3/11/25.
//

import UIKit
import PhotosUI

class ShopReviewViewController: UIViewController, PHPickerViewControllerDelegate {
    
    let pageTitle = UILabel()
    let photoTitle = UILabel()
    let uploadButton = UIButton(type: .system)
    let imagePicker = UIImagePickerController()
    let commentTitle = UILabel()
    let commentField = UITextField()
    let submitButton = UIButton(type: .system)
    let seperator = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        view.backgroundColor = background3
        titleSection()
        reviewSection()
        seperatorSection()
        photoSection()
        commentSection()
        submitSection()
    }
    
    func titleSection() {
        pageTitle.text = "Write a Review"
        pageTitle.textAlignment = .left
        pageTitle.textColor = .black
        self.view.addSubview(pageTitle)
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        pageTitle.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        NSLayoutConstraint.activate([
            pageTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 95),
            pageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
    }
    
    func reviewSection() {
        let wifiTitle = createReviewTitles(name: "Wifi Quality")
        let wifiStarRating = createStarRatings()
        let cleanTitle = createReviewTitles(name: "Cleanliness")
        let cleanStarRating = createStarRatings()
        let outletTitle = createReviewTitles(name: "Outlet Availability")
        let outletStarRating = createStarRatings()
        
        let reviewTitles = [wifiTitle, cleanTitle, outletTitle]
        let reviewStarRatings = [wifiStarRating, cleanStarRating, outletStarRating]
        
        var y = 110
        for i in 0...2 {
            NSLayoutConstraint.activate([
                reviewTitles[i].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(y)),
                reviewTitles[i].leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
                reviewStarRatings[i].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(y + 35)),
                reviewStarRatings[i].leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40)
            ])
            y += 90
        }
    }
    
    func createReviewTitles(name: String) -> UILabel{
        let title = UILabel()
        title.text = name
        title.textColor = background1
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(title)
        return title
    }
    
    func seperatorSection(){
        seperator.backgroundColor = .gray
        seperator.layer.cornerRadius = 1
        seperator.layer.masksToBounds = true
        seperator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(seperator)
        NSLayoutConstraint.activate([
            seperator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 375),
            seperator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            seperator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
                seperator.heightAnchor.constraint(equalToConstant: 1)
        ])    }
    
    func createStarRatings() -> UIStackView {
        let stars = UIStackView()
        stars.axis = .horizontal
        stars.spacing = 10
        stars.alignment = .leading
        stars.translatesAutoresizingMaskIntoConstraints = false
        for i in 1...5 {
            let star = UIButton(type: .system)
            star.tag = i
            star.setImage(UIImage(systemName: "star"), for: .normal)
            star.tintColor = .yellow
            stars.addArrangedSubview(star)
        }
        view.addSubview(stars)
        return stars
    }
    
    func photoSection() {
        
        photoTitle.text = "Photos"
        photoTitle.textColor = background1
        photoTitle.textAlignment = .left
        photoTitle.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        self.view.addSubview(photoTitle)
        photoTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 400),
            photoTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40)
        ])
        
        uploadButton.setTitle("upload", for: .normal)
        uploadButton.backgroundColor = background1Light
        uploadButton.contentHorizontalAlignment = .left
        uploadButton.setTitleColor(.white, for: .normal)
        uploadButton.layer.cornerRadius = 7
        uploadButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30)
        uploadButton.configuration = buttonConfiguration
        self.view.addSubview(uploadButton)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uploadButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 450),
            uploadButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40)
        ])
        uploadButton.addTarget( self, action: #selector(takeMedia), for: .touchUpInside)
    }
    
    func commentSection() {
        commentTitle.text = "Comments"
        commentTitle.textColor = background1
        commentTitle.textAlignment = .left
        commentTitle.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        self.view.addSubview(commentTitle)
        commentTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 525),
            commentTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40)
        ])
        
        commentField.borderStyle = .roundedRect
        commentField.textAlignment = .left
        self.view.addSubview(commentField)
        commentField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            commentField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 575),
            commentField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            commentField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            commentField.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func submitSection() {
        submitButton.setTitle("submit", for: .normal)
        submitButton.backgroundColor = background2
        submitButton.contentHorizontalAlignment = .center
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 7
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 154, bottom: 10, trailing: 154)
        submitButton.configuration = buttonConfiguration
        self.view.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 765),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    @objc func takeMedia() {
        let controller = UIAlertController(title:"Media Controller", message: "Add media", preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title:"Take New Photo", style: .default) {_ in self.openCamera()})
        controller.addAction(UIAlertAction(title:"Choose Existing", style: .default) {_ in self.openLibrary()})
        present(controller, animated: true)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            print("don't have access")
            let controller = UIAlertController(title: "No have access to camera", message: "Please allow access in settings", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            controller.addAction(UIAlertAction(title: "OK", style: .default))
            present(controller, animated: true)
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: {(object, error) in
                if let img = object as? UIImage {
                    self.uploadMedia(img: img)
                }})
        }
    }
    
    func openLibrary() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func uploadMedia(img: UIImage) {
        print("wait database")
    }
}

extension ShopReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as?UIImage {
            uploadMedia(img: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

