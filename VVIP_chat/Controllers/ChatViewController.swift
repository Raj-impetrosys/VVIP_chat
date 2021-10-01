//
//  ChatViewController.swift
//  VVIP_chat
//
//  Created by mac on 28/07/21.
//

import UIKit
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
    func imageTaped(image:UIImage)
    func videoTaped(url: URL)
}

extension ChatViewController: ChatViewControllerDelegate{
    func docTaped(url: URL) {
        print(url)
        var documentInteractionController: UIDocumentInteractionController!
        documentInteractionController = UIDocumentInteractionController.init(url: url)
        documentInteractionController?.delegate = self
        documentInteractionController?.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func imageTaped(image: UIImage) {
        let vc = ImageViewController()
        vc.image = image
        present(vc, animated: true, completion: nil)
//        UIView.animate(withDuration: 1.0, animations: {
//            let newImageView = UIImageView(image: image)
//            newImageView.frame = UIScreen.main.bounds
//            newImageView.backgroundColor = .black
//            newImageView.contentMode = .scaleAspectFit
//            newImageView.isUserInteractionEnabled = true
//            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
//            newImageView.addGestureRecognizer(tap)
//            self.view.addSubview(newImageView)
//        })
//        self.navigationController?.isNavigationBarHidden = true
//        self.tabBarController?.tabBar.isHidden = true
    }
    
//    @objc func dismissFullscreenImage(sender: UITapGestureRecognizer) {
//        self.navigationController?.isNavigationBarHidden = false
////        self.tabBarController?.tabBar.isHidden = false
//        sender.view?.removeFromSuperview()
//    }
    
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

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, WebSocketDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate & UIDocumentPickerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MPMediaPickerControllerDelegate, UIDocumentInteractionControllerDelegate, AVAudioRecorderDelegate, UIContextMenuInteractionDelegate {
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var send: UIImageView!
    @IBOutlet weak var camera: UIImageView!
    @IBOutlet weak var attachment: UIImageView!
    @IBOutlet weak var mic: UIImageView!
    @IBOutlet weak var hstack: UIStackView!
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var timeSpan: TimeSpan!
    
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
    let socketUrl: String = "ws://echo.websocket.org/"
    //    let socketUrlSC: String = "https://api.rybitt.com"  //demo url
    let socketUrlSC: String = "http://192.168.29.33:4000" //live url
    
    var manager: SocketManager!
    var soc: SocketIOClient!
    
    var pickedImage: UIImage? = nil
    var imagePAth: URL!
    var path: URL!
    var pickedContact: ContactData! = nil
    //    var pickedContactImage: UIImage! = nil
    var pickedLocation: Location! = nil
    var messageType: MessageType = .text
    var selectedMessage: Int!
    
    //encryption and decription varialbles
    var myprivateKey: P256.KeyAgreement.PrivateKey!
    var otherprivateKey: P256.KeyAgreement.PrivateKey!
    var mysymmetricKey: SymmetricKey!
    var othersymmetricKey: SymmetricKey!
    var userid: String = ""
    
    let firstAttribute : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.blue]
    let secondAttribute : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.blue]
    var useFirstAttribute: Bool = true
    var isHiddenTimer: Bool = false
    
    var messages: [MessageData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages()
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
    
    private func getMessages(){
        messages = [
            MessageData(roomId: "123", senderId: userid, text: "Hey", isFirstUser: true, image: nil, contact: nil, location: nil, document: nil, messageType: .text, time: "6:00 AM"),
            MessageData(roomId: "123", senderId: userid, text: "Hello", isFirstUser: false, image: nil, contact: nil, location: nil, document: nil, messageType: .text, time: "6:00 AM"),
            MessageData(roomId: "123", senderId: userid, text: "I am Raj from India, working as a Flutter and IOS developer at Impetrosys, my location is:", isFirstUser: true, image: nil, contact: nil, location: nil, document: nil, messageType: .text, time: "6:00 AM"),
            MessageData(roomId: "123", senderId: userid, text: "Apollo premier", isFirstUser: true, image: nil, contact: nil, location: Location(latitude: 22.749929207689632, longitude: 75.89680790621576), document: nil, messageType: .location, time: "6:01 AM"),
            MessageData(roomId: "123", senderId: userid, text: "okay, I am jack from US, this is my location", isFirstUser: false, image: nil, contact: nil, location: nil, document: nil, messageType: .text, time: "6:01 AM"),
            MessageData(roomId: "123", senderId: userid, text: "impetrosys location", isFirstUser: false, image: nil, contact: nil, location: Location(latitude: 22.717652352004368, longitude: 75.87711553958752), document: nil, messageType: .location, time: "6:02 AM"),
            MessageData(roomId: "123", senderId: userid, text: "Okay", isFirstUser: true, image: nil, contact: nil, location: nil, document: nil, messageType: .text, time: "6:03 AM"),
            MessageData(roomId: "123", senderId: userid, text: "Raj can we meet somewhere to discuss about the project detail", isFirstUser: false, image: nil, contact: nil, location: nil, document: nil, messageType: .text, time: "6:04 AM"),
            MessageData(roomId: "123", senderId: userid, text: "Off-course jack we can meet at ICH so that we can discuss", isFirstUser: true, image: nil, contact: nil, location: nil, document: nil, messageType: .text, time: "6:05 AM"),
            MessageData(roomId: "123", senderId: userid, text: "Let me know the time, so that i will come at the destination", isFirstUser: false, image: nil, contact: nil, location: nil, document: nil, messageType: .text, time: "6:06 AM"),
            MessageData(roomId: "123", senderId: userid, text: "Monday 6:00 PM, is okay for that", isFirstUser: true, image: nil, contact: nil, location: nil, document: nil, messageType: .text, time: "8:00 AM"),
            MessageData(roomId: "123", senderId: userid, text: "yup i'll", isFirstUser: false, image: nil, contact: nil, location: nil, document: nil, messageType: .text, time: "9:00 AM"),
            MessageData(roomId: "123", senderId: userid, text: "Okay thanks", isFirstUser: true, image: nil, contact: nil, location: nil, document: nil, messageType: .text, time: "10:12 AM"),
            //                    MessageData(roomId: "123", senderId: userid, text: "photo", isFirstUser: false, image: ImageData(image: UIImage(named: "nature"), url: nil), contact: nil, location: nil, document: nil, messageType: .image, time: "2:00 PM"),
            MessageData(roomId: "123", senderId: userid, text: "https://www.google.com", isFirstUser: false, image: nil, contact: nil, location: nil, document: nil, messageType: .link, time: "3:00 PM"),
            //                    MessageData(roomId: "123", senderId: userid, text: "Raj", isFirstUser: true, image: ImageData(image: UIImage(named:"person"), url: nil), contact: ContactData(phones: ["9977783414", "8819896489"]), location: nil, document: nil, messageType: .contact, time: "3:12 PM"),
            //                    MessageData(roomId: "123", senderId: userid, text: "Stark", isFirstUser: false, image: ImageData(image: UIImage(named:"person"), url: nil), contact: ContactData(phones: ["(997)7783414"]), location: nil, document: nil, messageType: .contact, time: "3:14 PM"),
            //                    MessageData(roomId: "123", senderId: userid, text: "BigBuckBunny", isFirstUser: true, image: ImageData(image: generateThumbnail1(url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!), url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")), contact: nil, location: nil, document: nil, messageType: .video, time: "3:20 PM"),
            MessageData(roomId: "123", senderId: userid, text: "file-sample_100kB.doc", isFirstUser: false, image: nil, contact: nil, location: nil, document: URL(string: "file:///Users/mac/Library/Developer/CoreSimulator/Devices/2254DE57-ED46-408F-B200-8E6F31D288CD/data/Containers/Shared/AppGroup/513519F3-7C21-4C4F-918F-06920BA51E0E/File%20Provider%20Storage/Downloads/file-sample_100kB.doc"), messageType: .document, time: "3:59 PM"),
        ]
    }
    
    private func hideSendBtn(){
        UIView.animate(withDuration: 0.2) {
            self.send.alpha = 0.2
            self.send.isHidden = true
        }
    }
    
    private func showSendBtn(){
        UIView.animate(withDuration: 0.2) {
            self.send.alpha = 1.0
            self.send.isHidden = false
        }
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
                    self.textField.becomeFirstResponder()
                }
                
                let copy =
                    UIAction(title: NSLocalizedString("Copy", comment: ""),
                             image: UIImage(systemName: "doc.on.doc")) { action in
                        print("Copy")
                        UIPasteboard.general.string = self.messages[index].text
                    }
                
                let forward =
                    UIAction(title: NSLocalizedString("Forward", comment: ""),
                             image: UIImage(systemName: "arrowshape.turn.up.right")) { action in
                        print("Forward")
                        //                        UIPasteboard.general.string = self.messages[index].text
                        let vc = (self.storyboard?.instantiateViewController(identifier: "ChatUserTableViewController"))! as ChatUserTableViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                
                let delete =
                    UIAction(title: NSLocalizedString("Delete", comment: ""),
                             image: UIImage(systemName: "trash"),
                             attributes: .destructive) { action in
                        print("delete")
                        self.messages.remove(at: index)
                        //                        self.messageTableView.reloadData()
                        self.messageTableView.deleteRows(at: [indexPath], with: .fade)
                        self.selectedMessage = nil
                    }
                
                return UIMenu(title: "Action", children: [reply, copy, forward, delete])
        }
    }
    
    private func generateSymmetricKey(){
        let myexportedPrivateKey = getData(key: "myprivateKey")
        let otherexportedPrivateKey = getData(key: "otherprivateKey")
        do{
            myprivateKey = try importPrivateKey(myexportedPrivateKey as! String)
            otherprivateKey = try importPrivateKey(otherexportedPrivateKey as! String)
            //            print("rkprivateKey: \(String(describing: myprivateKey))")
            //            print("ckprivateKey: \(String(describing: otherprivateKey))")
        } catch let e{
            print("Could not imported PrivateKey: \(e.localizedDescription)")
        }
        var encryptedMessage: String = ""
        do{
            mysymmetricKey = try deriveSymmetricKey(privateKey: myprivateKey, publicKey: otherprivateKey.publicKey)
            othersymmetricKey = try deriveSymmetricKey(privateKey: otherprivateKey, publicKey: myprivateKey.publicKey)
            
            encryptedMessage = try encrypt(text: "this is message encryption", symmetricKey: mysymmetricKey)
            //            print("encryptedMessage: \(encryptedMessage)")
            
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
        
        //        print("rkprivateKey: \(rkprivateKey)")
        //        print("ckprivateKey: \(ckprivateKey)")
        //        print("rkpublicKey: \(rkpublicKey)")
        //        print("ckpublicKey: \(ckpublicKey)")
        
        let exportedPrivateKey = exportPrivateKey(rkprivateKey)
        //        print("exportedPrivateKey: \(exportedPrivateKey)")
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
            //            print("encryptedMessage: \(encryptedMessage)")
            
            let decryptedMessage = decrypt(text: encryptedMessage, symmetricKey: cksymmetricKey)
            //            print("decryptedMessage: \(decryptedMessage)")
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
        //        messageTableView.reloadData()
        //        let indexPath = NSIndexPath(row: messages.count-1, section: 0)
        //        messageTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        messageTableView.scrollToBottom()
        //        self.messageTableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        //        messageTableView.contentOffset = CGPoint(x: 0, y: self.view.frame.maxY)
    }
    
    private func addMsg(msg: MessageData){
        //        let msg:MessageData = MessageData(roomId: "123", senderId: userid, text: msg, isFirstUser: false, image: ImageData(image: image, url: url), contact: contact, location: location, document: nil, messageType: messageType, time: getTime())
        self.messages.append(msg)
        self.messageTableView.beginUpdates()
        self.messageTableView.insertRows(at: [IndexPath.init(row: self.messages.count-1, section: 0)], with: .left)
        self.messageTableView.endUpdates()
        self.messageTableView.scrollToBottom()
    }
    
    private func socketConfig(){
        //        var request = URLRequest(url: URL(string: socketUrl)!) //https://localhost:8080
        //        request.timeoutInterval = 5
        //        socket = WebSocket(request: request)
        //        socket.delegate = self
        //        socket.connect()
        
        manager = SocketManager(socketURL: URL(string: socketUrlSC)!, config: [.log(true), .compress])
        soc = manager.defaultSocket
        //        let swiftSocket = manager.socket(forNamespace: "/swift")
        print(manager.status)
        
        //        const socket = SocketIO('https://195.174.3.104:3000', { query: { myParam: 'myValue' } });
        
        
        soc.connect();
        
        soc.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            self.isConnected = true
            //            print(data)
            self.userid = data.description
            //add message to the cell
            
            self.soc.emit("joinRoom", [
                "roomId":"123"
            ])
        }
        
        soc.on(clientEvent: .disconnect) { data, ack in
            print("socket disconnected: \(data)")
        }
        
        soc.on(clientEvent: .error) { (data, ack) in
            print("error: \(data)")
        }
        
        soc.on(clientEvent: .ping) { (data, ack) in
            print("ping: \(data)")
        }
        
        soc.on(clientEvent: .pong) { (data, ack) in
            print("pong: \(data)")
        }
        
        soc.on(clientEvent: .reconnect) { (data, ack) in
            print("reconnect: \(data)")
        }
        
        soc.on(clientEvent: .reconnectAttempt) { (data, ack) in
            print("reconnectAttempt: \(data)")
        }
        
        soc.on(clientEvent: .statusChange) { (data, ack) in
            print("statusChange: \(data)")
        }
        
        soc.on(clientEvent: .websocketUpgrade) { (data, ack) in
            print("websocketUpgrade: \(data)")
        }
        
        soc.on("newChatMessage") { (data, ack) in
            for dict in data {
                let d = dict as! String
                do {
                    var decodeddata = try JSONDecoder().decode(MessageData.self, from: d.data(using: .utf8)!)
                    if(decodeddata.senderId != self.userid){
                        decodeddata.isFirstUser = false
                        self.addMsg(msg: decodeddata)
                    }
                } catch {
                    print(error)
                }
            }
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
            hideSendBtn()
        } else {
            showSendBtn()
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
        ///TODO: Add method to pangesture
        send.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(draggedSendBtn)))
        
        let cameraGstr = UITapGestureRecognizer(target: self, action: #selector(cameraTapped))
        camera.addGestureRecognizer(cameraGstr)
        
        let attachGstr = UITapGestureRecognizer(target: self, action: #selector(attachTapped))
        attachment.addGestureRecognizer(attachGstr)
        
        let micGstr = UITapGestureRecognizer(target: self, action: #selector(micTapped))
        mic.addGestureRecognizer(micGstr)
        
        let timespanGstr = UITapGestureRecognizer(target: self, action: #selector(timeSpanTapped))
        timeSpan.addGestureRecognizer(timespanGstr)
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
                                            suggestedActions in
                                            let inspectAction =
                                                UIAction(title: NSLocalizedString("InspectTitle", comment: ""),
                                                         image: UIImage(systemName: "arrow.up.square")) { action in
                                                    //                    self.performInspect()
                                                }
                                            
                                            let duplicateAction =
                                                UIAction(title: NSLocalizedString("DuplicateTitle", comment: ""),
                                                         image: UIImage(systemName: "plus.square.on.square")) { action in
                                                    //                    self.performDuplicate()
                                                }
                                            
                                            let deleteAction =
                                                UIAction(title: NSLocalizedString("DeleteTitle", comment: ""),
                                                         image: UIImage(systemName: "trash"),
                                                         attributes: .destructive) { action in
                                                    //                    self.performDelete()
                                                }
                                            
                                            return UIMenu(title: "", children: [inspectAction, duplicateAction, deleteAction])
                                          })
    }
    
    @objc func timeSpanTapped(){
        print("time Span tapped")
        
        let timeView = UIView(frame: CGRect(x: 30, y: UIScreen.main.bounds.height*0.7, width: 100, height: 160))
        timeView.backgroundColor = .white
        timeView.layer.cornerRadius = 20
        timeView.tag = 100
        
        let time1 = UILabel(frame: CGRect(x: 0, y: 20, width: 100, height: 20))
        time1.text = "30 sec"
        time1.isUserInteractionEnabled = true
        time1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(time1Tapped)))
        
        let time2 = UILabel(frame: CGRect(x: 0, y: 20, width: 100, height: 20))
        time2.text = "45 sec"
        time2.isUserInteractionEnabled = true
        time2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(time2Tapped)))
        
        let time3 = UILabel(frame: CGRect(x: 0, y: 20, width: 100, height: 20))
        time3.text = "1 min"
        time3.isUserInteractionEnabled = true
        time3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(time3Tapped)))
        
        let time4 = UILabel(frame: CGRect(x: 0, y: 20, width: 100, height: 20))
        time4.text = "5 min"
        time4.isUserInteractionEnabled = true
        time4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(time4Tapped)))
        
        let vStack = UIStackView(arrangedSubviews: [time1, time2, time3, time4])
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.alignment = .center
        vStack.spacing = 10
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        timeView.addSubview(vStack)
        
        vStack.centerXAnchor.constraint(equalTo: timeView.centerXAnchor).isActive = true
        vStack.centerYAnchor.constraint(equalTo: timeView.centerYAnchor).isActive = true
        
        if isHiddenTimer {
            removeTimeView()
        } else {
            self.view.addSubview(timeView)
            isHiddenTimer.toggle()
        }
    }
    
    private func removeTimeView(){
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        } else {
            print("tag not found")
        }
        isHiddenTimer.toggle()
    }
    
    @objc func time1Tapped(){
        print("time tapped")
        removeTimeView()
        let timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(fire), userInfo: nil, repeats: false)
        print(timer.fireDate)
    }
    
    @objc func time2Tapped(){
        print("time tapped")
        removeTimeView()
        let timer = Timer.scheduledTimer(timeInterval: 45.0, target: self, selector: #selector(fire), userInfo: nil, repeats: false)
        print(timer.fireDate)
    }
    
    @objc func time3Tapped(){
        print("time tapped")
        removeTimeView()
        let timer = Timer.scheduledTimer(timeInterval: 120.0, target: self, selector: #selector(fire), userInfo: nil, repeats: false)
        print(timer.fireDate)
    }
    
    @objc func time4Tapped(){
        print("time tapped")
        removeTimeView()
        let timer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(fire), userInfo: nil, repeats: false)
        print(timer.fireDate)
    }
    
    @objc func fire()
    {
        print("FIRE!!!")
        let index = messages.count - 1
        self.messages.remove(at: index)
        self.messageTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
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
        //                let phPicker = PHPickerViewController()
        //        var url:String?
        var filename:String?
        switch mediaType {
        case "public.movie":
            //            print("info.........: \(info)")
            if #available(iOS 11.0, *) {
                imagePAth = info[UIImagePickerController.InfoKey.referenceURL] as? URL
            } else {
                imagePAth = info[UIImagePickerController.InfoKey.referenceURL] as? URL
            }
            //            print(videoURL as Any)
            //            path = videoURL
            //            url = videoURL!.path
            //            print(path!)
            let thumbnail = generateThumbnail1(url: imagePAth!)
            //            print(thumbnail!)
            self.pickedImage = thumbnail
            filename = imagePAth?.lastPathComponent
            messageType = .video
            
        case "public.image":
            let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
            //                let path = imageURL.path!
            //            let imageName = path.lastPathComponent
            //            print(imageURL)
            guard let image = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            
            pickedImage = image
            messageType = .image
            imagePAth = imageURL as URL
            //            url = imageURL.path
            filename = imageURL.lastPathComponent
            
        default:
            print(picker.mediaTypes)
        }
        
        //        print(info)
        
        self.textField.text = "\(String(describing: filename))"
        showSendBtn()
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
    
    private func checkPermission(picker: UIImagePickerController) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            present(picker, animated: true, completion: nil)
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    self.present(picker, animated: true, completion: nil)
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        case .limited:
            print("limited")
        @unknown default:
            print("default")
        }
    }
    
    func selectVideo() {
        //        PHPhotoLibrary.requestAuthorization { (PHAuthorizationStatus) in
        //            print(PHAuthorizationStatus)
        //        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = ["public.movie"]
        picker.allowsEditing = false
        checkPermission(picker: picker)
        //        present(picker, animated: true, completion: nil)
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
                //                print(contact.givenName)
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
            alert.addAction(.init(title: contact.givenName + " " + contact.familyName, style: .default){_ in
                if (contact.imageDataAvailable){
                    self.pickedImage = UIImage(data: contact.imageData!)
                    //                    print("image................: \(String(describing: self.pickedContactImage))")
                } else {
                    self.pickedImage = UIImage(named: "person")
                }
                self.pickedContact = ContactData(phones: numbers)
                self.textField.text = contact.givenName + " " + contact.familyName//+"\n"+"\(numbers)"
                self.showSendBtn()
                self.messageType = .contact
            })
        }
        let popover = alert.popoverPresentationController
        popover?.sourceRect = CGRect(x: self.view.bounds.maxX, y: self.view.bounds.maxY, width: 0, height: 0)
        popover?.sourceView = self.view
        present(alert.fixConstraints(), animated: true, completion: nil)
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
            //            print("Location data received.")
            //            print(location)
            //            self.pickedLocation = location
            self.pickedLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let alert = UIAlertController(title: "Picked location", message: "\(location)", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel))
            present(alert, animated: true, completion: nil)
            self.textField.text = "\(location)"
            showSendBtn()
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
        //        print(urls)
        //        print("import result : \(myURL)")
        path = myURL
        self.textField.text = myURL.lastPathComponent
        //        self.textField.text = "\(myURL)"
        showSendBtn()
        messageType = .document
    }
    
    public func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        //        print(documentPicker.directoryURL!)
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("document picker cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 60))
    
    private func hideBtns(hide:Bool, alpha: CGFloat){
        self.textField.isHidden = hide
        self.attachment.isHidden = hide
        self.camera.isHidden = hide
        self.send.isHidden = hide
        self.textField.alpha = alpha
        self.attachment.alpha = alpha
        self.camera.alpha = alpha
        self.send.alpha = alpha
    }
    
    private func recordViewConfig(){
        label.textAlignment = .left
        //        label.text = "Recording: "+audioRecorder.currentTime.description
        label.textColor = .red
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear], animations: {
            self.hideBtns(hide: true, alpha: 0.2)
            self.hstack.addArrangedSubview(self.label)
        }, completion: nil)
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        print(timer.fireDate)
        
        label.alpha = 0.2
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.label.alpha = 1.0}, completion: nil)
    }
    
    @objc func fireTimer() {
        if(self.audioRecorder != nil)
        {
            self.label.text = "Recording: " + String(format: "%.01f", self.audioRecorder.currentTime)
        }
    }
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    @objc func micTapped(){
        print("mic tapped")
        var obs: NSKeyValueObservation?
        recordingSession = AVAudioSession.sharedInstance()
        obs = recordingSession.observe(\.outputVolume) { (av, change) in
            //            print("volume \(av.outputVolume)")
            //            print(av)
            //            print(change)
            self.label.text = "\(change)"
        }
        print(obs ?? "observe")
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() {allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("recording start")
                        if self.audioRecorder == nil {
                            self.startRecording()
                            self.recordViewConfig()
                        } else {
                            self.finishRecording(success: true)
                        }
                    } else {
                        // failed to record!
                        print("not allowed")
                    }
                }
            }
        } catch {
            // failed to record!
            print("recording failed")
        }
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording_\(Date()).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            //            print(audioRecorder.currentTime)
            //            mic.image = UIImage(systemName: "stop.fill")
            UIView.transition(with: mic,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { self.mic.image = UIImage(systemName: "mic.slash") },
                              completion: nil)
            mic.tintColor = UIColor.red
        } catch {
            finishRecording(success: false)
            print("finish")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            //            mic.image = UIImage(systemName: "mic.fill")
            UIView.transition(with: mic,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: { self.mic.image = UIImage(systemName: "mic.fill") },
                              completion: nil)
            mic.tintColor = UIColor.lightGray
            print("success")
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear], animations: {
                self.label.removeFromSuperview()
                self.hideBtns(hide: false, alpha: 1.0)
            }, completion: nil)
        } else {
            //            mic.image = UIImage(systemName: "mic.fill")
            UIView.transition(with: mic,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: { self.mic.image = UIImage(systemName: "mic.fill") },
                              completion: nil)
            
            print("recording failed")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("finish")
            finishRecording(success: false)
        }
        //        print(recorder.url)
        path = recorder.url
        self.textField.text = recorder.url.lastPathComponent
        showSendBtn()
        messageType = .document
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print(error!)
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
            //            print("link url: \(url)")
        }
        return url
    }
    
    @objc func sendBtnTapped(){
        let messageText:String = textField.text!.trimmingCharacters(in: .whitespaces)
        let time = getTime()
        if(!messageText.isEmpty && isConnected){
            //        if(!messageText.isEmpty){
            
            _ = getLink(text: messageText)
            
            let msg = MessageData(roomId: "123", senderId: userid, text: messageText, isFirstUser: true, image: ImageData(image: imageToBase64(image: pickedImage), url: imagePAth), contact: pickedContact,location: pickedLocation, document: path, messageType: messageType, time: time)
    
            self.addMsg(msg: msg)
            
            sendBySocket(messageData: msg)
            //            print(messages)
            //            messageTableView.reloadData()
            //            textField.text = ""
            prepareForReuse()
            hideSendBtn()
//            messageTableView.scrollToBottom()
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
        self.textField.text = ""
        self.pickedImage = nil
        self.pickedContact = nil
        self.pickedLocation = nil
        self.path = nil
        self.imagePAth = nil
        //        pickedContactImage = nil
        self.messageType = .text
    }
    
    private func sendBySocket(messageData: MessageData){
        var encryptedMessage: String = ""
        do{
            encryptedMessage = try encrypt(text: messageData.text, symmetricKey: mysymmetricKey)
            print("encryptedMessage: \(encryptedMessage)")
        } catch let e{
            print(e)
        }
        let decryptedMessage:String = decrypt(text: encryptedMessage, symmetricKey: othersymmetricKey)
        print("decryptedMessage: \(decryptedMessage)")
        
        //        let base64EncodedImage = messageData.image?.image?.jpegData(compressionQuality: 0.0)?.base64EncodedString()
        //        let base64EncodedVideo = messageData.image?.url?.path
        //        print(base64EncodedImage?.count ?? "uncountable")
        //        soc.emit("newChatMessage", [
        //            "roomId": "123",
        //            "message": messageText,
        //            "image": base64EncodedImage as Any,
        //            "video": base64EncodedVideo as Any,
        //            "messageType": "\(messageData.messageType)",
        //            "senderId": userid
        //        ])
        
//        var base64EncodedDoc: String = ""
//        if let doc = messageData.document{
//            do {
//                let fileData = try Data.init(contentsOf: doc)
//                base64EncodedDoc = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
//                //            let decodeData = Data(base64Encoded: fileStream, options: .ignoreUnknownCharacters)
//            }
//            catch {
//                print(error)
//            }
//        }
        
        do {
            let jsonData = try JSONEncoder().encode(messageData)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            //            print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]
            soc.emit("newChatMessage",jsonString)
            self.prepareForReuse()
            //            soc.emit("newChatMessage",[
            ////             "roomId": "123",
            ////             "senderId": userid,
            //             "message": messageText,
            //             "data": jsonString
            //            ])
            
            
            // and decode it back
            //            let decodedSentences = try JSONDecoder().decode([Sentence].self, from: jsonData)
            //            print(decodedSentences)
        } catch { print(error) }
        
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
        rightMenuConfig()
    }
    
    private func titleConfig(){
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        
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
        
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileTapped)))
    }
    
    private func rightMenuConfig(){
        var menuItems: [UIAction] {
            return [
                UIAction(title: NSLocalizedString("View Contact", comment: ""), image: UIImage(systemName: "person.text.rectangle"), handler: { (_) in
                    let vc = (self.storyboard?.instantiateViewController(identifier: "ChatUserProfileViewController"))! as ChatUserProfileViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }),
                UIAction(title: NSLocalizedString("Search", comment: ""), image: UIImage(systemName: "magnifyingglass"), handler: { (_) in
                }),
                UIAction(title: NSLocalizedString("Mute Notifications", comment: ""), image: UIImage(systemName: "bell.slash"), attributes: .destructive, handler: { (_) in
                }),
                UIAction(title: NSLocalizedString("Clear Chat", comment: ""), image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in
                    self.messages = []
                    self.messageTableView.reloadData()
                }),
                UIAction(title: NSLocalizedString("Block", comment: ""), image: UIImage(systemName: "lock"), attributes: .destructive, handler: { (_) in
                }),
            ]
        }
        
        var demoMenu: UIMenu {
            return UIMenu(title: "My menu", image: nil, identifier: nil, options: [], children: menuItems)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", image: UIImage(named:"more-20"), primaryAction: nil, menu: demoMenu)
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        print("menu tapped")
        //        let interaction = UIContextMenuInteraction(delegate: self)
        //        menu.menu = UIMenu(title: "Edit",
        //                           image: UIImage(systemName: "photo"),
        //                           options: [.displayInline], // [], .displayInline, .destructive
        //                 children: [])
        //        menu.addInteraction(interaction)
    }
    
    @IBAction func callTapped(_ sender: Any) {
        print("call tapped")
    }
    
    @IBAction func videoTapped(_ sender: Any) {
        print("video tapped")
    }
    
    @objc func profileTapped(){
        print("profile Tapped")
        let vc = (self.storyboard?.instantiateViewController(identifier: "ChatUserProfileViewController"))! as ChatUserProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    
}
