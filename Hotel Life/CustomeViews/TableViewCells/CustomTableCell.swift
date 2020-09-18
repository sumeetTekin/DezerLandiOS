//
//  CustomTableCell.swift
//  BeachResorts
//
//  Created by Vikas Mehay on 18/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
enum SelectionType {
    case single;
    case multiple;
}
@objc protocol CustomTableCellDelegate {
    @objc optional func increaseCountFor(menu : Menu)
    @objc optional func decreaseCountFor(menu : Menu)
    //for multiple selection
    @objc optional func checkCell(menu : Menu)
    @objc optional func unCheckCell(menu : Menu)
    //for single selection
    @objc optional func selectedCell(menu : Menu)
    @objc optional func descriptionTapped(menu : Menu)
}
class CustomTableCell: UITableViewCell {
    
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var lbl_headerTitle: UILabel!
    @IBOutlet weak var lbl_headerSubTitle: UILabel!
    @IBOutlet weak var img_cellImage: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subTitle: UILabel!
    @IBOutlet weak var lbl_discounlLabel: UILabel!
    @IBOutlet weak var lbl_duration: UILabel!
    @IBOutlet weak var btn_check: UIButton!
    @IBOutlet weak var btn_increase: UIButton!
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var btn_decrease: UIButton!
    @IBOutlet weak var clockIcon: UIImageView!
    @IBOutlet weak var descriptionBtn: UIButton!
    @IBOutlet weak var infoIcon: UIImageView!
    @IBOutlet weak var lbl_action: UILabel!
    @IBOutlet weak var heightActionLabel: NSLayoutConstraint!
    
    @IBOutlet weak var floatingRatingView: FloatRatingView!
    
    @IBOutlet weak var btnRate: UIButton!
    var buttonAction: ((Any) -> Void)?
    
    @IBAction func buttonAction(_ sender: Any) {
        self.buttonAction?(sender)
    }
    
    
    @objc func buttonPressed(sender: Any) {
        self.buttonAction?(sender)
    }
    
    var menu : Menu?
    var delegate : CustomTableCellDelegate?
    var selectionType : SelectionType = .single
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.selectionStyle = .none
        if view_bg != nil {
            view_bg.addBorder(color: .white)
        }
        
        if infoIcon != nil {
            infoIcon.cornerRadius(cornerRadius: infoIcon.frame.height/2)

        }
        
        //floatingRatingView.backgroundColor = UIColor.clear
        
        /** Note: With the exception of contentMode, type and delegate,
         all properties can be set directly in Interface Builder **/
//        floatingRatingView.delegate = nil
//        floatingRatingView.contentMode = UIViewContentMode.scaleAspectFit
//        floatingRatingView.type = .halfRatings
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configureCell(menuObj:Menu, type : CellType){
        self.menu = menuObj
        if let price = menuObj.item_price {
            var priceText = ""
            
            if let suffix = menuObj.menu_item_suffix {
                priceText = "$\(price) \(suffix)"
            }
            else{
                priceText = "$\(price)"
            }
            lbl_subTitle.text = priceText
        }
        if menuObj.is_discount {
            var price = ""
            if let pr = menuObj.before_discount_price {
                price = "$\(pr)"
                let completeText = "\(price) \(String(format : "%.2f",menuObj.discount))% off"
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: completeText)
                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: price.characters.count))
                    attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: COLORS.GREEN_COLOR, range: NSRange(location: 0, length: price.characters.count))
                if lbl_discounlLabel != nil {
                    lbl_discounlLabel.attributedText = attributeString
                }
            }
        }
        lbl_title.text = menuObj.label
        
        lbl_subTitle.adjustsFontSizeToFitWidth = true
        lbl_subTitle.lineBreakMode = .byClipping
        
        lbl_title.adjustsFontSizeToFitWidth = true
        lbl_title.lineBreakMode = .byClipping
        
        if type == .checkboxCell {
            lbl_duration.text = menuObj.duration
            if menuObj.duration == "" {
                clockIcon.isHidden = true
            }
            else{
                clockIcon.isHidden = false
            }
            
            if menuObj.isChecked! {
                selectCell()
            }
            else{
                deselectCell()
            }
        }
        else if type == .countCell {
            lbl_count.text = "\(menuObj.quantity!)"
        }
        if let imageURL = menuObj.imageURL {
            DispatchQueue.main.async(execute: {
                self.img_cellImage.contentMode = .scaleToFill
                self.img_cellImage.sd_setImage(with: imageURL, placeholderImage: nil, options: [], progress: nil, completed: { (image, error, cacheType, url) in
                })
            })
        }
        else{
            self.img_cellImage.image = #imageLiteral(resourceName: "gili_demo")
        }
       
    }
    
    func configureCellForPlanetKids(menuObj:Menu, type : CellType){
        self.menu = menuObj
        lbl_subTitle.text = menuObj.duration
        lbl_title.text = menuObj.label
        
        lbl_subTitle.adjustsFontSizeToFitWidth = true
        lbl_subTitle.lineBreakMode = .byClipping
        
        lbl_title.adjustsFontSizeToFitWidth = true
        lbl_title.lineBreakMode = .byClipping
        
        if let imageURL = menuObj.imageURL {
            DispatchQueue.main.async(execute: {
                self.img_cellImage.contentMode = .scaleToFill
                self.img_cellImage.sd_setImage(with: imageURL, placeholderImage: nil, options: [], progress: nil, completed: { (image, error, cacheType, url) in
                })
            })
        }
        else{
            self.img_cellImage.image = #imageLiteral(resourceName: "gili_demo")
        }
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
        if let menu = self.menu {
            delegate?.checkCell!(menu: menu)
        }
        btn_check.isSelected = true
        view_bg.layer.borderColor = COLORS.THEME_YELLOW_COLOR.cgColor
    }
    func deselectCell() {
        if let menu = self.menu {
            delegate?.unCheckCell!(menu: menu)
        }
        btn_check.isSelected = false
        view_bg.layer.borderColor = UIColor.white.cgColor
    }
    func singleSelectCell() {
            if let menu = self.menu {
                delegate?.selectedCell!(menu: menu)
            }
        btn_check.isSelected = true
        view_bg.layer.borderColor = COLORS.THEME_YELLOW_COLOR.cgColor

    }
    @IBAction func increaseAction(_ sender: UIButton) {
            if let menu = self.menu {
                delegate?.increaseCountFor!(menu: menu)
            }
    }
    
    @IBAction func decreaseAction(_ sender: UIButton) {
            if let menu = self.menu {
                delegate?.decreaseCountFor!(menu: menu)
            }
    }
    @IBAction func descriptionAction(_ sender: UIButton) {
        if let menu = self.menu {
            delegate?.descriptionTapped!(menu: menu)
        }
    }
    
    
    
    
}
extension CustomTableCell: FloatRatingViewDelegate {
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        
    }
    
}
