//
//  SetPhotoVideoViewController.swift
//  VVIP_chat
//
//  Created by mac on 11/09/21.
//

import UIKit

class SetPhotoVideoViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var hstackView: UIStackView!
    @IBOutlet var image: UIImageView!
    @IBOutlet weak var nextBtn: UIStackView!
    @IBOutlet weak var setPhoto: UILabel!
    
    var path: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        textFieldConfig()
        btnConfig()
    }
    
    private func btnConfig(){
        setPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setImageTapped)))
        nextBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextBtnTapped)))
    }
    
    @objc func setImageTapped(){
        print("camera tapped")
        
        let alert = UIAlertController(
            title: "Select source",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(
            .init(title: "Gallery", style: .default) { _ in
                self.pickImage(source: .photoLibrary)
            }
        )
        
        alert.addAction(
            .init(title: "Camera", style: .default) { _ in
                self.pickImage(source: .camera)
            }
        )
        
        alert.addAction(
            .init(title: "Cancel", style: .cancel) { _ in
                //                self.pickImage(source: .camera)
            }
        )
        
        let popover = alert.popoverPresentationController
        popover?.sourceRect = CGRect(x: self.view.bounds.maxX, y: self.view.bounds.maxY, width: 0, height: 0)
        popover?.sourceView = self.view
        present(alert.fixConstraints(), animated: true)
    }
    
    private func pickImage(source: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(source){
            imagePicker.sourceType = source
            imagePicker.mediaTypes = ["public.image","public.movie"]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Alert", message: "This source is not available", preferredStyle: .alert)
            
            alert.addAction(
                .init(title: "Cancel", style: .cancel) { _ in
                    
                }
            )
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String

        print(mediaType!)
        //                let phPicker = PHPickerViewController()
        //        var url:String?
//        var filename:String?
        switch mediaType{
        case "public.movie":
            print("info.........: \(info)")
            if #available(iOS 11.0, *) {
                path = info[UIImagePickerController.InfoKey.referenceURL] as? URL
            } else {
                path = info[UIImagePickerController.InfoKey.referenceURL] as? URL
            }
            //            print(videoURL as Any)
            //            path = videoURL
            //            url = videoURL!.path
            print(path!)
            let thumbnail = generateThumbnail1(url: path!)
            //            print(thumbnail!)
            self.image.image = thumbnail
//            filename = path?.lastPathComponent
            
        case "public.image":
            let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
            //                let path = imageURL.path!
            //            let imageName = path.lastPathComponent
            print(imageURL)
            guard let image = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            
            self.image.image = image
            path = imageURL as URL
            //            url = imageURL.path
//            filename = imageURL.lastPathComponent
        default:
            print(picker.mediaTypes)
        }
        
        print(info)
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("image picker cancelled by the user")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextBtnTapped(){
        let vc = (self.storyboard?.instantiateViewController(identifier: "DialPasswordViewController"))! as DialPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func textFieldConfig(){
        usernameField.attributedPlaceholder = NSAttributedString(string: "User Name",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemTeal.withAlphaComponent(0.5)])
        hstackView.layer.borderWidth = 1
        hstackView.layer.borderColor = UIColor.white.cgColor
        hstackView.layer.cornerRadius = 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameField.resignFirstResponder()
    }
}
