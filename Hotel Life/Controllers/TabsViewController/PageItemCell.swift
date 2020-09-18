//
//  PageItemCell.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 13/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class PageItemCell: UICollectionViewCell {
    @IBOutlet weak var view_bar: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_image: UIButton!
    @IBOutlet weak var img_cache: UIImageView!
    @IBOutlet weak var img_cacheNormal: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbl_title.adjustsFontSizeToFitWidth = true
        lbl_title.lineBreakMode = .byClipping
        btn_image.imageView?.contentMode = .scaleAspectFit
    }

}
