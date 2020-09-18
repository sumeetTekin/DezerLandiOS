//
//  SocialShare.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 10/10/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
import FBSDKShareKit
import TwitterKit
import Social
import TwitterCore
import Photos


enum socialMediaType {
    case facebook
    case twitter
    case instagram
}
protocol SocialShareDelegate {
    func uploadStarted()
    func uploadEnded()
}
class SocialShare: NSObject, UIDocumentInteractionControllerDelegate {
    static let shared = SocialShare()
    var delegate : SocialShareDelegate?
    var interactionController: UIDocumentInteractionController?
    var controller : UIViewController?
//    
//    
//    class func shared() -> SocialShare {
//        if sharedInstance == nil {
//            sharedInstance = SocialShare()
//        }
//        return sharedInstance!
//    }
    func shareWith(image : UIImage?, type : socialMediaType, fromController : UIViewController, delegate : SocialShareDelegate) {
        self.delegate = delegate
        switch type {
        case .facebook:
            facebookShare(image: image, controller: fromController)
        case .twitter:
            twitterShare(image: image, controller: fromController)
        case .instagram:
            instagramShare(image: image, controller: fromController)
        }
    }
//    func shareWith(image : UIImage?, type : socialMediaType, fromController : UIViewController, completionHandler : @escaping (Bool) -> Void) {
//        switch type {
//        case .facebook:
//            facebookShare(image: image, controller: fromController)
//        case .twitter:
//            twitterShare(image: image, controller: fromController)
//        case .instagram:
//            instagramShare(image: image, controller: fromController)
//        }
//    }
    
    
//    func shareBackgroundImage() {
//        backgroundImage(
//            UIImage(named: "backgroundImage")?.pngData(),
//            attributionURL: "http://your-deep-link-url",
//            appID: "your-app-id")
//    }
    
    func shareBackgroundImageFacebookToYourStory(image: UIImage, controller : UIViewController) {
       
        backgroundImage(UIImagePNGRepresentation(image), attributionURL: nil, appID: "2593668877515277", controller : controller)
    }
    
    

    private func backgroundImage(_ backgroundImage: Data?, attributionURL: String?, appID: String?, controller :UIViewController) {
        
        let urlScheme = URL(string: "facebook-stories://share")
        if let urlScheme = urlScheme {
            if UIApplication.shared.canOpenURL(urlScheme) {

                // Assign background image asset and attribution link URL to pasteboard
                let pasteboardItems = [
                    [
                            "com.facebook.sharedSticker.backgroundImage": backgroundImage ?? Data(),
                            "com.facebook.sharedSticker.contentURL": attributionURL ?? "",
                            "com.facebook.sharedSticker.appID": appID ?? ""
                        ]
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)
                ]
                // This call is iOS 10+, can use 'setItems' depending on what versions you support
                UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)

                //UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
                
                UIApplication.shared.open(urlScheme, options: [:]) { (success) in
                    self.delegate?.uploadEnded()
                }
                
            }
            else{
                Helper.showAlert(sender: controller, title: ALERTSTRING.ERROR, message: ERRORMESSAGE.FACEBOOK_NOT_AVAILABLE)
            }
        }else{
            
        }

    }
    
    
    func shareBackgroundImageInstagramYourStory(image: UIImage, controller : UIViewController) {
        backgroundImage(UIImagePNGRepresentation(image), attributionURL: "http://your-deep-link-url", controller : controller)
    }
    
    
   private func backgroundImage(_ backgroundImage: Data?, attributionURL: String?, controller : UIViewController) {

        let urlScheme = URL(string: "instagram-stories://share")
        if let urlScheme = urlScheme {
            if UIApplication.shared.canOpenURL(urlScheme) {

               // var pasteboardItems: [[StringLiteralConvertible : Data?]]? = nil
                if let backgroundImage = backgroundImage {
                   let pasteboardItems = [
                    [
                                "com.instagram.sharedSticker.backgroundImage": backgroundImage,
                                "com.instagram.sharedSticker.contentURL": attributionURL
                            ]
                ]
                    
                    let pasteboardOptions = [
                        UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)
                    ]
                    
                    UIPasteboard.general.setItems(pasteboardItems , options: pasteboardOptions)
                    
                    UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
                    
                }
                
            } else {
                
                    Helper.showAlert(sender: controller, title: ALERTSTRING.ERROR, message: ERRORMESSAGE.INSTAGRAM_NOT_AVAILABLE)
                
            }
        }
    }

    
    
    
    private func facebookShare(image : UIImage?, controller : UIViewController) {
        let fbUrl = URL(string: "fb://")
        if !UIApplication.shared.canOpenURL(fbUrl!){
            Helper.showAlert(sender: controller, title: ALERTSTRING.ERROR, message: ERRORMESSAGE.FACEBOOK_NOT_AVAILABLE)
        }
        else{

            let photo : SharePhoto = SharePhoto(image: image ?? UIImage(), userGenerated: true)
            let content : ShareMediaContent = ShareMediaContent()
            content.media = [photo]
            let dialog : ShareDialog = ShareDialog()
            dialog.fromViewController = controller
            dialog.delegate = self
            dialog.shareContent = content
            
            dialog.mode = .automatic
            dialog.show()
            
        }
    }
    
    private func twitterShare(image : UIImage?, controller : UIViewController) {
        let twitterUrl = URL(string: "twitter://")
        
        if !UIApplication.shared.canOpenURL(twitterUrl!){
           print("no twitter")
            Helper.showAlert(sender: controller, title: ALERTSTRING.ERROR, message: ERRORMESSAGE.TWITTER_NOT_AVAILABLE)
        }
        else{
            let composer = TWTRComposer()
            
            composer.setImage(image)
            
            // Called from a UIViewController
            if let nav = controller.navigationController {
                composer.show(from: nav) { result in
                    if (result == .done) {
                        print("Successfully composed Tweet")
                        DispatchQueue.main.async {
                            self.delegate?.uploadStarted()
                        }
                        let obj : BusinessLayer = BusinessLayer()
                        obj.socialShare(platform: "Twitter") { (status, message) in
                            DispatchQueue.main.async {
                                self.delegate?.uploadEnded()
                            }
                        }
                    } else {
                        print("Cancelled composing")
                    }
                }
            }
        }
    }
    
    func twitterShareSotries(image : UIImage?, controller : UIViewController) {
        let twitterUrl = URL(string: "twitter-stories://")
        
        if !UIApplication.shared.canOpenURL(twitterUrl!){
           print("no twitter")
            Helper.showAlert(sender: controller, title: ALERTSTRING.ERROR, message: ERRORMESSAGE.TWITTER_NOT_AVAILABLE)
        }
        else{
            let composer = TWTRComposer()
            
            composer.setImage(image)
            
            // Called from a UIViewController
            if let nav = controller.navigationController {
                composer.show(from: nav) { result in
                    if (result == .done) {
                        print("Successfully composed Tweet")
                        DispatchQueue.main.async {
                            self.delegate?.uploadStarted()
                        }
                        let obj : BusinessLayer = BusinessLayer()
                        obj.socialShare(platform: "Twitter") { (status, message) in
                            DispatchQueue.main.async {
                                self.delegate?.uploadEnded()
                            }
                        }
                    } else {
                        print("Cancelled composing")
                    }
                }
            }
            
            
        }
    }
    
    
    
    private func instagramShare(image : UIImage?, controller : UIViewController) {
        let instagramUrl = URL(string: "instagram://")
        
        if !UIApplication.shared.canOpenURL(instagramUrl!){
            print("no Insta")
            Helper.showAlert(sender: controller, title: ALERTSTRING.ERROR, message: ERRORMESSAGE.INSTAGRAM_NOT_AVAILABLE)
        }
        else{
            let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let path = documentsDirectory.appendingPathComponent("Share Icon.igo")
            let data = UIImagePNGRepresentation(image!)
            let fileManager = FileManager.default
            fileManager.createFile(atPath: path, contents: data, attributes: nil)
            let imagePath = documentsDirectory.appendingPathComponent("Share Icon.igo")
            let rect = CGRect(x:0, y:0, width:0, height:0)
            let fileURL = NSURL(fileURLWithPath: imagePath)
            interactionController = UIDocumentInteractionController.init(url: fileURL as URL)
            interactionController?.delegate = self
            interactionController?.uti = "com.instagram.exclusivegram"
            interactionController?.presentOpenInMenu(from: rect, in: controller.view, animated: true)
        }
        
    }
    
    
    func postImageToInstagram(image: UIImage, controller : UIViewController) {
        self.controller = controller
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if error != nil {
                print(error)
            }

            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

            if let lastAsset = fetchResult.firstObject as? PHAsset {

                let url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)")!

                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Instagram is not installed", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.controller?.present(alertController, animated: true, completion: nil)
                }

            }
    }
    
    
    
}

extension SocialShare : TWTRComposerViewControllerDelegate {
    func composerDidCancel(_ controller: TWTRComposerViewController) {

    }
    func composerDidFail(_ controller: TWTRComposerViewController, withError error: Error) {

        print(error.localizedDescription)
    }
    func composerDidSucceed(_ controller: TWTRComposerViewController, with tweet: TWTRTweet) {
        DispatchQueue.main.async {
            self.delegate?.uploadStarted()
        }
        let obj : BusinessLayer = BusinessLayer()
        obj.socialShare(platform: "Twitter") { (status, message) in
            DispatchQueue.main.async {
                self.delegate?.uploadEnded()
            }
            
        }
        print("Success",tweet)
    }
}

extension SocialShare : SharingDelegate {
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        DispatchQueue.main.async {
            self.delegate?.uploadStarted()
        }
        let obj : BusinessLayer = BusinessLayer()
        obj.socialShare(platform: "Facebook") { (status, message) in
            DispatchQueue.main.async {
                self.delegate?.uploadEnded()
            }
        }
        print("Success >>> \(results)")
    }
    
    
    func sharer(_ sharer: Sharing!, didFailWithError error: Error!) {
        print(error.localizedDescription)
    }
    
    func sharerDidCancel(_ sharer: Sharing!) {
        print("Cancelled")
    }
    
    
}
