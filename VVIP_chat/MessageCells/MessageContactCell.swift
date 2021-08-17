//
//  MessageContactCell.swift
//  VVIP_chat
//
//  Created by mac on 13/08/21.
//

import UIKit
import Foundation

class MessageContactCell: UITableViewCell {
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var messageContact: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    
    //    @IBOutlet weak var msgImage: UIImageView!
    var trailingConstraint : NSLayoutConstraint!
    var leadingConstrint : NSLayoutConstraint!
    var chatGray = UIColor(red: 69/255.0, green: 90/255.0, blue: 100/255.0, alpha: 1)
    var chatGreen = UIColor(red: 7/255.0, green: 94/255.0, blue: 84/255.0, alpha: 1)
    var url: URL!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageContact.text = nil
        leadingConstrint.isActive = false
        trailingConstraint.isActive = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBackgroundView?.isUserInteractionEnabled = true
        messageBackgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contactTapped(_:))))
        print("awake from nib")
    }
    
    @objc func contactTapped(_ sender: UITapGestureRecognizer) {
        print("contact tapped")
        print(url as Any)
        if(url != nil){
            if (UIApplication.shared.canOpenURL(url)){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }} else {
                //            let alert = UIAlertController(title: "Alert", message: "Cannot open dialer in this device", preferredStyle: .alert)
                print("Cannot open dialer in this device")
            }}
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return true
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //        print("selected: \(selected)")
        // Configure the view for the selected state
        if(selected){
            contentView.backgroundColor = #colorLiteral(red: 0.1072840765, green: 0.1896482706, blue: 0.3115866184, alpha: 1).withAlphaComponent(0.8)
        } else {
            contentView.backgroundColor = .clear
        }
    }
    
    func updateMessageCell(by message: MessageData){
        messageBackgroundView.layer.cornerRadius = 10
        
        messageBackgroundView.clipsToBounds = true
        trailingConstraint = messageBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        leadingConstrint = messageBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        messageContact.text = message.text
        if(message.contact!.phones!.count > 0){
            let contact: String = message.contact!.phones![0].trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "")
            url = URL(string: "telprompt://\(contact)")
            print(contact.trimmingCharacters(in: .whitespaces))
            print(url as Any)
        }
        contactImageView.image = message.contact?.image
        //        url = URL(string: String(ChatViewController().getLink(text: message.text)!))!
        if(message.isFirstUser){
            messageBackgroundView.backgroundColor = #colorLiteral(red: 0.293738246, green: 0.6559162736, blue: 0.8622517586, alpha: 1)
            trailingConstraint.isActive = true
            //            messageLabel.textAlignment = .left
        } else {
            messageBackgroundView.backgroundColor = chatGray
            leadingConstrint.isActive = true
            //            messageLabel.textAlignment = .left
        }
    }
    
}
