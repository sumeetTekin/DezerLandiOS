//
//  LoyalityShareVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/21/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class LoyalityShareVC: BaseViewController {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txtv_description: HashtagTextView!
    @IBOutlet weak var img_loyalty: UIImageView!
    
    var selectedLoyalty : Loyalty?
    var titleBarText: String = ""
    
    override func viewDidLoad() {
        Helper.logScreen(screenName: "Loyalty share screen", className: "LoyalityShareVC")

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        if let loyalty = selectedLoyalty {
            self.navigationItem.title = loyalty.title
            self.lbl_title.text = loyalty.heading
            self.txtv_description.setText(text: loyalty.description!, hashtagColor: COLORS.THEME_YELLOW_COLOR, normalColor : UIColor.white, normalFont: UIFont.init(name: FONT_NAME.FONT_REGULAR, size: 17)!, hashtagFont: UIFont.init(name: FONT_NAME.FONT_REGULAR, size: 17)!)
            self.img_loyalty.sd_setImage(with: loyalty.image, completed: nil)
        }
        
        
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        
    }
    
    @objc func backAction(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
