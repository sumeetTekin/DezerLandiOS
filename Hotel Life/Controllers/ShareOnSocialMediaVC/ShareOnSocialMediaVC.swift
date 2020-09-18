//
//  ShareOnSocialMediaVC.swift
//  Hotel Life
//
//  Created by Amit Verma on 09/06/20.
//  Copyright © 2020 jasvinders.singh. All rights reserved.
//

import UIKit

class ShareOnSocialMediaVC: BaseViewController {
    var tabDelegate : BaseTabBarDelegate?
    var navController : UINavigationController?
    var parentView : UIView?
    
    @IBOutlet var imageView : UIImageView?
    @IBOutlet var socialMediaView : UIView?
    @IBOutlet var socialMediaShareView : UIView?
    @IBOutlet var socialMediaShareSubView : UIView?
    @IBOutlet var continueButton : UIButton?
    @IBOutlet var newFeedButton : UIButton?
    @IBOutlet var yourPostButton : UIButton?
    @IBOutlet var yourPostLabel : UILabel?
    
    var socialMedia = socialMediaType.facebook
    
    let imageController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSubViews()
        self.setNavigationBar(title : "Share On Social Media")
        selectImageAction(self)
        

        // Do any additional setup after loading the view.
    }
    
    
    
    private func setSubViews(){
        self.imageView?.addBorder(color: .gray)
        self.view.addSubview(socialMediaShareView ?? UIView())
        self.view.addSubview(socialMediaView ?? UIView())
        self.socialMediaView?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 72)
        
        self.socialMediaShareView?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 304)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.socialMediaShareView?.addGestureRecognizer(tap)
        
        let tapForImage = UITapGestureRecognizer(target: self, action: #selector(self.handleTapForImage(_:)))
        self.imageView?.addGestureRecognizer(tapForImage)
        
        imageController.delegate = self
        imageController.allowsEditing = false

    }
    
    @objc func handleTapForImage(_ sender: UITapGestureRecognizer? = nil) {
        selectImageAction(self)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        UIView.animate(withDuration: 0.5,
                   delay: 0.1,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    self.socialMediaShareView?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    self.navigationController?.navigationBar.layer.zPosition = 0;
                    self.continueButton?.isHidden = false
                       
        }, completion: { (finished) -> Void in
        })
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

    @IBAction func continueAction(_ sender: Any) {
        
        if imageView?.image != nil {
            UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.socialMediaView?.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 72, width: self.view.frame.size.width, height: 72)
                        self.continueButton?.isHidden = true
                           
            }, completion: { (finished) -> Void in
            })
        }else{
            Helper.showAlert(sender: self, title: ALERTSTRING.TITLE, message: "Please select any image for share")
        }
        //tabDelegate?.chnageToHomePage()
        
        
    }
    
    
    @IBAction func facebookAction(_ sender: Any) {
        self.yourPostLabel?.isHidden = false
        self.yourPostButton?.isHidden = false
        
        self.socialMediaView?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 72)
        UIView.animate(withDuration: 0.5,
                   delay: 0.1,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    self.socialMediaShareView?.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    self.navigationController?.navigationBar.layer.zPosition = -1;
                    self.socialMedia = socialMediaType.facebook
                       
        }, completion: { (finished) -> Void in
        })
        
    }

    @IBAction func twitterAction(_ sender: Any) {
        self.yourPostLabel?.isHidden = true
        self.yourPostButton?.isHidden = true
        
        self.socialMediaView?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 72)
        UIView.animate(withDuration: 0.5,
                   delay: 0.1,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    self.socialMediaShareView?.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    self.navigationController?.navigationBar.layer.zPosition = -1;
                    self.socialMedia = socialMediaType.twitter
                       
        }, completion: { (finished) -> Void in
        })
    }
    
    @IBAction func instaAction(_ sender: Any) {
        self.yourPostLabel?.isHidden = false
        self.yourPostButton?.isHidden = false
        
        self.socialMediaView?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 72)
        UIView.animate(withDuration: 0.5,
                   delay: 0.1,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    self.socialMediaShareView?.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    self.navigationController?.navigationBar.layer.zPosition = -1;
                    self.socialMedia = socialMediaType.instagram
                       
        }, completion: { (finished) -> Void in
        })
        
    }
    
    @IBAction func newsFeedAction(_ sender: Any) {
        if let image = imageView?.image{
            switch socialMedia {
            case .facebook:
                SocialShare.shared.shareWith(image: image, type: .facebook, fromController: self, delegate: self)
            case .instagram:
               // SocialShare.shared.shareWith(image: image, type: .instagram, fromController: self, delegate: self)
                SocialShare.shared.postImageToInstagram(image: image, controller: self)
            case .twitter:
                SocialShare.shared.shareWith(image: image, type: .twitter, fromController: self, delegate: self)
            }
        }else{
            self.selectImageAction(sender)
        }
        
        
        //SocialShare.shared.shareBackgroundImage()
    }
    
    @IBAction func yourStoryAction(_ sender: Any) {
         if let image = imageView?.image{
            switch socialMedia {
                   case .facebook:
                       SocialShare.shared.shareBackgroundImageFacebookToYourStory(image: image, controller: self)
                   case .instagram:
                       SocialShare.shared.shareBackgroundImageInstagramYourStory(image: image,controller: self)
                   case .twitter:
                       SocialShare.shared.twitterShareSotries(image: image, controller: self)
                       
                   }
         }else{
            self.selectImageAction(sender)
        }
        
       
        
    }
    
}
extension ShareOnSocialMediaVC : SocialShareDelegate {
    func uploadStarted() {
        DispatchQueue.main.async {
            Helper.showLoader(title: LOADER_TEXT.loading)
        }
    }
    func uploadEnded() {
//            Helper.showAlert(sender: self, title: ALERTSTRING.POSTED, message: "")
        DispatchQueue.main.async {
            Helper.hideLoader()
        }
    }
}


extension ShareOnSocialMediaVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
//    MARK:Image Picker controller delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] {
            self.imageView?.image = image as? UIImage
            self.newFeedButton?.setImage(image as? UIImage, for: .normal)
            self.yourPostButton?.setImage(image as? UIImage, for: .normal)
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
    
    
    
    
}

