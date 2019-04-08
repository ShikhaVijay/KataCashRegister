//
//  RecipiDescriptionCell.swift
//  KataCashRegister
//
//  Created by NSMeter on 08/04/19.
//  Copyright © 2019 KataBNPPF. All rights reserved.
//

import UIKit

class RecipiDescriptionCell: UITableViewCell {


    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var unitPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
