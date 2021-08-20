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
    @IBOutlet weak var edit: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageAccount.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(manageAccountTapped)))
        privacyAndSecurity.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(privacyAndSecurityTapped)))
        languge.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(languageTapped)))
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
    
//    @IBOutlet weak var usernameField: UITextField!
//    @IBOutlet weak var hstackView: UIStackView!
//    @IBOutlet var image: UIImageView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        usernameField.delegate = self
//        textFieldConfig()
////        image.image = UIImage(systemName: "person.fill")
//    }
//
//    private func textFieldConfig(){
//        usernameField.attributedPlaceholder = NSAttributedString(string: "User Name",
//                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemTeal.withAlphaComponent(0.5)])
//        hstackView.layer.borderWidth = 1
//        hstackView.layer.borderColor = UIColor.white.cgColor
//        hstackView.layer.cornerRadius = 10
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool
//     {
//     textField.resignFirstResponder()
//            return true;
//        }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        usernameField.resignFirstResponder()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
