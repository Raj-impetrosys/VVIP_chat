//
//  FriendsViewController.swift
//  VVIP_chat
//
//  Created by mac on 28/07/21.
//

import UIKit

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var personBtn: UIBarButtonItem!
    @IBOutlet weak var ellipsisBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navConfig()
    }
    
    private func navConfig(){
        rightMenuConfig()
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    private func rightMenuConfig(){
        let barButtonMenu = UIMenu(title: "", children: [
            UIAction(title: NSLocalizedString("Invite a friend", comment: ""), image: UIImage(systemName: "person.crop.circle.badge.plus"), handler: {_ in}),
            UIAction(title: NSLocalizedString("Add Contact", comment: ""), image: UIImage(systemName: "person.badge.plus"), handler: {_ in}),
            UIAction(title: NSLocalizedString("Referesh", comment: ""), image: UIImage(systemName: "arrow.clockwise"), handler: {_ in}),
            UIAction(title: NSLocalizedString("search", comment: ""), image: UIImage(systemName: "magnifyingglass"), handler: {_ in})
        ])
        ellipsisBtn.menu = barButtonMenu
    }
    
    @IBAction func personBtnTapped(_ sender: Any) {
        print("person Btn Tapped")
    }
    
    @IBAction func ellipsisBtnTapped(_ sender: Any) {
        print("ellipsis Btn Tapped")
    }
}
