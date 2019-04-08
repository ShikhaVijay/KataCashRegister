//
//  KataCashRegisterTests.swift
//  KataCashRegisterTests
//
//  Created by NSMeter on 08/04/19.
//  Copyright © 2019 KataBNPPF. All rights reserved.
//

import XCTest
@testable import KataCashRegister
var cashRegisterModel : CashRegisterModel!
var cashRegisterController : CashRegisterViewController!

class KataCashRegisterTests: XCTestCase {

    override func setUp() {
        cashRegisterModel = CashRegisterModel()
        cashRegisterController = UIStoryboard(name: "Main",bundle: nil).instantiateInitialViewController() as! CashRegisterViewController?
        UIApplication.shared.keyWindow!.rootViewController = cashRegisterController
        XCTAssertNotNil(cashRegisterController.view)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cashRegisterModel = nil
        cashRegisterController = nil
    }
    
    func testItemsCount() {
        addItems()
        XCTAssert(cashRegisterModel.items.count == 4)
        XCTAssertFalse(cashRegisterModel.items.count > 4, "Items added showing greater then items added")
    }
    
    
    func testTotalPriceDiscountOfferedAndTaxValue() {
        addItems()
        let (finalPrice, discountValue, taxValue) =  cashRegisterModel.finalPrice()
        
        XCTAssertEqual(finalPrice, 31377 , "Total without tax is not calculated properly")
        XCTAssertEqual(discountValue, 3137.7 , "Discount without tax is not calculated properly")
        XCTAssertEqual(taxValue, 2224.7925 , "Discount without tax is not calculated properly")
        
    }
    func testTotalPricePerItem(){
        addItems()
        let pricePerItem = cashRegisterModel.totalPricePerItem()
        XCTAssertEqual(pricePerItem, [2506, 5612,3759,19500] , "Price per item is not calculated properly")
    }
    
    func testRoundUpToTwoDecimal(){
        let decimalValue = 23.45678.roundUpString
        let comparisionString = "$ 23.46"
        XCTAssertEqual( decimalValue, comparisionString, "Price per item is not calculated properly")
    }
    
    func testContollerInitialUISet(){
        print(cashRegisterController.recipiDescriptionTableView ?? "nil")
        XCTAssertEqual(cashRegisterController.recipiDescriptionTableView.isHidden, true,"recipiDescriptionTableView should be hidden")
        XCTAssertEqual(cashRegisterController.totalSumLabel.isHidden, true,"totalSumLabel should be hidden")
        XCTAssertEqual(cashRegisterController.taxLabel.isHidden, true,"taxLabel should be hidden")
        XCTAssertEqual(cashRegisterController.discountLabel.isHidden, true,"discountLabel should be hidden")
        XCTAssertEqual(cashRegisterController.finalAmountLabel.isHidden, true,"finalAmountLabel should be hidden")
        
    }
    
    func testValidateRecipiUIVisibleAfterValidSubmission(){
        
        cashRegisterController.itemLabel.text = "Item 1"
        cashRegisterController.quantityLabel.text = "10"
        cashRegisterController.priceLabel.text = "100.00"
        cashRegisterController.addItem("")
        cashRegisterController.generateRecipi("")
        XCTAssertNotEqual(cashRegisterController.recipiDescriptionTableView.isHidden, true,"recipiDescriptionTableView should be visible")
        XCTAssertNotEqual(cashRegisterController.totalSumLabel.isHidden, true,"totalSumLabel should be visible")
        XCTAssertNotEqual(cashRegisterController.taxLabel.isHidden, true,"taxLabel should be visible")
        XCTAssertNotEqual(cashRegisterController.discountLabel.isHidden, true,"discountLabel should be visible")
        XCTAssertNotEqual(cashRegisterController.finalAmountLabel.isHidden, true,"finalAmountLabel should be visible")
        
        
    }
    

    func addItems(){
        cashRegisterModel.submitItemWith(itemName: "Item 1", quantity: 10, price: 250.60, state: ("TX" ,"6.25") )
        cashRegisterModel.submitItemWith(itemName: "Item 2", quantity: 20, price: 280.60, state: ("AL" ,"4.0") )
        cashRegisterModel.submitItemWith(itemName: "Item 3", quantity: 15, price: 250.60, state: ("TX" ,"6.25") )
        cashRegisterModel.submitItemWith(itemName: "Item 4", quantity: 65, price: 300, state: ("CA" ,"8.25") )
        
    }
}
