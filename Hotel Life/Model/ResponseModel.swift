//
//  ResponseModel.swift
//  bikuh
//
//  Created by Mamta Devi on 12/21/16.
//  Copyright © 2016 Ritesh Chopra. All rights reserved.
//

import UIKit

class ResponseModel: NSObject, NSCoding  {

    var message: String?
    
    override init()
    {
        //email=nil
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        // self.email = aDecoder.decodeObject(forKey: "email")  as? String
        
    }
    
    open func encode(with _aCoder: NSCoder) {
        //  _aCoder.encode(self.email, forKey: "email")
        
    }
    
    func toDictionary() -> NSMutableDictionary {
        let dict:NSMutableDictionary = NSMutableDictionary()
        // dict.setValue(self.email!, forKey: "email")
        
        return dict
    }
    
    
    required public init(data: [String: AnyObject]) {
        super.init()
        print(data)
        message = data["message"] as? String
        
    }
}
