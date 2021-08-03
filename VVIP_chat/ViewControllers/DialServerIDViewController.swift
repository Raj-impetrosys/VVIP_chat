//
//  DialServerIDViewController.swift
//  VVIP_chat
//
//  Created by mac on 30/07/21.
//

import UIKit

class DialServerIDViewController: UIViewController {
    @IBOutlet weak var dialScreenLbl: UILabel!
    @IBOutlet weak var key1: UIView!
    @IBOutlet weak var key2: UIView!
    @IBOutlet weak var key3: UIView!
    @IBOutlet weak var key4: UIView!
    @IBOutlet weak var key5: UIView!
    @IBOutlet weak var key6: UIView!
    @IBOutlet weak var key7: UIView!
    @IBOutlet weak var key8: UIView!
    @IBOutlet weak var key9: UIView!
    @IBOutlet weak var key0: UIView!
    @IBOutlet weak var delete: UIImageView!
    @IBOutlet weak var enterServerId: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dialConfig()
        // Do any additional setup after loading the view.
    }
    
    private func dialConfig(){
        dialScreenLbl.text = ""

        let key1Gstr = UITapGestureRecognizer(target: self, action:  #selector(self.key1Pressed))
        let key2Gstr = UITapGestureRecognizer(target: self, action:  #selector(self.key2Pressed))
        let key3Gstr = UITapGestureRecognizer(target: self, action:  #selector(self.key3Pressed))
        let key4Gstr = UITapGestureRecognizer(target: self, action:  #selector(self.key4Pressed))
        let key5Gstr = UITapGestureRecognizer(target: self, action:  #selector(self.key5Pressed))
        let key6Gstr = UITapGestureRecognizer(target: self, action:  #selector(self.key6Pressed))
        let key7Gstr = UITapGestureRecognizer(target: self, action:  #selector(self.key7Pressed))
        let key8Gstr = UITapGestureRecognizer(target: self, action:  #selector(self.key8Pressed))
        let key9Gstr = UITapGestureRecognizer(target: self, action:  #selector(self.key9Pressed))
        let key0Gstr = UITapGestureRecognizer(target: self, action:  #selector(self.key0Pressed))
        let deleteGstr = UITapGestureRecognizer(target: self, action:  #selector(self.deletePressed))
        let deleteLongTapGstr = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed))
        let enterServerIDGstr = UITapGestureRecognizer(target: self, action:  #selector(self.enterServerIDPressed))
        key1.addGestureRecognizer(key1Gstr)
        key2.addGestureRecognizer(key2Gstr)
        key3.addGestureRecognizer(key3Gstr)
        key4.addGestureRecognizer(key4Gstr)
        key5.addGestureRecognizer(key5Gstr)
        key6.addGestureRecognizer(key6Gstr)
        key7.addGestureRecognizer(key7Gstr)
        key8.addGestureRecognizer(key8Gstr)
        key9.addGestureRecognizer(key9Gstr)
        key0.addGestureRecognizer(key0Gstr)
        delete.addGestureRecognizer(deleteGstr)
        delete.addGestureRecognizer(deleteLongTapGstr)
        enterServerId.addGestureRecognizer(enterServerIDGstr)
    }
    
    @objc func key1Pressed(sender : UITapGestureRecognizer) {
        print("1 tapped")
        dialScreenLbl.text = dialScreenLbl.text!+"1"
    }
    
    @objc func key2Pressed(sender : UITapGestureRecognizer) {
        print("2 tapped")
        dialScreenLbl.text = dialScreenLbl.text!+"2"
    }
    
    @objc func key3Pressed(sender : UITapGestureRecognizer) {
        print("3 tapped")
        dialScreenLbl.text = dialScreenLbl.text!+"3"
    }
    
    @objc func key4Pressed(sender : UITapGestureRecognizer) {
        print("4 tapped")
        dialScreenLbl.text = dialScreenLbl.text!+"4"
    }
    
    @objc func key5Pressed(sender : UITapGestureRecognizer) {
        print("5 tapped")
        dialScreenLbl.text = dialScreenLbl.text!+"5"
    }
    
    @objc func key6Pressed(sender : UITapGestureRecognizer) {
        print("6 tapped")
        dialScreenLbl.text = dialScreenLbl.text!+"6"
    }
    
    @objc func key7Pressed(sender : UITapGestureRecognizer) {
        print("7 tapped")
        dialScreenLbl.text = dialScreenLbl.text!+"7"
    }
    
    @objc func key8Pressed(sender : UITapGestureRecognizer) {
        print("8 tapped")
        dialScreenLbl.text = dialScreenLbl.text!+"8"
    }
    
    @objc func key9Pressed(sender : UITapGestureRecognizer) {
        print("9 tapped")
        dialScreenLbl.text = dialScreenLbl.text!+"9"
    }

    @objc func key0Pressed(sender : UITapGestureRecognizer) {
        print("0 tapped")
        dialScreenLbl.text = dialScreenLbl.text!+"0"
    }
    
    @objc func deletePressed(sender : UITapGestureRecognizer) {
        print("delete tapped")
        if(dialScreenLbl.text != ""){
            dialScreenLbl.text?.remove(at: (dialScreenLbl.text?.index(before: dialScreenLbl.text!.endIndex))!)
        }
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer)
    {
        print("longpressed")
//        if(dialScreenLbl.text != ""){
//            dialScreenLbl.text?.remove(at: (dialScreenLbl.text?.index(before: dialScreenLbl.text!.endIndex))!)
//        }
        dialScreenLbl.text = ""
    }
    
    @objc func enterServerIDPressed(sender : UITapGestureRecognizer) {
        print("Enter server Id tapped")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DialPinViewController") as! DialPinViewController
        if(!dialScreenLbl.text!.isEmpty){
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "Alert",
                                          message: "Please Enter Server ID",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }
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
