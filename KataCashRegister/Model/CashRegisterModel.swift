//
//  CashRegisterModel.swift
//  KataCashRegister
//
//  Created by NSMeter on 08/04/19.
//  Copyright © 2019 KataBNPPF. All rights reserved.
//

import Foundation

struct CashRegisterModel{
    
    private(set) var items = [Item]()
    let states = ["UT" : "6.85" , "NV" : "8.00" , "TX" : "6.25" , "AL" : "4.0" , "CA" : "8.25"];
    
    init() {
        
    }
    private func getDiscount (orderValue value:Double) -> Double{
        var disc: Int
        switch(value){
        case 1001 ... 5000 :
            disc = 3
        case 5001 ... 7000 :
            disc = 5
        case 7001 ... 10000 :
            disc = 7
        case 10001 ... 50000 :
            disc = 10
        case 50001 ... Double.greatestFiniteMagnitude:
            disc = 15
        default:
            disc = 0
            
        }
        print("discount % is \(disc)")
        return Double(disc) * (value / 100)
    }
    
    mutating func submitItemWith(itemName name: String, quantity: Int, price: Double, state : (String , String)){
        
        let item = Item(name: name, quantity: quantity, price: price, tax: Double(state.1) ?? 0.0)
        items += [item]
        
    }
    func finalPrice() -> (Double ,Double, Double){
        
        let sum = items.reduce(0) { $0 + ($1.price * Double($1.quantity))}
        let discountVal = getDiscount(orderValue: sum)
        let totalTaxValue = (items.map{ ($0.price * Double($0.quantity) *  $0.tax)/100 }).reduce(0, +)
        
        return (sum, discountVal , totalTaxValue)
    }
    func totalPricePerItem() ->[Double]{
        return items.map{ $0.price * Double($0.quantity) }
        
    }
    
    
}
