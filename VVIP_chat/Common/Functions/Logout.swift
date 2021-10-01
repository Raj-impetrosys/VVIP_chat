//
//  Logout.swift
//  VVIP_chat
//
//  Created by mac on 30/09/21.
//

import Foundation
import UIKit

func logoutAlert(self: UIViewController) -> UIAlertController{
    let alert = UIAlertController(title: "Alert".localized, message: "Do you want to logout?".localized, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "No".localized, style: .default, handler: {_ in
        self.dismiss(animated: true, completion: nil)
    }))
    
    alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: {_ in
        self.dismiss(animated: true, completion: nil)
    }))
    
    return alert
}
