//
//  SocketMsgViewController.swift
//  VVIP_chat
//
//  Created by mac on 03/08/21.
//

import UIKit
//
//  MessageKitViewController.swift
//  SocketDemo
//
//  Created by mac on 31/07/21.
//

import UIKit

class SocketMsgViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var messages: [MessageData] = [MessageData(text: "Hey", isFirstUser: true, image: nil), MessageData(text: "Hello", isFirstUser: false, image: nil), MessageData(text: "I am Raj from India, working as a Flutter and IOS developer at Impetrosys", isFirstUser: true, image: nil), MessageData(text: "okay, I am jack from US", isFirstUser: false, image: nil), MessageData(text: "Okay", isFirstUser: true, image: nil), MessageData(text: "Nice to chat with you", isFirstUser: false, image: nil)]
    
    let firstAttribute : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.blue]
    let secondAttribute : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.blue]

    var useFirstAttribute: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.bounces = false
        messageTableView.delegate = self
        messageTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendMsg(_ sender: Any) {
        let msg = MessageData(text: textField.text!, isFirstUser: true, image: nil)
        messages.append(msg)
        print(messages)
//        self.tableView.reloadData()
        messageTableView.reloadData()
        textField.text = ""
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: TableViewDelegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        cell.updateMessageCell(by: messages[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
