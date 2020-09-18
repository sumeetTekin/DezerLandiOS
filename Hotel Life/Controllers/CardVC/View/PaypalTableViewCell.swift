//
//  PaypalTableViewCell.swift
//  Kangaroo Propane
//
//  Created by Lokesh Negi on 05/02/2020.
//  Copyright © 2020 Adil Mir. All rights reserved.
//

import UIKit

class PaypalTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var cardNameLabel: UILabel!
    
    // MARK: Variables
    
    static let cellId = "PaypalTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
