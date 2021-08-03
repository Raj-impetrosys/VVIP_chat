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
        // Do any additional setup after loading the view.
    }
    
    private func navConfig(){
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    @IBAction func personBtnTapped(_ sender: Any) {
        print("person Btn Tapped")
    }
    
    @IBAction func ellipsisBtnTapped(_ sender: Any) {
        print("ellipsis Btn Tapped")
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
