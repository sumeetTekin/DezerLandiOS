//
//  Amenities.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 15/05/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit

public class Amenities: NSObject {
    
    public var name : String?
    public var quantity : Int?
    
//    public class func modelsFromDictionaryArray(array:NSArray) -> [Amenities]
//    {
//        var models:[Amenities] = []
//        for item in array
//        {
//            if let item = item as? NSDictionary {
//                models.append(Amenities(dictionary: item)!)
//            }
//        }
//        return models
//    }
    required public init?(nameStr: String?) {
        name = nameStr
    }
    
}
