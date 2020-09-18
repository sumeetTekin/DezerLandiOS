//
//  BaseViewController.swift
//  BeachResorts
//
//  Created by Apple on 16/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Show Loading Indicator
    func activateView(_ view: UIView, loaderText: String) {
        Helper.showLoader(title: loaderText)
    }
    //Hide Loading Indicator
    func deactivateView(_ view: UIView) {
        Helper.hideLoader()
//        SwiftLoader.hide()
    }
    
    func setNavigationBar(title: String){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = title
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        

        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "previousBlack"), style: .plain, target: self, action: #selector(backToPreviousVCAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
    }
    
    @objc func backToPreviousVCAction (_ sender : UIButton) {
        DispatchQueue.main.async(execute: {
            _ = self.navigationController?.popViewController(animated: true)
        })
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
