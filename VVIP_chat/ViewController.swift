//
//  ViewController.swift
//  VVIP_chat
//
//  Created by mac on 28/07/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navConfig()
        tabBarConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func tabBarConfig(){
        let mainVC = UIViewController()
        let searchVC = UIViewController()
        let profileVC = UIViewController()

        let tabBarController = TabBarViewController()
        tabBarController.viewControllers = [mainVC, searchVC, profileVC]
        
        tabBarController.selectedViewController = searchVC

        // Use the array index to select the third tab
        tabBarController.selectedIndex = 2
        
//        window!.rootViewController = tabBarController
        let item = UITabBarItem()
        item.title = "Home"
        item.image = UIImage(systemName: "house.fill")

        let homeVC = ViewController()
        homeVC.tabBarItem = item
        
//        ViewController.tabBarConfig(tabBarController)
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = .white
        let item1 = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        self.tabBarController?.tabBarItem = item1
    }
    
    func navConfig(){
//        navigationController?.navigationBar.barTintColor = UIColor.green
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.293738246, green: 0.6559162736, blue: 0.8622517586, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Contacts"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        let person = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(self.personTapped))
        let ellipsis = UIBarButtonItem(image: UIImage(systemName: "ellipsis")?.rotate(1.5708), style: .plain, target: self, action: #selector(self.ellipsisTapped))
        self.navigationItem.rightBarButtonItems = [ellipsis,person]
    }
    
    @objc func personTapped(){
             print("person button click")
      }

    @objc func ellipsisTapped(){
             print("ellipsis button click")
      }

}

