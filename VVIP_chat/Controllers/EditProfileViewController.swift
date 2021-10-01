//
//  EditProfileViewController.swift
//  VVIP_chat
//
//  Created by mac on 20/08/21.
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var designtionField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFieldConfig()
        //        keyBoardConfig()
    }
    
    private func txtFieldConfig(){
        titleField.delegate = self
        designtionField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        countryField.delegate = self
        stateField.delegate = self
        cityField.delegate = self
        zipField.delegate = self
        placeholderText(field: titleField, text: "Enter Title".localized)
        placeholderText(field: designtionField, text: "Enter designation".localized)
        placeholderText(field: firstNameField, text: "Enter first name".localized)
        placeholderText(field: lastNameField, text: "Enter last name".localized)
        placeholderText(field: emailField, text: "Enter email".localized)
        placeholderText(field: countryField, text: "Enter country".localized)
        placeholderText(field: stateField, text: "Enter state".localized)
        placeholderText(field: cityField, text: "Enter city".localized)
        placeholderText(field: zipField, text: "Enter zip".localized)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        titleField.resignFirstResponder()
        designtionField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        countryField.resignFirstResponder()
        stateField.resignFirstResponder()
        cityField.resignFirstResponder()
        zipField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleField.resignFirstResponder()
        designtionField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        countryField.resignFirstResponder()
        stateField.resignFirstResponder()
        cityField.resignFirstResponder()
        zipField.resignFirstResponder()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func keyBoardConfig(){
        //        hstack.bindToKeyboard()
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: (scrollView.frame.size.height + 300))// To be more specific, I have used multiple textfields so wanted to scroll to the end.So have given the constant 300.
    }
    
    func textFieldDidBeginEditing(_ textField:UITextField) {
        //        self.scrollView.setContentOffset(textField.frame.origin, animated: true)
        //        var point = textField.frame.origin
        //        point.y = point.y - 5
        //        scrollView.setContentOffset(point, animated: true)
        //        textField.becomeFirstResponder()
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
