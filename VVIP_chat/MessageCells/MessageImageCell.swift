//
//  MessageImageCell.swift
//  VVIP_chat
//
//  Created by mac on 10/08/21.
//

import UIKit

class MessageImageCell: UITableViewCell {
    weak var delegate:ChatViewControllerDelegate?

    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var messageImage: UIImageView!
    var trailingConstraint : NSLayoutConstraint!
    var leadingConstrint : NSLayoutConstraint!
    var chatGray = UIColor(red: 69/255.0, green: 90/255.0, blue: 100/255.0, alpha: 1)
    var chatGreen = UIColor(red: 7/255.0, green: 94/255.0, blue: 84/255.0, alpha: 1)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageImage.image = nil
        leadingConstrint.isActive = false
        trailingConstraint.isActive = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageImage?.isUserInteractionEnabled = true
        messageImage!.isUserInteractionEnabled = true
        messageImage!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        print("image tapped")
        delegate?.cellTaped(image: messageImage.image!)
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
        messageImage.image = message.image?.image
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

class ImageViewController: ViewController{
    var image: UIImage! = UIImage(named: "nature")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.1072840765, green: 0.1896482706, blue: 0.3115866184, alpha: 1).withAlphaComponent(0.9)
//        navigationConfig()
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: Constants.width, height: Constants.height));
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.view.addSubview(imageView)
    }
    
    private func navigationConfig() {
        self.navigationController?.isNavigationBarHidden = true
    }
}
