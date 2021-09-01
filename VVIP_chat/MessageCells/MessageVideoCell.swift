//
//  MessageVideoCell.swift
//  VVIP_chat
//
//  Created by mac on 16/08/21.
//

import UIKit

class MessageVideoCell: UITableViewCell {
    
    weak var delegate:ChatViewControllerDelegate?
    var url: URL!
    
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var checkMark: UIImageView!

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
        messageImage!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(videoTapped(_:))))
    }
    
    @objc func videoTapped(_ sender: UITapGestureRecognizer) {
        print("video tapped")
        delegate?.videoTaped(url: url)
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
        messageImage.image = message.image?.image
        self.url = message.image?.url
        self.time.text = message.time

        if(message.isFirstUser){
            messageBackgroundView.backgroundColor = #colorLiteral(red: 0.293738246, green: 0.6559162736, blue: 0.8622517586, alpha: 1)
            trailingConstraint.isActive = true
            checkMark.isHidden = false
        } else {
            messageBackgroundView.backgroundColor = chatGray
            leadingConstrint.isActive = true
            checkMark.isHidden = true
        }
    }
    
}

class VideoViewController: ViewController{
    var image: UIImage! = UIImage(named: "nature")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.1072840765, green: 0.1896482706, blue: 0.3115866184, alpha: 1).withAlphaComponent(0.9)
        //        navigationConfig()
        //        self.restorationIdentifier = "ImageViewController"
        //        self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController")
        //        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: .max, height: .max))
        //        imageView.image = image
        //        self.view.addSubview(imageView)
        
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
