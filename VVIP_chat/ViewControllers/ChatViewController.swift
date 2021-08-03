//
//  ChatViewController.swift
//  VVIP_chat
//
//  Created by mac on 28/07/21.
//

import UIKit
import StreamChat
import StreamChatUI

class ChatViewController: ChatChannelListVC {

    override func viewDidLoad() {
        super.viewDidLoad()
//        navConfig()
        // Do any additional setup after loading the view.
    }
    
    override open func setUp() {
        let query = ChannelListQuery(filter: .containMembers(userIds: [ChatClient.shared.currentUserId!]))
        /// create a controller and assign it to this view controller
        controller = ChatClient.shared.channelListController(query: query)
        super.setUp()
    }
    
    @objc func personTapped(){
             print("person button click")
      }

    @objc func ellipsisTapped(){
             print("ellipsis button click")
        let vc = (self.storyboard?.instantiateViewController(identifier: "TabBarViewController"))! as TabBarViewController
        self.navigationController?.pushViewController(vc, animated: true)
      }
    
    private func navConfig(){
//        navigationController?.navigationBar.barTintColor = UIColor.green
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.293738246, green: 0.6559162736, blue: 0.8622517586, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Contacts"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        let person = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(self.personTapped))
        let ellipsis = UIBarButtonItem(image: UIImage(systemName: "ellipsis")?.rotate(1.5708), style: .plain, target: self, action: #selector(self.ellipsisTapped))
        self.navigationItem.rightBarButtonItems = [ellipsis,person]
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
