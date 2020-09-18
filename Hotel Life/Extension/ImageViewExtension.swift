//
//  ImageViewExtension.swift
//  Kangaroo Propane
//
//  Created by Adil Mir on 11/21/19.
//  Copyright © 2019 Adil Mir. All rights reserved.
//

import SDWebImage
import Foundation

extension UIImageView {
    func setImage(url: URL?, with placeholder: UIImage?) {
        //self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: url, placeholderImage: placeholder, options: .refreshCached, completed: nil)
    }
}
