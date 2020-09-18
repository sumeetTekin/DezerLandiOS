//
//  RestaurantMenuVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 08/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
import WebKit

class RestaurantMenuVC: BaseViewController {

    @IBOutlet weak var web_menuView: WKWebView!
    
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    @IBOutlet weak var bg_view: UIImageView!
    @IBOutlet weak var txtv_description: UITextView!
    var url : URL?
    var htmlText : String?
    var titleBarText : String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName : "Restaurant Menu", className : "RestaurantMenuVC")

        if let url = url{
            let request = URLRequest(url: url)
            web_menuView.load(request)
            bg_view.isHidden = true
            txtv_description.isHidden = true
        }
        else if let string = htmlText {
            bg_view.layer.borderColor = UIColor.white.cgColor
            bg_view.layer.borderWidth = 1.0
            loaderView.stopAnimating()
            loaderView.isHidden = true
//            web_menuView.loadHTMLString(string, baseURL: nil)
            web_menuView.isHidden = true
            if let attrStr = Helper.getHTMLAttributedString(text: string) {
                txtv_description.attributedText = attrStr
            }
            
            
            
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = titleBarText
        
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        
    }
    override func viewWillLayoutSubviews() {
//        txtv_description.scrollRangeToVisible(NSRange(location:0, length:0))
        self.txtv_description.setContentOffset(.zero, animated: false)
        
    }
    @objc func backAction (_ sender : UIButton) {
        DispatchQueue.main.async(execute: {
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RestaurantMenuVC : UITextViewDelegate {
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        Helper.callURL(url: URL)
        return false
    }
}
