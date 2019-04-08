//
//  Item.swift
//  KataCashRegister
//
//  Created by NSMeter on 08/04/19.
//  Copyright © 2019 KataBNPPF. All rights reserved.
//

import Foundation


struct Item{
    
    let itemlabel:String
    let quantity: Int
    let price :Double
    let tax :Double
    
    init(name :String,quantity:Int , price: Double, tax: Double) {
        itemlabel = name
        self.quantity = quantity
        self.price = price
        self.tax = tax
    }
}

