//
//  PostcardVC.swift
//  BeachResorts
//
//  Created by Vikas Mehay on 20/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class PostcardVC: BaseViewController{
    var titleBarText: String = ""
    
    //@IBOutlet weak var txt_hashtag: HashtagTextView!
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var btn_selectImage: UIButton!
    @IBOutlet weak var img_selected: UIImageView!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var btn_continue: UIButton!
    var selectedImage : UIImage? {
        didSet {
             img_selected.image = selectedImage
        }
    }
    let imageController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "Postcard screen", className: "PostcardVC")

        view_bg.layer.borderColor = UIColor.white.cgColor
        view_bg.layer.borderWidth = 0.5
        
//        txt_hashtag.layer.borderColor = UIColor.lightGray.cgColor
//        txt_hashtag.layer.borderWidth = 0.5
        imageController.delegate = self
        imageController.allowsEditing = false
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = titleBarText
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        
        reloadView()
        
    }
    override func viewDidAppear(_ animated: Bool) {
//        txt_hashtag.becomeFirstResponder()
    }
    @objc public func backAction(_ sender : UIButton) {
        DispatchQueue.main.async(execute: {
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    func reloadView() {
        if selectedImage != nil {
            btn_edit.isHidden = false
            btn_delete.isHidden = false
            btn_selectImage.isHidden = true
        }
        else{
            btn_edit.isHidden = true
            btn_delete.isHidden = true
            btn_selectImage.isHidden = false
        }
    }
    @IBAction func selectImageAction(_ sender: Any) {
        let alertController = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        let actionCamera = UIAlertAction(title: "Camera", style: .default, handler: {action in
            self.selectImageFromSource(.camera)
        })
        alertController.addAction(actionCamera)
        
        let actionPhoto = UIAlertAction(title: "Photos", style: .default, handler: {action in
            self.selectImageFromSource(.photoLibrary)
            
        })
        alertController.addAction(actionPhoto)
        
        let actionCancel = UIAlertAction(title: BUTTON_TITLE.Cancel, style: .destructive, handler: { action in
            
        })
        alertController.addAction(actionCancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func editBtnAction(_ sender: UIButton) {
        selectImageAction(sender)
    }
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        selectedImage = nil
        reloadView()
    }
    @IBAction func continueAction(_ sender: UIButton) {
        if validate() {
            if let storyboard = Helper.getCustomReusableViewsStoryboard() as? UIStoryboard{
                let controller : PublishPostcardVC = storyboard.instantiateViewController(withIdentifier: "PublishPostcardVC") as! PublishPostcardVC
                self.view.backgroundColor = UIColor.clear
                controller.titleBarText = titleBarText
                controller.selectedImage = selectedImage
                //            controller.hashtagText = self.txt_hashtag.text
                DispatchQueue.main.async(execute: {
                    self.navigationController?.pushViewController(controller, animated: true)
                })
            }
            
        }
        
    }
    func validate() -> Bool {
        if selectedImage == nil {
            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: ERRORMESSAGE.NO_IMAGE)
            return false
        }
//        else if txt_hashtag.text == PLACEHOLDER.addComment || txt_hashtag.text == "" {
//            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: ALERTSTRING.NO_DESCRIPTION)
//            return false
//        }
        else{
            return true
        }
    }
    func selectImageFromSource(_ source : UIImagePickerControllerSourceType) {
        
        if source == .camera {
            if UIImagePickerController.isSourceTypeAvailable(.camera){
               imageController.sourceType = .camera
            }
            else{
                DispatchQueue.main.async(execute: {
                        Helper.showAlert(sender: self, title: "Error", message: ERRORMESSAGE.CAMERA_NOT_AVAILABLE)
                })
                
                return
            }
        }
        else if source == .photoLibrary {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
               imageController.sourceType = .photoLibrary
            }
            else{
                DispatchQueue.main.async(execute: {
                        Helper.showAlert(sender: self, title: "Error", message: ERRORMESSAGE.PHOTOS_NOT_AVAILABLE)
                })
                
                return
            }
        }
        else {
            return
        }
        
        self.present(imageController, animated: true, completion: nil)

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
extension PostcardVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate {
//    MARK:Image Picker controller delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] {
            self.selectedImage = image as? UIImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
//    MARK: TextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            return true
        }
        else if textView.text.characters.count < 140 {
            return true
        }
        else {
            return false
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == PLACEHOLDER.addComment {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        
      return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == "" {
            textView.text = PLACEHOLDER.addComment
            textView.textColor = UIColor.lightGray
        }
      return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let txtView = textView as! HashtagTextView
        txtView.setText(text: textView.text, hashtagColor: COLORS.THEME_YELLOW_COLOR, normalFont: UIFont.init(name: FONT_NAME.FONT_REGULAR, size: 15)!, hashtagFont: UIFont.init(name: FONT_NAME.FONT_BOLD, size: 15)!, callback: {string, wordType in
            
        })
    }
    
    
}
