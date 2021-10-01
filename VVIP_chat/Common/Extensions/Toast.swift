//
//  Toast.swift
//  VVIP_chat
//
//  Created by mac on 01/10/21.
//

import Foundation
import UIKit

extension UIViewController {

    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height - 200, width: self.view.frame.size.width  , height: 45))
        toastLabel.backgroundColor = UIColor.white
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
