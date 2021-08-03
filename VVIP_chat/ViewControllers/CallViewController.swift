//
//  CallViewController.swift
//  VVIP_chat
//
//  Created by mac on 28/07/21.
//

import UIKit
//import StreamChat
//import StreamChatUI

class CallViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var personBtn: UIBarButtonItem!
    @IBOutlet weak var ellipsisBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ellipsisBtn.customView?.transform = CGAffineTransform(rotationAngle: 270)
//        self.view.backgroundColor = #colorLiteral(red: 0.03266010061, green: 0.09940122813, blue: 0.2329473794, alpha: 1)
        navConfig()
        // Do any additional setup after loading the view.
    }
    
//    override open func setUp() {
//        let query = ChannelListQuery(filter: .containMembers(userIds: [ChatClient.shared.currentUserId!]))
//        /// create a controller and assign it to this view controller
//        controller = ChatClient.shared.channelListController(query: query)
//        super.setUp()
//    }
    
//    
//    /// Main point of customization for the view appearance.
//    /// It's called zero or one time(s) during the view's lifetime.
//    /// The default implementation of this method is empty so calling `super` is usually not needed.
//    override func setUpAppearance() { }
// 
//    /// Main point of customization for the view layout.
//    /// It's called zero or one time(s) during the view's lifetime.
//    /// Calling super is recommended but not required if you provide a complete layout for all subviews.
//    override func setUpLayout() { }
// 
//    /// Main point of customization for the view appearance.
//    /// It's called every time view's content changes.
//    /// Calling super is recommended but not required
//    /// if you update the content of all subviews of the view.
//    override func updateContent() { }
    
    private func navConfig(){
        navBar.backgroundColor = #colorLiteral(red: 0.293738246, green: 0.6559162736, blue: 0.8622517586, alpha: 1)
        navBar.tintColor = #colorLiteral(red: 0.293738246, green: 0.6559162736, blue: 0.8622517586, alpha: 1)
        navBar.barTintColor = #colorLiteral(red: 0.293738246, green: 0.6559162736, blue: 0.8622517586, alpha: 1)
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
