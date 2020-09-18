//
//  RemoveCell.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 29/03/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit
protocol RemoveDelegate {
    func remove(item : Menu)
}
class RemoveCell: UITableViewCell {

    @IBOutlet weak var btn_remove: UIButton!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_modifiers: UILabel!
    var delegate : RemoveDelegate?
    var menu : Menu!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCellFor(menu : Menu) {
        self.menu = menu
        lbl_title.text = menu.label
        lbl_price.text = String(format : "$%.2f",Helper.getAlohaQuantityTotal(menuArray: [menu]))
        let modifiers = ""
        if menu.selectedModifierArray.count > 0 {
            lbl_modifiers.text = modifiers.appending(Helper.getModifiersString(arr : menu.selectedModifierArray))
        }
        
    }
    @IBAction func acrionRemove(_ sender: Any) {
        delegate?.remove(item: menu)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
