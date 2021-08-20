//
//  AppDelegate.swift
//  VVIP_chat
//
//  Created by mac on 28/07/21.
//

import UIKit
//import StreamChat

//extension ChatClient {
//    static var shared: ChatClient!
//}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("application launched")
        keyConfig()
        return true
    }
    
    private func keyConfig(){
        let myprivateKey = generatePrivateKey()
        let otherprivateKey = generatePrivateKey()

//        let mypublicKey = myprivateKey.publicKey
//        let otherpublicKey = otherprivateKey.publicKey

//        print("myprivateKey: \(myprivateKey)")
//        print("otherprivateKey: \(otherprivateKey)")
//        print("mypublicKey: \(mypublicKey)")
//        print("ckpublicKey: \(otherpublicKey)")
//
        let myexportedPrivateKey = exportPrivateKey(myprivateKey)
        let otherexportedPrivateKey = exportPrivateKey(otherprivateKey)
//
////        Constants._privateKey = rkprivateKey
        saveData(key: "myprivateKey", data: myexportedPrivateKey)
        saveData(key: "otherprivateKey", data: otherexportedPrivateKey)
//
//        print("myexportedPrivateKey: \(myexportedPrivateKey)")
//        print("otherexportedPrivateKey: \(otherexportedPrivateKey)")
//
//        do{
//            let myimportPrivateKey = try importPrivateKey(myexportedPrivateKey)
//            let otherimportPrivateKey = try importPrivateKey(otherexportedPrivateKey)
//            print("myimportPrivateKey: \(myimportPrivateKey)")
//            print("otherimportPrivateKey: \(otherimportPrivateKey)")
//        } catch let e{
//            print("Could not imported PrivateKey: \(e.localizedDescription)")
//        }
//
//        var encryptedMessage: String = ""
//        do{
//            let mysymmetricKey = try deriveSymmetricKey(privateKey: myprivateKey, publicKey: otherpublicKey)
//            let othersymmetricKey = try deriveSymmetricKey(privateKey: otherprivateKey, publicKey: mypublicKey)
//
//            encryptedMessage = try encrypt(text: "this is rk", symmetricKey: mysymmetricKey)
//            print("encryptedMessage: \(encryptedMessage)")
//
//            let decryptedMessage = decrypt(text: encryptedMessage, symmetricKey: othersymmetricKey)
//            print("decryptedMessage: \(decryptedMessage)")
////            alert(title: encryptedMessage, msg: decryptedMessage)
//        } catch let e{
//            print("Could not imported symmetricKey: \(e.localizedDescription)")
//        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

