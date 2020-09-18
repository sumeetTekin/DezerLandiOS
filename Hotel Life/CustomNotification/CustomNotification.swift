//
//  CustomNotification.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 21/11/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class CustomNotification: NSObject, UNUserNotificationCenterDelegate {

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        switch response.actionIdentifier {
//        case NotificationIdentifiers.open:
//            kAppDelegate.showPushMessage(data: response.notification.request.content.userInfo, delay: 2)
//            break
//        default:
//            break
//        }
       //if == true
       
            kAppDelegate.notificationFrom = true
        print("Custom\(kAppDelegate.notificationFrom)")
        kAppDelegate.notificationShown = true
        kAppDelegate.showPushMessage(data: response.notification.request.content.userInfo, delay: 1)
        
      
        completionHandler()
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if notification.request.content.body  == "Digital key revoked"{
          completionHandler([])
            //kAppDelegate.mobileKeysController?.terminateEndpoint()
            UserDefaults.standard.set(nil, forKey: "invitationCode")
        } else {
            completionHandler([.alert, .sound])
        }
        
        
        
    }
    
    
}
