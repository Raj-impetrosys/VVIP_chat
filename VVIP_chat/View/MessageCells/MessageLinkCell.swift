//
//  MessageLinkCell.swift
//  VVIP_chat
//
//  Created by mac on 11/08/21.
//

import UIKit

class MessageLinkCell: UITableViewCell {
    
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var messageLink: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
    var trailingConstraint : NSLayoutConstraint!
    var leadingConstrint : NSLayoutConstraint!
    var chatGray = UIColor(red: 69/255.0, green: 90/255.0, blue: 100/255.0, alpha: 1)
    var chatGreen = UIColor(red: 7/255.0, green: 94/255.0, blue: 84/255.0, alpha: 1)
    var url: URL!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLink.text = nil
        time.text = nil
//        checkMark.image = nil
        leadingConstrint.isActive = false
        trailingConstraint.isActive = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLink?.isUserInteractionEnabled = true
        messageLink?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkTapped(_:))))
    }
    
    @objc func linkTapped(_ sender: UITapGestureRecognizer) {
        print("link tapped")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
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
        messageLink.text = message.text
        self.time.text = message.time
        url = URL(string: String(ChatViewController().getLink(text: message.text)!))!
        if(message.isFirstUser){
            messageBackgroundView.backgroundColor = #colorLiteral(red: 0.293738246, green: 0.6559162736, blue: 0.8622517586, alpha: 1).withAlphaComponent(1.0)
            trailingConstraint.isActive = true
            checkMark.isHidden = false
            time.textColor = .black
        } else {
            messageBackgroundView.backgroundColor = chatGray
            leadingConstrint.isActive = true
            checkMark.isHidden = true
            time.textColor = .white
        }
    }
    
}
