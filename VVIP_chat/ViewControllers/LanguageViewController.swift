//
//  LanguageViewController.swift
//  VVIP_chat
//
//  Created by mac on 19/08/21.
//

import UIKit

class LanguageViewController: UIViewController {
    @IBOutlet weak var chinese: UILabel!
    @IBOutlet weak var english: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chinese.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chineseTapped)))
        english.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(englishTapped)))
    }
    
    @objc func chineseTapped(){
        print("chinese")
        UserDefaults.standard.set(["ch"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    @objc func englishTapped(){
        print("english")
        UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
