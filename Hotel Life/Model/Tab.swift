//
//  Tab.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 10/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class Tab: NSObject {

        public var departments : [Department]? = []
        public var name : String? = ""
        public var slug : String? = ""
        public var is_drink : Bool = false
    
        public var selectedImageUrl : URL?
        public var unSelectedImageUrl : URL?
    
        override init() {
            
        }
        
        public class func modelsFromDictionaryArray(array:NSArray, imagePath : String) -> [Tab]
        {
            var models:[Tab] = []
            for item in array
            {
                models.append(Tab(dictionary: item as! NSDictionary, imagePath : imagePath)!)
            }
            return models
        }
        
        
        required public init?(dictionary: NSDictionary , imagePath : String) {
            // check if it is a drink tab
            if let isDrink = dictionary["is_drink"] as? Bool {
                is_drink = isDrink
            }
            
            if let menus = dictionary["sub_sections"] as? NSArray {
                departments = Department.modelsFromDictionaryArray(array: menus, imagePath: imagePath, is_drink: self.is_drink)
            }
            if let text = dictionary["name"] as? String {
                name = text
            }
            if let text = dictionary["slug"] as? String {
                slug = text
            }
            if let img = dictionary["icon2"] as? String {
                selectedImageUrl = URL.init(string:"\(imagePath)\(img)")
            }
            if let img = dictionary["icon"] as? String {
                unSelectedImageUrl = URL.init(string:"\(imagePath)\(img)")
            }
            
        }
}

//data =     (
//    {
//        icon = "";
//        icon2 = "";
//        name = "";
//        slug = "";
//        "sub_sections" =             (
//            {
//                items =                     (
//                    {
//                        "_id" = 59d4a972194f83110fede2f8;
//                        "available_quantity" = 10;
//                        category = 5a02f8ca6db363209ab93d8e;
//                        image = "1507109233866.png";
//                        "is_active" = 1;
//                        "is_deleted" = 0;
//                        "max_quantity" = 10;
//                        name = "Single Beds";
//                        price = 75;
//                },
//                    {
//                        "_id" = 59d4a9f376a65c5a710522c0;
//                        "available_quantity" = 20;
//                        category = 5a02f8ca6db363209ab93d8e;
//                        image = "1507109363086.png";
//                        "is_active" = 1;
//                        "is_deleted" = 0;
//                        "max_quantity" = 20;
//                        name = "Double Beds";
//                        price = 150;
//                },
//                    {
//                        "_id" = 59d4aa6576a65c5a710522c1;
//                        "available_quantity" = 20;
//                        category = 5a02f8ca6db363209ab93d8e;
//                        image = "1507109476581.png";
//                        "is_active" = 1;
//                        "is_deleted" = 0;
//                        "max_quantity" = 20;
//                        name = "Cabana - Upper Pool";
//                        price = 200;
//                },
//                    {
//                        "_id" = 59d4aa7776a65c5a710522c2;
//                        "available_quantity" = 19;
//                        image = "1507109495118.png";
//                        "is_active" = 1;
//                        "is_deleted" = 0;
//                        "max_quantity" = 20;
//                        name = "Cabana - Lower Pool";
//                        price = 300;
//                },
//                    {
//                        "_id" = 59d4aa8476a65c5a710522c3;
//                        "available_quantity" = 20;
//                        image = "1507109508712.png";
//                        "is_active" = 1;
//                        "is_deleted" = 0;
//                        "max_quantity" = 20;
//                        name = "Cabana - Beach";
//                        price = 300;
//                },
//                    {
//                        "_id" = 59d4aa9576a65c5a710522c4;
//                        "available_quantity" = 20;
//                        image = "1507109525470.png";
//                        "is_active" = 1;
//                        "is_deleted" = 0;
//                        "max_quantity" = 20;
//                        name = "Cabana - Lower Pool Double";
//                        price = 400;
//                }
//                );
//                name = "";
//                slug = "";
//            }
//        );
//    }
//);
//imagesPath = "http://52.34.207.5:4108/uploadedFiles/";
//msg = "Data retrieved successfully ";
//})
//
//
