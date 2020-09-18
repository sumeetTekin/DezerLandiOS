//
//  CardsTableViewcell.swift
//  Kangaroo Propane
//
//  Created by Lokesh Negi on 05/02/2020.
//  Copyright © 2020 Adil Mir. All rights reserved.
//

import UIKit

class CardsTableViewcell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardExpireLabel: UILabel!
    @IBOutlet weak var cardLastFourDigitLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var radioButtun: UIButton?
    
    var buttonClosure : ((UIButton) -> Void)?
    // MARK: Variables
    
    static let cellId = "CardsTableViewcell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func radioAction(_ sender : UIButton){
        self.buttonClosure!(sender)
    }
    
    
    
}
