//
//  ChatViewController.swift
//  VVIP_chat
//
//  Created by mac on 28/07/21.
//

import UIKit
//import StreamChat
//import StreamChatUI
import SocketIO
import Starscream
import MobileCoreServices
import UniformTypeIdentifiers
import CoreLocation
import Contacts
import CryptoKit
import MapKit
import MediaPlayer
import AVKit
import Photos
import PhotosUI

protocol ChatViewControllerDelegate:class {
    func docTaped(url: URL)
    func cellTaped(image:UIImage)
    func videoTaped(url: URL)
}

extension ChatViewController: ChatViewControllerDelegate{
    func docTaped(url: URL) {
        print("url.........")
        let urlFile = url
        var documentInteractionController: UIDocumentInteractionController!
        documentInteractionController = UIDocumentInteractionController.init(url: urlFile)
        documentInteractionController?.delegate = self
        documentInteractionController?.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func cellTaped(image: UIImage) {
        //        let vc = (self.storyboard?.instantiateViewController(identifier: "ImageViewController"))! as ImageViewController
        let vc = ImageViewController()
        vc.image = image
        //        self.navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true, completion: nil)
    }
    
    func videoTaped(url: URL) {
        print(url)
        //        let url1 = URL(string: url)
        //        let url1 = URL(fileURLWithPath: url)
        //        print(url1)
        //        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
        //          return
        //        }
        //        // 2
        //        PHPhotoLibrary.requestAuthorization { status in
        //            print(status)
        //        }
        //        let vc = (self.storyboard?.instantiateViewController(identifier: "ImageViewController"))! as ImageViewController
        //        let vc = ImageViewController()
        //        vc.image = image
        ////        self.navigationController?.pushViewController(vc, animated: true)
        //        present(vc, animated: true, completion: nil)
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
}

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, WebSocketDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate & UIDocumentPickerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MPMediaPickerControllerDelegate, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var send: UIImageView!
    @IBOutlet weak var camera: UIImageView!
    @IBOutlet weak var attachment: UIImageView!
    @IBOutlet weak var mic: UIImageView!
    @IBOutlet weak var hstack: UIStackView!
    
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
    let socketUrl: String = "ws://echo.websocket.org/"
    let socketUrlSC: String = "https://api.rybitt.com"
    
    var manager: SocketManager!
    var soc: SocketIOClient!
    
    var pickedImage: UIImage! = nil
    var path: URL!
    var pickedContact: ContactData! = nil
    var pickedContactImage: UIImage! = nil
    var pickedLocation: CLLocation! = nil
    var messageType: MessageType = .text
    var selectedMessage: Int!
    
    //encryption and decription varialbles
    var myprivateKey: P256.KeyAgreement.PrivateKey!
    var otherprivateKey: P256.KeyAgreement.PrivateKey!
    var mysymmetricKey: SymmetricKey!
    var othersymmetricKey: SymmetricKey!
    
    //    var completionHandler: ((UIImage) -> Void)?
    
    var messages: [MessageData] = [
        MessageData(text: "Hey", isFirstUser: true, image: nil, contact: nil, location: nil, document: nil, messageType: .text),
        MessageData(text: "Hello", isFirstUser: false, image: nil, contact: nil, location: nil, document: nil, messageType: .text),
        MessageData(text: "I am Raj from India, working as a Flutter and IOS developer at Impetrosys", isFirstUser: true, image: nil, contact: nil, location: nil, document: nil, messageType: .text),
        MessageData(text: "okay, I am jack from US", isFirstUser: false, image: nil, contact: nil, location: nil, document: nil, messageType: .text),
        MessageData(text: "Okay", isFirstUser: true, image: nil, contact: nil, location: nil, document: nil, messageType: .text),
        MessageData(text: "Raj can we meet somewhere to discuss about the project detail", isFirstUser: false, image: nil, contact: nil, location: nil, document: nil, messageType: .text),
        MessageData(text: "Off-course jack we can meet at ICH so that we can discuss", isFirstUser: true, image: nil, contact: nil, location: nil, document: nil, messageType: .text),
        MessageData(text: "Let me know the time, so that i will come at the destination", isFirstUser: false, image: nil, contact: nil, location: nil, document: nil, messageType: .text),
        MessageData(text: "Monday 6:00 PM, is okay for that", isFirstUser: true, image: nil, contact: nil, location: nil, document: nil, messageType: .text),
        MessageData(text: "yup i'll", isFirstUser: false, image: nil, contact: nil, location: nil, document: nil, messageType: .text),
        MessageData(text: "Okay thanks", isFirstUser: true, image: nil, contact: nil, location: nil, document: nil, messageType: .text),
        MessageData(text: "photo", isFirstUser: false, image: imageData(image: UIImage(named: "nature"), url: nil), contact: nil, location: nil, document: nil, messageType: .image),
        MessageData(text: "https://www.google.com", isFirstUser: true, image: nil, contact: nil, location: nil, document: nil, messageType: .link),
        MessageData(text: "Raj", isFirstUser: true, image: nil, contact: ContactData(phones: ["9977783414", "8819896489"], image: UIImage(named:"person")), location: nil, document: nil, messageType: .contact),
        MessageData(text: "Stark", isFirstUser: false, image: nil, contact: ContactData(phones: ["(997)7783414"], image: UIImage(named:"person")), location: nil, document: nil, messageType: .contact),
        MessageData(text: "Kate Bell", isFirstUser: true, image: nil, contact: ContactData(phones: ["(555)564-8583", "(415) 555-3695"], image: UIImage(named:"nature")), location: nil, document: nil, messageType: .contact),
        MessageData(text: "impetrosys location", isFirstUser: false, image: nil, contact: nil, location: CLLocation(latitude: 22.717652352004368, longitude: 75.87711553958752), document: nil, messageType: .location),
        MessageData(text: "tajmahal location", isFirstUser: true, image: nil, contact: nil, location: CLLocation(latitude: 27.175307039887215, longitude: 78.0421207396789), document: nil, messageType: .location),
        MessageData(text: "Apollo premier", isFirstUser: true, image: nil, contact: nil, location: CLLocation(latitude: 22.749929207689632, longitude: 75.89680790621576), document: nil, messageType: .location),
        MessageData(text: "BigBuckBunny", isFirstUser: false, image: imageData(image: generateThumbnail1(url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!), url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")), contact: nil, location: nil, document: nil, messageType: .video),
        MessageData(text: "file-sample_100kB.doc", isFirstUser: false, image: nil, contact: nil, location: nil, document: URL(string: "file:///Users/mac/Library/Developer/CoreSimulator/Devices/2254DE57-ED46-408F-B200-8E6F31D288CD/data/Containers/Shared/AppGroup/513519F3-7C21-4C4F-918F-06920BA51E0E/File%20Provider%20Storage/Downloads/file-sample_100kB.doc"), messageType: .document),
    ]
    
    let firstAttribute : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.blue]
    let secondAttribute : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.blue]
    
    var useFirstAttribute: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewConfig()
        socketConfig()
        navConfig()
        btnsConfig()
        keyBoardConfig()
        chatViewConfig()
        textFieldConfig()
        longPressConfig()
        generateSymmetricKey()
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint)
    -> UIContextMenuConfiguration? {
        let index = indexPath.row
        print(index)
        let identifier = "\(index)" as NSString
        
        return UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: nil) { _ in
            // 3
            let reply =
                UIAction(title: NSLocalizedString("Reply", comment: ""),
                         image: UIImage(systemName: "arrowshape.turn.up.left")) { action in
                    //                        self.performInspect()
                }
                
                let copy =
                    UIAction(title: NSLocalizedString("Copy", comment: ""),
                             image: UIImage(systemName: "doc.on.doc")) { action in
                        print("Copy")
                        UIPasteboard.general.string = self.messages[index].text
                    }
                
                let delete =
                    UIAction(title: NSLocalizedString("Delete", comment: ""),
                             image: UIImage(systemName: "trash"),
                             attributes: .destructive) { action in
                        print("delete")
                        self.messages.remove(at: index)
                        self.messageTableView.reloadData()
                        self.selectedMessage = nil
                    }
                
                return UIMenu(title: "Action", children: [reply, copy, delete])
        }
    }
    //
    //    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
    //                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    //        return UIContextMenuConfiguration(identifier: nil,
    //                                          previewProvider: nil,
    //                                          actionProvider: {
    //                suggestedActions in
    //            let inspectAction =
    //                UIAction(title: NSLocalizedString("Reply", comment: ""),
    //                         image: UIImage(systemName: "arrowshape.turn.up.left")) { action in
    ////                        self.performInspect()
    //                }
    //
    //            let duplicateAction =
    //                UIAction(title: NSLocalizedString("Copy", comment: ""),
    //                         image: UIImage(systemName: "doc.on.doc")) { action in
    ////                        self.performDuplicate()
    //                    print("Copy")
    //                    UIPasteboard.general.string = self.messages[self.selectedMessage].text
    //                }
    //
    //            let deleteAction =
    //                UIAction(title: NSLocalizedString("Delete", comment: ""),
    //                         image: UIImage(systemName: "trash"),
    //                         attributes: .destructive) { action in
    ////                        self.performDelete()
    //                    if(self.selectedMessage != nil){
    //                        print("delete")
    //                        self.messages.remove(at: self.selectedMessage)
    //                        self.messageTableView.reloadData()
    //                        self.selectedMessage = nil
    //                    } else {
    //                        print("please select message")
    //                    }
    //                }
    //
    //            return UIMenu(title: "Context menu", children: [inspectAction, duplicateAction, deleteAction])
    //        })
    //    }
    
    private func generateSymmetricKey(){
        let myexportedPrivateKey = getData(key: "myprivateKey")
        let otherexportedPrivateKey = getData(key: "otherprivateKey")
        do{
            myprivateKey = try importPrivateKey(myexportedPrivateKey as! String)
            otherprivateKey = try importPrivateKey(otherexportedPrivateKey as! String)
            print("rkprivateKey: \(String(describing: myprivateKey))")
            print("ckprivateKey: \(String(describing: otherprivateKey))")
        } catch let e{
            print("Could not imported PrivateKey: \(e.localizedDescription)")
        }
        var encryptedMessage: String = ""
        do{
            mysymmetricKey = try deriveSymmetricKey(privateKey: myprivateKey, publicKey: otherprivateKey.publicKey)
            othersymmetricKey = try deriveSymmetricKey(privateKey: otherprivateKey, publicKey: myprivateKey.publicKey)
            
            encryptedMessage = try encrypt(text: "this is message encryption", symmetricKey: mysymmetricKey)
            print("encryptedMessage: \(encryptedMessage)")
            
            let decryptedMessage = decrypt(text: encryptedMessage, symmetricKey: othersymmetricKey)
            print("decryptedMessage: \(decryptedMessage)")
            //            alert(title: encryptedMessage, msg: decryptedMessage)
        } catch let e{
            print("Could not imported symmetricKey: \(e.localizedDescription)")
        }
    }
    
    private func encryptAndDecrypt(){
        let rkprivateKey = generatePrivateKey()
        let ckprivateKey = generatePrivateKey()
        
        let rkpublicKey = rkprivateKey.publicKey
        let ckpublicKey = ckprivateKey.publicKey
        
        print("rkprivateKey: \(rkprivateKey)")
        print("ckprivateKey: \(ckprivateKey)")
        print("rkpublicKey: \(rkpublicKey)")
        print("ckpublicKey: \(ckpublicKey)")
        
        let exportedPrivateKey = exportPrivateKey(rkprivateKey)
        print("exportedPrivateKey: \(exportedPrivateKey)")
        do{
            let importedPrivateKey = try importPrivateKey(exportedPrivateKey)
            print("importedPrivateKey: \(importedPrivateKey)")
        } catch let e{
            print("Could not imported PrivateKey: \(e.localizedDescription)")
        }
        var encryptedMessage: String = ""
        do{
            let rksymmetricKey = try deriveSymmetricKey(privateKey: rkprivateKey, publicKey: ckpublicKey)
            let cksymmetricKey = try deriveSymmetricKey(privateKey: ckprivateKey, publicKey: rkpublicKey)
            
            encryptedMessage = try encrypt(text: "this is my rk", symmetricKey: rksymmetricKey)
            print("encryptedMessage: \(encryptedMessage)")
            
            let decryptedMessage = decrypt(text: encryptedMessage, symmetricKey: cksymmetricKey)
            print("decryptedMessage: \(decryptedMessage)")
            alert(title: encryptedMessage, msg: decryptedMessage)
        } catch let e{
            print("Could not imported symmetricKey: \(e.localizedDescription)")
        }
    }
    //
    private func alert(title:String, msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        textField.resignFirstResponder()
    //        print("view appeared")
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        textField.resignFirstResponder()
    //        print("view disappeared")
    //    }
    
    private func longPressConfig(){
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        self.messageTableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let location = longPressGesture.location(in: self.messageTableView)
        let indexPath = self.messageTableView.indexPathForRow(at: location)
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            print("Long press on row, at \(indexPath!.row)")
            self.selectedMessage = indexPath?.row
            //            actionConfig()
            //            let interaction = UIContextMenuInteraction(delegate: self)
            //            messageTableView.addInteraction(interaction)
        }
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
    ////        print("cell: \(cell)")
    //        print("indexpath: \(indexPath)")
    //    }
    
    private func tableviewConfig(){
        messageTableView.scrollToBottom()
    }
    
    private func socketConfig(){
        var request = URLRequest(url: URL(string: socketUrl)!) //https://localhost:8080
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        
        manager = SocketManager(socketURL: URL(string: socketUrlSC)!, config: [.log(true), .compress])
        soc = manager.defaultSocket
        print(manager.status)
        
                soc.connect()
        
                soc.on(clientEvent: .connect) {data, ack in
                    print("socket connected")
                    self.isConnected = true
                }
        
                soc.on(clientEvent: .disconnect) {data, ack in
                    print("socket disconnected")
                    self.isConnected = false
                }
        
    }
    
    //socket Configuartion
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
            let decryptedMessage:String = decrypt(text: string, symmetricKey: othersymmetricKey)
            print("decryptedMessage: \(decryptedMessage)")
        //            let msg = MessageData(text: string, isFirstUser: true)
        //            messages.append(msg)
        //            messageTableView.reloadData()
        //                msgConfig(message: string)
        //                displayText.text = displayText.text+"\n"+string
        //                print(event)
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            print("ping")
            break
        case .pong(_):
            print("pong")
            break
        case .viabilityChanged(_):
            print("visibility changed")
            break
        case .reconnectSuggested(_):
            print("reconnect suggested")
            break
        case .cancelled:
            print("connected")
            isConnected = false
        case .error(let error):
            print(error!)
            isConnected = false
            handleError(error)
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    
    private func textFieldConfig(){
        textField.delegate = self
        textField.text = ""
    }
    
    @IBAction func onchange(_ sender: Any) {
        if(textField.text!.trimmingCharacters(in: .whitespaces) == ""){
            send.isHidden = true
        } else {
            send.isHidden = false
        }
        self.messageType = .text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        //     textField.resignFirstResponder()
        sendBtnTapped()
        //        textField.text = textField.text! + "\r\n"
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    private func chatViewConfig(){
        messageTableView.bounces = false
        messageTableView.delegate = self
        messageTableView.dataSource = self
        //        messageTableView.backgroundColor = #colorLiteral(red: 0.1072840765, green: 0.1896482706, blue: 0.3115866184, alpha: 1)
    }
    
    private func keyBoardConfig(){
        //        hstack.bindToKeyboard()
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        // move the root view up by the distance of keyboard height
        self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }//till here
    
    private func btnsConfig(){
        let sendGstr = UITapGestureRecognizer(target: self, action: #selector(sendBtnTapped))
        send.addGestureRecognizer(sendGstr)
        send.isHidden = true
        
        let cameraGstr = UITapGestureRecognizer(target: self, action: #selector(cameraTapped))
        camera.addGestureRecognizer(cameraGstr)
        
        let attachGstr = UITapGestureRecognizer(target: self, action: #selector(attachTapped))
        attachment.addGestureRecognizer(attachGstr)
        
        let micGstr = UITapGestureRecognizer(target: self, action: #selector(micTapped))
        mic.addGestureRecognizer(micGstr)
    }
    
    @objc func cameraTapped(){
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
        
        let popover = alert.popoverPresentationController
        popover?.sourceRect = CGRect(x: self.view.bounds.maxX, y: self.view.bounds.maxY, width: 0, height: 0)
        popover?.sourceView = self.view
        present(alert, animated: true)
        
    }
    
    private func pickImage(source: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(source){
            imagePicker.sourceType = source
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
    
    //    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
    //         let selectedImage : UIImage = image
    //        pickedImage = selectedImage
    //        messageTableView.reloadData()
    //        print(selectedImage.size)
    //        self.textField.text = "\(image.size)"
    //        self.send.isHidden = false
    //        print("image picked")
    //        self.dismiss(animated: true, completion: nil)
    //    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(picker.mediaTypes)
        //        let phPicker = PHPickerViewController()
//        var url:String?
        var filename:String?
        switch picker.mediaTypes.first{
        case "public.movie":
            print("info.........: \(info)")
            let videoURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL
            print(videoURL as Any)
            path = videoURL
//            url = videoURL!.path
            print(path!)
            let thumbnail = generateThumbnail1(url: videoURL!)
            print(thumbnail!)
            self.pickedImage = thumbnail
            filename = videoURL?.lastPathComponent
            messageType = .video
            
        case "public.image":
            let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
            //                let path = imageURL.path!
            //            let imageName = path.lastPathComponent
            print(imageURL)
            guard let image = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            
            pickedImage = image
            messageType = .image
            path = imageURL as URL
//            url = imageURL.path
            filename = imageURL.lastPathComponent
            
        default:
            print(picker.mediaTypes)
        }
        
        print(info)
        //        completionHandler?(image)
        
        self.textField.text = "\(String(describing: filename))"
        self.send.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("image picker cancelled by the user")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func attachTapped(){
        print("attach tapped")
        
        let alert = UIAlertController(
            title: "Select source",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(
            .init(title: "Images", style: .default) { _ in
                self.pickImage(source: .photoLibrary)
            }
        )
        
        alert.addAction(
            .init(title: "Documents", style: .default) { _ in
                self.selectFiles()
            }
        )
        
        alert.addAction(
            .init(title: "Audio", style: .default) { _ in
                self.selectAudio()
            }
        )
        
        alert.addAction(
            .init(title: "Videos", style: .default) { _ in
                self.selectVideo()
            }
        )
        
        alert.addAction(
            .init(title: "Location", style: .default) { _ in
                self.getLocation()
            }
        )
        
        alert.addAction(
            .init(title: "Contact", style: .default) { _ in
                self.fetchContact()
            }
        )
        
        let popover = alert.popoverPresentationController
        popover?.sourceRect = CGRect(x: self.view.bounds.maxX, y: self.view.bounds.maxY, width: 0, height: 0)
        popover?.sourceView = self.view
        present(alert, animated: true)
    }
    
    func selectVideo() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = ["public.movie"]
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    private func selectAudio(){
        print("select audio")
        let musicPicker = MPMediaPickerController(mediaTypes: .music)
        musicPicker.allowsPickingMultipleItems = true
        //        controller.popoverPresentationController?.sourceView = view
        musicPicker.showsCloudItems = true
        musicPicker.delegate = self
        musicPicker.prompt = NSLocalizedString("Add pieces to queue", comment:"");
        print(musicPicker.view.frame)
        present(musicPicker, animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        //        mediaItems = mediaItemCollection.items
        //        updatePlayer()
        //User selected a/an item(s).
        for mpMediaItem in mediaItemCollection.items {
            print("Add \(mpMediaItem) to a playlist, prep the player, etc.")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        print("cancelled picking media")
    }
    
    private func fetchContact(){
        
        //                let contact = CNMutableContact()
        //                let store = CNContactStore()
        //                do {
        //                    let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactPropertyAttribute] as [CNKeyDescriptor]
        //                    let predicate = CNContact.predicateForContacts(matchingName: "Bell")
        //                    let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
        //                    print("Fetched contacts: \(contacts)")
        //                } catch {
        //                    print("Failed to fetch contact, error: \(error)")
        //                    // Handle the error
        //                }
        
        var contacts = [CNContact]()
        let keys: [CNKeyDescriptor] = [CNContactNicknameKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactImageDataAvailableKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        let contactStore = CNContactStore()
        do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                print(contact.givenName)
            }
            self.showContactList(contacts: contacts)
        }
        catch {
            print("unable to fetch contacts")
        }
    }
    
    private func showContactList(contacts: [CNContact]){
        let alert = UIAlertController(title: "Contacts", message: "pick contacts you want to send", preferredStyle: .actionSheet)
        let validTypes = [
            CNLabelPhoneNumberiPhone,
            CNLabelPhoneNumberMobile,
            CNLabelPhoneNumberMain
        ]
        for contact in contacts{
            let numbers = contact.phoneNumbers.compactMap { phoneNumber -> String? in
                guard let label = phoneNumber.label, validTypes.contains(label) else { return nil }
                return phoneNumber.value.stringValue
            }
            print("numbers...........:\(numbers)")
            alert.addAction(.init(title: contact.givenName + " " + contact.familyName, style: .default){_ in
                if (contact.imageDataAvailable){
                    self.pickedContactImage = UIImage(data: contact.imageData!)
                    print("image................: \(String(describing: self.pickedContactImage))")
                } else {
                    self.pickedContactImage = UIImage(named: "person")
                }
                self.pickedContact = ContactData(phones: numbers, image: self.pickedContactImage)
                self.textField.text = contact.givenName + " " + contact.familyName//+"\n"+"\(numbers)"
                self.send.isHidden = false
                self.messageType = .contact
            })
        }
        present(alert, animated: true, completion: nil)
    }
    
    private func getLocation(){
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1000
        locationManager.requestLocation()
        //                locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Location data received.")
            print(location)
            self.pickedLocation = location
            //            MessageLocationCell().location = location
            let alert = UIAlertController(title: "Picked location", message: "\(location)", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel))
            present(alert, animated: true, completion: nil)
            self.textField.text = "\(location)"
            self.send.isHidden = false
            self.messageType = .location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get users location.")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            let locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            //                    let authStatus: CLAuthorizationStatus = .authorizedWhenInUse
            print("I was accessed")
            //                    getUserLocationData()
            break
        case .authorizedAlways:
            //                    let authStatus: CLAuthorizationStatus = .authorizedAlways
            break
        case .restricted:
            let alert = UIAlertController(title:"Permission denied!", message: "Parental controls block permission to access your location.",preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            break
        case .denied:
            let alert = UIAlertController(title:"Permission denied!", message: "Please go to settings and allow permission to access your location.",preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            break
        @unknown default:
            print("default")
        }
    }
    
    
    private func selectFiles() {
        //        let types = UTType.types(tag: "doc",
        //                                 tagClass: UTTagClass.filenameExtension,
        //                                 conformingTo: nil)
        let types = [UTType.pdf, UTType.jpeg, UTType.audio, UTType.gif, UTType.avi, UTType.application, UTType.folder, UTType.text, UTType.aliasFile, UTType.realityFile, UTType.doc, UTType.docs, UTType.docx, UTType.png, UTType.mp3, UTType.mp4]
        
        let documentPickerController = UIDocumentPickerViewController(
            forOpeningContentTypes: types)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print(urls)
        print("import result : \(myURL)")
        path = myURL
        self.textField.text = myURL.lastPathComponent
        //        self.textField.text = "\(myURL)"
        self.send.isHidden = false
        messageType = .document
    }
    
    public func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        print(documentPicker.directoryURL!)
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func micTapped(){
        print("mic tapped")
    }
    
    public func getLink(text: String) -> String?{
        let input = text
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        var url: String = ""
        
        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            url = String(input[range])
            self.messageType = .link
            print("link url: \(url)")
        }
        return url
    }
    
    @objc func sendBtnTapped(){
        let messageText:String = textField.text!.trimmingCharacters(in: .whitespaces)
        //        if(!messageText.isEmpty && isConnected){
        if(!messageText.isEmpty){
            //check if entered text is a link
            _ = getLink(text: messageText)
            
            let msg = MessageData(text: messageText, isFirstUser: true, image: imageData(image: pickedImage, url: path), contact: pickedContact,location: pickedLocation, document: path, messageType: messageType)
            
            messages.append(msg)
            sendBySocket(messageText: messageText)
            print(messages)
            messageTableView.reloadData()
            //            textField.text = ""
            prepareForReuse()
            send.isHidden = true
            messageTableView.scrollToBottom()
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "Network Connection Refused, Please check your internet Connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{_ in
                self.socketConfig()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func prepareForReuse(){
        textField.text = ""
        pickedImage = nil
        pickedContact = nil
        pickedLocation = nil
        pickedContactImage = nil
        messageType = .text
    }
    
    private func sendBySocket(messageText:String){
        var encryptedMessage: String = ""
        do{
            encryptedMessage = try encrypt(text: messageText, symmetricKey: mysymmetricKey)
            print("encryptedMessage: \(encryptedMessage)")
        } catch let e{
            print(e)
        }
        let decryptedMessage:String = decrypt(text: encryptedMessage, symmetricKey: othersymmetricKey)
        print("decryptedMessage: \(decryptedMessage)")
        //        socket.write(string: messageText)
        socket.write(string: encryptedMessage)
        //        soc.on(clientEvent: .connect){(data, ack) in
        //            print("socket connected")
        //            self.soc.emit("Raj", messageText)
        //            print(data)
        //            print(ack)
        //        }
        //        soc.emit("sendMessage", messageText)
        //        soc.connect()
        //
        //        soc.on(clientEvent: .connect) {data, ack in
        //            print("socket connected")
        //        }
        
        soc.on("currentAmount") {data, ack in
            guard let cur = data[0] as? Double else { return }
            
            self.soc.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                if data.first as? String ?? "passed" == SocketAckStatus.noAck {
                    // Handle ack timeout
                }
                
                self.soc.emit("update", ["amount": cur + 2.50])
            }
            
            ack.with("Got your currentAmount", "dude")
        }
        
        soc.connect()
    }
    
    private func navConfig(){
        //        navigationController?.navigationBar.barTintColor = UIColor.green
        //            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.293738246, green: 0.6559162736, blue: 0.8622517586, alpha: 1)
        //            self.navigationController?.navigationBar.tintColor = .white
        //            navigationItem.title = "Contacts"
        //            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        //            let person = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(self.personTapped))
        //            let ellipsis = UIBarButtonItem(image: UIImage(systemName: "ellipsis")?.rotate(1.5708), style: .plain, target: self, action: #selector(self.ellipsisTapped))
        //            self.navigationItem.rightBarButtonItems = [ellipsis,person]
        titleConfig()
    }
    
    private func titleConfig(){
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        let logo = UIImage(named: "person")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.contentMode = .scaleAspectFit
        
        let title = UILabel()
        title.text = "Blair Data"
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.frame = CGRect(x: 45, y: 0, width: 100, height: 20)
        
        let subtitle = UILabel()
        subtitle.text = "Online"
        subtitle.textColor = .white
        subtitle.font = UIFont.boldSystemFont(ofSize: 14)
        subtitle.frame = CGRect(x: 45, y: 20, width: 100, height: 20)
        
        
        titleView.addSubview(imageView)
        titleView.addSubview(title)
        titleView.addSubview(subtitle)
        
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: TableViewDelegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        //        let imageCell = tableView.dequeueReusableCell(withIdentifier: "MessageImageCell", for: indexPath) as! MessageImageCell
        //        cell.updateMessageCell(by: messages[indexPath.row])
        //        imageCell.updateMessageCell(by: messages[indexPath.row])
        //        cell.imageView = UIImageView(image: UIImage(systemName: "person.fill"))
        //        if(pickedImage != nil){
        //            cell.imageView?.image = pickedImage
        //        }
        //        image?.size.height = 100
        //        cell.largeContentImage = image
        //        if(cell.isSelected){
        //            cell.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        //        }
        //        cell.selectedBackgroundView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        //        print(indexPath.row)
        //        return cell
        
        switch messages[indexPath.row].messageType{
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
            cell.updateMessageCell(by: messages[indexPath.row])
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageImageCell", for: indexPath) as! MessageImageCell
            cell.delegate = self
            cell.updateMessageCell(by: messages[indexPath.row])
            return cell
        case .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageVideoCell", for: indexPath) as! MessageVideoCell
            cell.delegate = self
            cell.updateMessageCell(by: messages[indexPath.row])
            return cell
        case .link:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageLinkCell", for: indexPath) as! MessageLinkCell
            cell.updateMessageCell(by: messages[indexPath.row])
            return cell
        case .contact:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageContactCell", for: indexPath) as! MessageContactCell
            cell.updateMessageCell(by: messages[indexPath.row])
            return cell
        case .location:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageLocationCell", for: indexPath) as! MessageLocationCell
            cell.updateMessageCell(by: messages[indexPath.row])
            return cell
        case .document:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageDocumentCell", for: indexPath) as! MessageDocumentCell
            cell.delegate = self
            cell.updateMessageCell(by: messages[indexPath.row])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
            cell.updateMessageCell(by: messages[indexPath.row])
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedMessage = indexPath.row
        //                print("selected item \(indexPath.row)")
        
        //         vc = storyboard?.instantiateViewController(withIdentifier: "DrawerViewController") as! DrawerViewController
        //        switch messages[indexPath.row].messageType {
        //        case .image:
        ////            print("selected item \(indexPath.row)")
        ////            ImageViewController().image = messages[indexPath.row].image
        ////            let vc = self.storyboard?.instantiateViewController(identifier: <#T##String#>)
        ////            ImageViewController().image = messages[indexPath.row].image
        ////            let vc = (self.storyboard?.instantiateViewController(identifier: "ImageViewController"))! as ImageViewController
        ////            vc.image = messages[indexPath.row].image
        //            let vc = ImageViewController()
        ////            self.navigationController?.pushViewController(vc, animated: false)
        //            present(vc, animated: true, completion: nil)
        //        //            vc = storyboard?.instantiateViewController(withIdentifier: "DrawerViewController") as! DrawerViewController
        ////        case 1:
        ////            print("selected item \(indexPath.row)")
        ////        //            vc = storyboard?.instantiateViewController(withIdentifier: "AddUserViewController") as! AddUserViewController
        ////        case 3:
        ////            print("selected item \(indexPath.row)")
        ////        //            vc = storyboard?.instantiateViewController(withIdentifier: "SettingDialViewController") as! SettingDialViewController
        ////        case 4:
        ////            print("selected item \(indexPath.row)")
        //        //            vc = storyboard?.instantiateViewController(withIdentifier: "StreamChatViewController")
        //        default:
        //            print("selected item \(indexPath.row)")
        //        //            vc = storyboard?.instantiateViewController(withIdentifier: "AddUserViewController") as! AddUserViewController
        //        }
        
        //        dismiss(animated: true, completion: nil)
        ////        let vc1 = storyboard?.instantiateViewController(withIdentifier: "AddUserViewController") as! vc
        //        if(indexPath.row != 0){
        //            self.navigationController?.pushViewController(vc!, animated: false)
        //        } else {
        //            dismiss(animated: true)
        //        }
        
    }
    
}
