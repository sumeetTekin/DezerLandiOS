//
//  OrderDetailCell.swift
//  Resort Life
//
//  Created by Amit Verma on 07/02/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import UIKit

class OrderDetailCell: UITableViewCell {
    
    @IBOutlet weak var lblOrder: UILabel!
    @IBOutlet weak var lblQuantityPrice: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
