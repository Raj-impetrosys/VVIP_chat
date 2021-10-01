//
//  AboutUsViewController.swift
//  VVIP_chat
//
//  Created by mac on 20/08/21.
//

import UIKit

class AboutUsViewController: UIViewController {
    @IBOutlet weak var aboutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelConfig()
        // Do any additional setup after loading the view.
    }
    
    private func labelConfig(){
        aboutLabel.text = """
VVIP chat from VVIP is a FREE messaging and video calling app. It’s used by over 2B people in more than 180 countries. It’s simple, reliable, and private, so you can easily keep in touch with your friends and family. VVIP works across mobile and desktop even on slow connections, with no subscription fees*.

**Private messaging across the world**

Your personal messages and calls to friends and family are end-to-end encrypted. No one outside of your chats, not even VVIP, can read or listen to them.

**Simple and secure connections, right away**

All you need is your phone number, no user names or logins. You can quickly view your contacts who are on VVIP and start messaging.

**High quality voice and video calls**

Make secure video and voice calls with up to 8 people for free*. Your calls work across mobile devices using your phone’s Internet service, even on slow connections.

**Group chats to keep you in contact**

Stay in touch with your friends and family. End-to-end encrypted group chats let you share messages, photos, videos and documents across mobile and desktop.

**Stay connected in real time**

Share your location with only those in your individual or group chat, and stop sharing at any time. Or record a voice message to connect quickly.

**Share daily moments through Status**

Status allows you to share text, photos, video and GIF updates that disappear after 24 hours. You can choose to share status posts with all your contacts or just selected ones.


*Data charges may apply. Contact your provider for details.

---------------------------------------------------------

If you have any feedback or questions, please go to **VVIP** > **Settings** > **Help** > **Contact Us**

""".localized
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
