//
//  CardCell.swift
//  Hotel Life
//
//  Created by jasvinders.singh on 9/26/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var checkBtn: UIButton!

    @IBOutlet weak var addCard: UIButton!
    @IBOutlet weak var saveCard: UIButton!
    
    @IBOutlet weak var checkOutBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCardCell(indexPath: IndexPath){
        viewBg.addBorder(color: .white)
    }

}
