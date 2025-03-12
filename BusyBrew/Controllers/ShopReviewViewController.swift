//
//  ShopReviewViewController.swift
//  BusyBrew
//
//  Created by Grace Pan on 3/11/25.
//

import UIKit

class ShopReviewViewController: UIViewController{
    let photoTitle = UILabel()
    let uploadButton = UIButton(type: .system)
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoSection()
        // Do any additional setup after loading the view.
    }
    
    
    
    func photoSection() {
        photoTitle.text = "Photos"
        photoTitle.textColor = background1Light
        uploadButton.setTitle("upload", for: .normal)
        uploadButton.backgroundColor = background1Light
        uploadButton.setTitleColor(.white, for: .normal)
        
        uploadButton.frame = CGRect( x: 50, y: 300, width: 50, height: 25)
        view.addSubview(uploadButton)
        view.addSubview(photoTitle)
        uploadButton.addTarget( self, action: #selector(takeMedia), for: .touchUpInside)
    }
    
    @objc func takeMedia() {
        let controller = UIAlertController(title:"Media Controller", message: "Add media", preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title:"Take New Photo", style: .default) {_ in self.openMedia(source: .camera)})
        controller.addAction(UIAlertAction(title:"Choose Existing", style: .default) {_ in self.openMedia(source: .photoLibrary)})
        present(controller, animated: true)
    }
    
    func openMedia(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            imagePicker.delegate = self
            imagePicker.sourceType = source
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            print("don't have access")
            var alertTitle: String = source == .camera ? "Camera" : "Photo Library"
            let controller = UIAlertController(title: alertTitle, message: "Please allow access in settings", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            controller.addAction(UIAlertAction(title: "OK", style: .default))
            present(controller, animated: true)
        }
    }
    
    func uploadMedia(img: UIImage) {
        print("wait database")
    }
}

extension ShopReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

