//
//  CancelAlert.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 03/01/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit

class CancelAlert: UIViewController {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_continue: UIButton!
    @IBOutlet weak var txtv_description: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func action_continue(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    func setClickableText(completeText : String, clickableText : String) {
        let mutableAttributedString = NSMutableAttributedString(string: completeText, attributes: nil)
        if completeText.contains(clickableText){
            let linkRange : NSRange = (completeText as NSString).range(of: clickableText)
            mutableAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: COLORS.THEME_YELLOW_COLOR, range: linkRange)
        }
        txtv_description.text = completeText
    }
}

extension CancelAlert : UITextViewDelegate{
 
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        Helper.callURL(url: URL)

        return false
    }
}
