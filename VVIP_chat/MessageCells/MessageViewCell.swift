//
//  MessageViewCell.swift
//  VVIP_chat
//
//  Created by mac on 03/08/21.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var checkMark: UIImageView!

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
        // Initialization code
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
        messageLabel.text = message.text
        self.time.text = message.time
        if(message.isFirstUser){
            messageBackgroundView.backgroundColor = #colorLiteral(red: 0.293738246, green: 0.6559162736, blue: 0.8622517586, alpha: 1)
            trailingConstraint.isActive = true
//            messageLabel.textAlignment = .left
            checkMark.isHidden = false
//            isMe = true
        } else {
            messageBackgroundView.backgroundColor = chatGray
            leadingConstrint.isActive = true
//            messageLabel.textAlignment = .left
            checkMark.isHidden = true
//            isMe = false
        }
    }
}

var isMe:Bool = true

class backView: UIView{
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        if isMe{
            bezierPath.move(to: CGPoint(x: rect.maxX+5, y: rect.minY))//a
            bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))//b
            bezierPath.addLine(to: CGPoint(x: rect.maxX-10, y: 10))//c
            bezierPath.addLine(to: CGPoint(x: rect.maxX-10, y: rect.maxY-5))//d
            bezierPath.addQuadCurve(to: CGPoint(x: rect.maxX-15, y: rect.maxY), controlPoint: CGPoint(x: rect.maxX-10, y: rect.maxY))
            bezierPath.addLine(to: CGPoint(x: rect.maxX-15, y: rect.maxY))//e
            
            bezierPath.addLine(to: CGPoint(x:rect.minX+5, y:rect.maxY))//f
            bezierPath.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY-5), controlPoint: CGPoint(x: rect.minX, y: rect.maxY))
            bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY-5))//g
            bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY+5))//h
            bezierPath.addQuadCurve(to: CGPoint(x: rect.minX+5, y: rect.minY), controlPoint: CGPoint(x: rect.minX, y: rect.minY))
            bezierPath.addLine(to: CGPoint(x: rect.minX+5, y: rect.minY))//i
        } else {
            bezierPath.move(to: CGPoint(x: rect.maxX, y: rect.minY))//a
            bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))//b
            bezierPath.addLine(to: CGPoint(x: rect.maxX, y: 10))//c
            bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY-5))//d
            bezierPath.addQuadCurve(to: CGPoint(x: rect.maxX-15, y: rect.maxY), controlPoint: CGPoint(x: rect.maxX, y: rect.maxY))
            bezierPath.addLine(to: CGPoint(x: rect.maxX-15, y: rect.maxY))//e
            
            bezierPath.addLine(to: CGPoint(x:rect.minX+15, y:rect.maxY))//f
            //            bezierPath.addQuadCurve(to: CGPoint(x: rect.minX+15, y: rect.maxY-5), controlPoint: CGPoint(x: rect.minX+10, y: rect.maxY-10))
            //            bezierPath.addQuadCurve(to: CGPoint(x: rect.minX+15, y: rect.maxY), controlPoint: CGPoint(x: rect.minX+15, y: rect.maxY))
            bezierPath.addQuadCurve(to: CGPoint(x: rect.minX+15, y: rect.maxY), controlPoint: CGPoint(x: rect.minX, y: rect.maxY))
            bezierPath.addLine(to: CGPoint(x: rect.minX+10, y: rect.maxY-5))//g
            bezierPath.addLine(to: CGPoint(x: rect.minX+10, y: rect.minY+5))//h
            bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            //            bezierPath.addQuadCurve(to: CGPoint(x: rect.minX+15, y: rect.minY), controlPoint: CGPoint(x: rect.minX-10, y: rect.minY))
            bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))//i
        }
        
        if isMe{
            UIColor.blue.setFill()
        } else {
            UIColor.gray.setFill()
        }
        
        bezierPath.fill()
        bezierPath.close()
    }
}
