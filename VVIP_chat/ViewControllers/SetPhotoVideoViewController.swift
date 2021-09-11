//
//  SetPhotoVideoViewController.swift
//  VVIP_chat
//
//  Created by mac on 11/09/21.
//

import UIKit

class SetPhotoVideoViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var hstackView: UIStackView!
    @IBOutlet var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        textFieldConfig()
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
