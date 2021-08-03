//
//  SceneDelegate.swift
//  VVIP_chat
//
//  Created by mac on 28/07/21.
//

import UIKit
import StreamChat

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
//        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
//        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let _ = (scene as? UIWindowScene) else { return }
//    }
    
//    func scene(
//        _ scene: UIScene,
//        willConnectTo session: UISceneSession,
//        options connectionOptions: UIScene.ConnectionOptions
//    ) {
////        guard let scene = scene as? UIWindowScene else { return }
////                scene.windows.forEach { $0.tintColor = .systemPink }
//        //fd7cjqdbrxwswbrd447q275gwpda643va9q59wpf2egnnd23u2qgbnccmfc6fptq
//        let config = ChatClientConfig(apiKey: .init("rvst3b3ds67f"))
//        let token =
//            Token(
//                stringLiteral: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic3RlZXAtcml2ZXItMCJ9.Gr5h_Huu3fV0yp3_VL_VaziWUkTg5AfI2XrlfFkwe9s"
//            )
//
//        /// create an instance of ChatClient and share it using the singleton
//        ChatClient.shared = ChatClient(config: config)
//
//        /// connect to chat
//        ChatClient.shared.connectUser(
//            userInfo: UserInfo(
//                id: "tutorial-droid",
//                name: "Tutorial Droid",
//                imageURL: URL(string: "https://bit.ly/2TIt8NR")
//            ),
//            token: token
//        )
//    }
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
//        guard let scene = scene as? UIWindowScene else { return }
//                scene.windows.forEach { $0.tintColor = .systemPink }

        let config = ChatClientConfig(apiKey: .init("b67pax5b2wdq"))
        let token =
            Token(
                stringLiteral: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHV0b3JpYWwtZHJvaWQifQ.NhEr0hP9W9nwqV7ZkdShxvi02C5PR7SJE7Cs4y7kyqg"
            )

        /// create an instance of ChatClient and share it using the singleton
        ChatClient.shared = ChatClient(config: config)

        /// connect to chat
        ChatClient.shared.connectUser(
            userInfo: UserInfo(
                id: "tutorial-droid",
                name: "Tutorial Droid",
                imageURL: URL(string: "https://bit.ly/2TIt8NR")
            ),
            token: token
        )
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

