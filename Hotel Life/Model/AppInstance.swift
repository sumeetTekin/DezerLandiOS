//
//  AppInstance.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/25/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

private let _applicationInstance = AppInstance()


class AppInstance: NSObject {
    class var applicationInstance : AppInstance {
        return _applicationInstance
    }
    var user:UserModel? = UserModel()
    var device_token = ""
    var auth_token : String?
    var tokenExpired = false
    var VERBOSE_MODE = false
    var userLoggedIn = false
    var isCampaignListCalled = false
}
