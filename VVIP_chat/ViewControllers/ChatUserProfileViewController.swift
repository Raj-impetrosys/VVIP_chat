//
//  ChatUserProfileViewController.swift
//  VVIP_chat
//
//  Created by mac on 31/08/21.
//

import UIKit

class ChatUserProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileConfig()
        rightMenuConfig()
    }
    
    private func rightMenuConfig(){
        var menuItems: [UIAction] {
            return [
                UIAction(title: "View in Address Book", image: UIImage(systemName: "person.text.rectangle"), handler: { (_) in
                    let vc = (self.storyboard?.instantiateViewController(identifier: "ChatUserProfileViewController"))! as ChatUserProfileViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }),
                UIAction(title: "Mute Notifications", image: UIImage(systemName: "bell.slash"), attributes: .destructive, handler: { (_) in
                }),
                UIAction(title: "Block", image: UIImage(systemName: "lock"), attributes: .destructive, handler: { (_) in
                }),
            ]
        }
        
        var demoMenu: UIMenu {
            return UIMenu(title: "My menu", image: nil, identifier: nil, options: [], children: menuItems)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", image: UIImage(named:"more-20"), primaryAction: nil, menu: demoMenu)
    }
    
    private func profileConfig(){
        profileImage.downloaded(from: "https://thumbs.dreamstime.com/b/doctor-holding-digital-tablet-meeting-room-portrait-beautiful-mature-woman-looking-camera-confident-female-using-164999229.jpg")
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
