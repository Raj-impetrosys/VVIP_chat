//
//  TabBarViewController.swift
//  VVIP_chat
//
//  Created by mac on 28/07/21.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarConfig()
        // Do any additional setup after loading the view.
    }
    
    private func tabBarConfig(){
        self.selectedIndex = 2
        //        self.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        ////        self.tabBar.tintColor = .white
        ////        self.tabBar.backgroundColor = #colorLiteral(red: 0.1072840765, green: 0.1896482706, blue: 0.3115866184, alpha: 1)
        //
        //        let item = UITabBarItem()
        //        item.title = "Home"
        //        item.image = UIImage(named: "home_icon")
        //
        ////        let homeVC = HomeViewController()
        //        self.tabBarItem = item
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
