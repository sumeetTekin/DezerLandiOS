//
//  CustomAlertView.swift
//  BeachResorts
//
//  Created by Vikas Mehay on 19/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
import SDWebImage
@objc protocol CustomAlertViewDelegate {
    func alertDismissed()
    func yesAction()
    func noAction()
}

class CustomAlertView: UIViewController {
    weak var delegate : CustomAlertViewDelegate?
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var lbl_message: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_no: UIButton!
    @IBOutlet weak var btn_yes: UIButton!
    @IBOutlet weak var constraint_title: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_no.setTitle(BUTTON_TITLE.No, for: .normal)
        btn_yes.setTitle(BUTTON_TITLE.Yes, for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionNo(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.noAction()
        }
    }
    @IBAction func actionYes(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.yesAction()
        }
    }
    func set(imageURL : URL? , message : String?) {
        self.img_icon.sd_setImage(with: imageURL, placeholderImage: nil, options: [], progress: nil, completed: { (image, error, cacheType, url) in
        })
        self.lbl_message.text = message
    }

}
