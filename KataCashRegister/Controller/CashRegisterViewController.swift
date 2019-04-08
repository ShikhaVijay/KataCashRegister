//
//  CashRegisterViewController.swift
//  KataCashRegister
//
//  Created by NSMeter on 08/04/19.
//  Copyright © 2019 KataBNPPF. All rights reserved.
//

import UIKit

class CashRegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate ,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var itemLabel: UITextField!
    @IBOutlet weak var quantityLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    
    @IBOutlet weak var stateCodePickerView: UIPickerView!
    
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var recipiDescriptionTableView: UITableView!
    @IBOutlet weak var finalAmountLabel: UILabel!
    @IBOutlet weak var heightConstraintTabelView: NSLayoutConstraint!
    
    
    private var cashRegisterModel = CashRegisterModel()
    private lazy var states = cashRegisterModel.states
    private var visibleErrorMessages  = [String]()
    private var (finalPrice, discountValue, taxValue) = (0.0,0.0,0.0)
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideRecipiDescriptionView()
    }

    // MARK: - IBAction

    @IBAction func addItem(_ sender: Any) {
        self.view.endEditing(true)
        
        if validateAllFields(){
            errorLabel.isHidden = true
            let  itemName = self.itemLabel.text!
            let  price = Double(self.priceLabel.text!) ?? 0.0
            let  quantity = Int(self.quantityLabel.text!) ?? 0
            let selectedRow = stateCodePickerView.selectedRow(inComponent: 0)
            let selectedRowIndex = states.index(states.startIndex, offsetBy: selectedRow)
            clearForm()
            cashRegisterModel.submitItemWith(itemName:itemName , quantity: quantity, price: price, state:states[selectedRowIndex])
            showSucsessAlert(withTitle: Constant.COMPANY_NAME, andMessage: "Data Saved SuccessFully")
        }
        else{
            showSucsessAlert(withTitle: Constant.COMPANY_NAME, andMessage: "Submit data properly")
            
        }
    }
    
    @IBAction func generateRecipi(_ sender: Any) {
        showRecipiDescriptionView()
        (finalPrice, discountValue, taxValue) =  cashRegisterModel.finalPrice()
        self.totalSumLabel.text = "Total without tax: \(finalPrice.roundUpString)"
        self.discountLabel.text = "Discount offered: \(discountValue.roundUpString)"
        self.taxLabel.text = "Tax: \(taxValue.roundUpString)"
        self.finalAmountLabel.text = "Toatal Price: \((finalPrice - discountValue + taxValue).roundUpString)"
    }
    
    //MARK: - Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case itemLabel:
            quantityLabel.becomeFirstResponder()
        case quantityLabel:
            priceLabel.becomeFirstResponder()
        default:
            priceLabel.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let placeholderText : String
        switch textField.tag {
        case 1:
            placeholderText = "Enter Item Name"
        case 2:
            placeholderText = "Enter Quantity"
            
        case 3:
            placeholderText = "Enter Price"
            
        default:
            placeholderText = ""
            
        }
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.layer.borderColor = (UIColor.lightGray).cgColor
        textField.layer.borderWidth = 0.0
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            let _ = validateItemName()
        case 2:
            let _ = validateQuantity()
        case 3:
            let _ = validatePrice()
        default:
            print("Undefined textfield")
        }
    }
    // MARK: - Validation
    private func validateAllFields() -> Bool{
        if validateItemName() && validatePrice() && validateQuantity(){
            return true
        }
        return false
    }
    
    private func validateItemName()->Bool{
        let result = itemLabel.text!.validate(errorDisplayName: "Item Name", validationDic: [:])
        return evaluateResult(forTextField: itemLabel, withResult: result)
    }
    
    private func validatePrice()->Bool{
        //regex to all integer value upto two decimal
        let result = priceLabel.text!.validate(errorDisplayName: "Price", validationDic: [Constant.kRegex: "^[0-9]+(?:\\.[0-9]{2})?$",Constant.kCustomMessagekey : Constant.priceErrorMessage])
        return evaluateResult(forTextField: priceLabel, withResult: result)
    }
    
    private func validateQuantity()->Bool{
        //regex to all only integer value
        let result = quantityLabel.text!.validate(errorDisplayName: "Quantity", validationDic: [Constant.kRegex: "^[0-9]+$",Constant.kCustomMessagekey : Constant.quantityErrorMessage])
        return evaluateResult(forTextField: quantityLabel, withResult: result)
    }
    
    private func evaluateResult (forTextField textField: UITextField, withResult result:Result) ->Bool{
        
        switch result {
            
        case .Success:
            print("Success")
            self.errorLabel.text = ""
            errorLabel.isHidden = true
            
            textField.layer.borderColor = (UIColor.lightGray).cgColor
            textField.layer.borderWidth = 0.0
            return true
            
        case .Failure(let errorMessage):
            errorLabel.isHidden = false
            self.errorLabel.text = errorMessage
            //            if  (visibleErrorMessages.filter { errorMessage == $0 }).isEmpty{
            //                visibleErrorMessages.append(errorMessage)
            //                (self.errorLabel.text != nil) ? (self.errorLabel.text = self.errorLabel.text! + "\n" + errorMessage) : (self.errorLabel.text = errorMessage)
            //            }
            
            // self.errorLabel.text = (self.errorLabel.text ?? "")  + "\n" + errorMessage
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                textField.layer.borderColor = (UIColor.red).cgColor
                textField.layer.borderWidth = 1.0
                textField.shake()
            })
            return false
            
        }
        
    }
    // MARK: - pickerview delegate and datasource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  Array(states.keys)[row]
    }
    
    
    // MARK: - tableview delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cashRegisterModel.items.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath)
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipiDesc", for: indexPath)
                as! RecipiDescriptionCell
            let items = cashRegisterModel.items[indexPath.row - 1]
            cell.itemName?.text = items.itemlabel
            cell.quantity?.text = "\(items.quantity)"
            cell.unitPrice?.text = "\(items.price)"
            let totalPricePerItem = cashRegisterModel.totalPricePerItem()
            cell.totalPrice?.text = "\(totalPricePerItem[indexPath.row - 1])"
            return cell
            
        }
        
    }
    
    
    // MARK: - Custom
    private func clearForm(){
        self.itemLabel.text = ""
        self.quantityLabel.text = ""
        self.priceLabel.text = ""
        
    }
    
    private func showRecipiDescriptionView(){
        recipiDescriptionTableView.reloadData()
        heightConstraintTabelView.constant =  CGFloat( cashRegisterModel.items.count * Constant.rowHeight + Constant.headerheight)
        recipiDescriptionTableView.layoutIfNeeded()
        recipiDescriptionTableView.isHidden = false
        totalSumLabel.isHidden = false
        discountLabel.isHidden = false
        taxLabel.isHidden = false
        finalAmountLabel.isHidden = false
    }
    private func hideRecipiDescriptionView(){
        recipiDescriptionTableView.isHidden = true
        totalSumLabel.isHidden = true
        discountLabel.isHidden = true
        taxLabel.isHidden = true
        finalAmountLabel.isHidden = true
    }
    
    
}

