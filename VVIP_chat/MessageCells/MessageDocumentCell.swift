//
//  MessageDocumentCell.swift
//  VVIP_chat
//
//  Created by mac on 17/08/21.
//

import UIKit

class MessageDocumentCell: UITableViewCell {
    
    weak var delegate:ChatViewControllerDelegate?
    var url: URL!
    
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var docSize: UILabel!
    @IBOutlet weak var fileBackgroundView: UIView!
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var docType: UILabel!
    @IBOutlet weak var time: UILabel!
    
    var trailingConstraint : NSLayoutConstraint!
    var leadingConstrint : NSLayoutConstraint!
    var chatGray = UIColor(red: 69/255.0, green: 90/255.0, blue: 100/255.0, alpha: 1)
    var chatGreen = UIColor(red: 7/255.0, green: 94/255.0, blue: 84/255.0, alpha: 1)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        leadingConstrint.isActive = false
        trailingConstraint.isActive = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBackgroundView!.isUserInteractionEnabled = true
        messageBackgroundView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(docTapped(_:))))
    }
    
    @objc func docTapped(_ sender: UITapGestureRecognizer) {
        print("doc tapped")
        self.delegate?.docTaped(url: url)
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return true
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        messageLabel.text = message.text
        self.url = message.document
        self.docSize.text = String(fileSize(fromPath: message.document!.path)!)
        self.docType.text = message.document?.pathExtension
        self.time.text = message.time
        if(message.isFirstUser){
            messageBackgroundView.backgroundColor = #colorLiteral(red: 0.293738246, green: 0.6559162736, blue: 0.8622517586, alpha: 1)
            trailingConstraint.isActive = true
            fileBackgroundView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.5464898768, blue: 0.7568627596, alpha: 1)
            checkMark.isHidden = false
        } else {
            messageBackgroundView.backgroundColor = chatGray
            leadingConstrint.isActive = true
            fileBackgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.2)
            checkMark.isHidden = true
        }
    }
}
