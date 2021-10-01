//
//  DragGesture.swift
//  VVIP_chat
//
//  Created by mac on 01/10/21.
//

import Foundation
import UIKit

extension ChatViewController{
    
    @objc func draggedSendBtn(sender:UIPanGestureRecognizer){
        print(sender.state.rawValue)
        self.view.bringSubviewToFront(send)
        let translation = sender.translation(in: self.send)
        
        switch sender.state {
        case .began:
            // Save the view's original position.
            send.center = CGPoint(x: send.center.x + translation.x, y: send.center.y)
            sender.setTranslation(CGPoint.zero, in: self.hstack)
            
        case .cancelled:
            // Add the X and Y translation to the view's original position.
            send.center = CGPoint(x: send.center.x + translation.x, y: send.center.y)
            sender.setTranslation(CGPoint.zero, in: self.hstack)
        //            send.center = timeSpan.center
        
        case .ended:
            // Add the X and Y translation to the view's original position.
            //            send.center = CGPoint(x: send.center.x + translation.x, y: send.center.y)
            //            sender.setTranslation(CGPoint.zero, in: self.hstack)
            send.center = timeSpan.center
            
        default:
            // On cancellation, return the piece to its original location.
            send.center = CGPoint(x: hstack.center.x, y: hstack.center.y)
        }
    }

}
