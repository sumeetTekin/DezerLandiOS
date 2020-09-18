//
//  AmenitiesCell.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 17/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
@objc protocol AmenitiesCellDelegate {
    //for multiple selection
    @objc optional func checkCell(item : Amenities)
    @objc optional func unCheckCell(item : Amenities)
    //for single selection
    @objc optional func selectedCell(item : Amenities)
}
class AmenitiesCell: UITableViewCell {
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_check: UIButton!
    
    var item : Amenities?
    var delegate : AmenitiesCellDelegate?
    var selectionType : SelectionType = .single
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        view_bg.layer.borderColor = UIColor.white.cgColor
//        view_bg.layer.borderWidth = 0.5
        self.backgroundColor = .clear
        self.selectionStyle = .none
        // Initialization code
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(item : Amenities){
            self.item = item
            lbl_title.text = item.name
            lbl_title.adjustsFontSizeToFitWidth = true
            lbl_title.lineBreakMode = .byClipping
        }
        
    @IBAction func checkBtnAction(_ sender: UIButton) {
            switch selectionType {
            case .single:
                singleSelectCell()
            case .multiple:
                if sender.isSelected {
                    deselectCell()
                }
                else {
                    selectCell()
                }                
            }
        }
    func selectCell() {
                if let item = self.item {
                    delegate?.checkCell!(item : item)
                }
            btn_check.isSelected = true
            view_bg.layer.borderColor = COLORS.THEME_YELLOW_COLOR.cgColor
        }
    func deselectCell() {
                if let item = self.item {
                    delegate?.unCheckCell!(item : item)
                }
            btn_check.isSelected = false
            view_bg.layer.borderColor = UIColor.white.cgColor
        }
    func singleSelectCell() {
                 if let item = self.item {
                    delegate?.selectedCell!(item : item)
                }
            btn_check.isSelected = true
            view_bg.layer.borderColor = COLORS.THEME_YELLOW_COLOR.cgColor
        }

}
