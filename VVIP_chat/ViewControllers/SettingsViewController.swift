//
//  SettingsViewController.swift
//  VVIP_chat
//
//  Created by mac on 28/07/21.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var manageAccount: UIStackView!
    @IBOutlet weak var privacyAndSecurity: UIStackView!
    @IBOutlet weak var appearance: UIStackView!
    @IBOutlet weak var languge: UIStackView!
    @IBOutlet weak var aboutUs: UIStackView!
    @IBOutlet weak var logout: UIStackView!
    @IBOutlet weak var edit: UIBarButtonItem!
    @IBOutlet weak var more: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightMenuConfig()
        manageAccount.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(manageAccountTapped)))
        privacyAndSecurity.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(privacyAndSecurityTapped)))
        appearance.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(appearanceTapped)))
        languge.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(languageTapped)))
        aboutUs.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(aboutUsTapped)))
        logout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutTapped)))
    }
    
    private func rightMenuConfig(){
        let barButtonMenu = UIMenu(title: "", children: [
            UIAction(title: NSLocalizedString("Notification", comment: ""), image: UIImage(systemName: "bell"), handler: {_ in}),
            UIAction(title: NSLocalizedString("Logout", comment: ""), image: UIImage(systemName: "arrow.right.doc.on.clipboard"), handler: {_ in})
        ])
        more.menu = barButtonMenu
    }
    
    @objc func appearanceTapped(){
        print("Appearence tapped")
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "AppearenceViewController")) as! AppearenceViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func aboutUsTapped(){
        print("about us tapped")
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController")) as! AboutUsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func logoutTapped(){
        let alert = UIAlertController(title: "Alert", message: "Do you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func manageAccountTapped(){
        print("manage Account tapped")
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "ManageAccountViewController")) as! ManageAccountViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func privacyAndSecurityTapped(){
        print("privacy And Security tapped")
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "PrivacyAndSecuritiesViewController")) as! PrivacyAndSecuritiesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func languageTapped(){
        print("language tapped")
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "LanguageViewController")) as! LanguageViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
