//
//  NotificationViewController.swift
//  Hotel Life LiveDev Content
//
//  Created by Vikas Mehay on 21/11/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var lblMessage: UILabel?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        self.lblTitle?.text = notification.request.content.body
        if let message = userInfo["message"] as? [String : Any] {
            self.lblMessage?.text = message["message"] as? String
            if let urlImageString = message["image"] as? String {
                if let url = URL(string: urlImageString) {
                    URLSession.downloadImage(atURL: url) { [weak self] (data, error) in
                        if let _ = error {
                            return
                        }
                        guard let data = data else {
                            return
                        }
                        DispatchQueue.main.async {
                            self?.imageView.image = UIImage(data: data)
                            self?.loader.isHidden = true
                        }
                    }
                }
            }
        }
    }
}
extension URLSession {
    
    class func downloadImage(atURL url: URL, withCompletionHandler completionHandler: @escaping (Data?, NSError?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            completionHandler(data, nil)
        }
        dataTask.resume()
    }
}
