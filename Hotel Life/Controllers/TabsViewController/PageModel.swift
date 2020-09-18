//
//  PageModel.swift
//  VMPageImageTitleVC
//
//  Created by Vikas Mehay on 11/11/17.
//  Copyright © 2017 Vikas Mehay. All rights reserved.
//

import UIKit

class PageModel: NSObject {

    var title : String? = ""
    var imageURL : URL?
    var highlightedImageUrl : URL?
    var barColor : UIColor? = .white
    var viewController : UIViewController?
    var isSelected : Bool = false
    var image : UIImage?
    var highlightedImage : UIImage?
    
}
