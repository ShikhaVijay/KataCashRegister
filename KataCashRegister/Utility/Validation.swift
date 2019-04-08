//
//  Validation.swift
//  KataCashRegister
//
//  Created by NSMeter on 08/04/19.
//  Copyright © 2019 KataBNPPF. All rights reserved.
//

import Foundation

enum Result {
    case Success
    case Failure (error: String)
    
}
extension String{
    
    func validate( errorDisplayName name: String, validationDic :[String: Any]) -> Result {
        
        if self.isEmpty {
            return .Failure(error: "\(name) cannot be empty.")
        }
            
        else if let regex = validationDic["regex"] as? String{
            let regexPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
            if !(regexPredicate.evaluate(with: self)) {
                if let customisedMessage = validationDic[Constant.kCustomMessagekey] as? String{
                    return .Failure(error: customisedMessage)
                }
                else{
                    return .Failure(error: "Please enter valid \(name).")
                    
                }
            }
        }
        else if let _ = validationDic["capitalization"] {
            let regexPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z]")
            if  !(regexPredicate.evaluate(with: prefix(1))){
                return .Failure(error: "Please enter \(name) with first letter capital.")
            }
        }
        else{
            return .Success
        }
        return .Success
    }
}
