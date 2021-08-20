//
//  ManageAccountViewController.swift
//  VVIP_chat
//
//  Created by mac on 19/08/21.
//

import UIKit

class ManageAccountViewController: UIViewController {
    @IBOutlet weak var textField:UITextField!
    @IBOutlet weak var textField1:UITextField!
    @IBOutlet weak var lockBtn: UIImageView!
    @IBOutlet weak var lockBtn1: UIImageView!
    var showPwd: Bool = true
    var showPwd1: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldConfig()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func textFieldConfig(){
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        textField1.attributedPlaceholder = NSAttributedString(string: "Re-Enter Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        
        lockBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTapped)))
        lockBtn1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(show1Tapped)))
    }
    
    @objc func showTapped(){
        showPwd.toggle()
        textField.isSecureTextEntry = showPwd
    }
    
    @objc func show1Tapped(){
        showPwd1.toggle()
        textField1.isSecureTextEntry = showPwd1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        textField1.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
        textField1.resignFirstResponder()
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
