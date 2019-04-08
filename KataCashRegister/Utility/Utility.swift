//
//  Utility.swift
//  KataCashRegister
//
//  Created by NSMeter on 08/04/19.
//  Copyright © 2019 KataBNPPF. All rights reserved.
//

import UIKit

extension  UIViewController{
    
    func showSucsessAlert(withTitle title: String, andMessage message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView{
    
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 5, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 5, y: self.center.y)
        self.layer.add(animation, forKey: "position")
    }
    
}

extension Double {
    var roundUpString:String {
        return String(format: "$ %.2f", self)
    }
}
