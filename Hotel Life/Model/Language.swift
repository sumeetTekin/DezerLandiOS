//
//  Language.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 13/12/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class Language: NSObject {
    
    var languageKey : String = ""
    var languageTitle : String = ""
    var languageCode : String = ""
    var image : UIImage?
    
    override init() {
        
    }
    
    required public init?(languageKey : String, languageTitle : String, languageCode : String, languageImage : UIImage?) {
        self.languageKey = languageKey
        self.languageTitle = languageTitle
        self.languageCode = languageCode
        self.image = languageImage
    }
    
    
}
