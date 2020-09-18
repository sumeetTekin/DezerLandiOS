//
//  ModifierCell.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 11/01/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit
protocol ModifierDelegate {
    func checkCell(modifier : Modifier)
}
class ModifierCell: UITableViewCell {

    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var btn_check: UIButton!
    var modifier : Modifier?
    var delegate : ModifierDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.selectionStyle = .none
        if view_bg != nil {
            view_bg.addBorder(color: .white)
        }
        btn_check.isUserInteractionEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionCheck(_ sender: Any) {
        if (sender as? UIButton)?.isSelected == true {
            (sender as? UIButton)?.isSelected = false
        }
        else{
            (sender as? UIButton)?.isSelected = true
        }
        if let modi = modifier {
            delegate?.checkCell(modifier: modi)
        }
    }
}

class DescriptionCell: UITableViewCell {
    
    @IBOutlet weak var img_itemImage: UIImageView!
    @IBOutlet weak var lbl_itemName: UILabel!
    @IBOutlet weak var lbl_itemPrice: UILabel!
    @IBOutlet weak var txtv_description: UITextView!
    @IBOutlet weak var view_bg: UIView!
    
    var menu : Menu?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.selectionStyle = .none
        if view_bg != nil {
            view_bg.addBorder(color: .white)
        }
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

