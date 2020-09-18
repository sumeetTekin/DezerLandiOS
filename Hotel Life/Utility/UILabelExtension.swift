//
//  UILabelExtension.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 03/01/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import Foundation
import UIKit
private var AssociatedObjectHandle: UInt8 = 0

extension UILabel : UIGestureRecognizerDelegate {
    var clickableText:String {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? String ?? ""
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var range:NSRange {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? NSRange ?? NSRange.init(location: 0, length: 0)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setClickableText(completeText : String, clickableText : String, tapAction : @escaping (_ text : String)-> Void) {
        let mutableAttributedString = NSMutableAttributedString(string: completeText, attributes: nil)
        if completeText.contains(clickableText){
            let linkRange : NSRange = (completeText as NSString).range(of: clickableText)
            mutableAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: COLORS.THEME_YELLOW_COLOR, range: linkRange)
            
            self.clickableText = clickableText
            self.range = linkRange
        }
        self.attributedText = mutableAttributedString
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.actionHandle {
            tapAction(clickableText)
        }
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }

    
}

extension UITapGestureRecognizer {
    private func actionHandleBlock(action:(() -> Void)? = nil) {
        struct __ {
            static var action :(() -> Void)?
        }
        if action != nil {
            __.action = action
        } else {
            __.action?()
        }
    }
    
    @objc private func triggerActionHandleBlock() {
        self.actionHandleBlock()
    }
    
    func actionHandle(action:@escaping () -> Void) {
        self.actionHandleBlock(action : action)
        self.addTarget(self, action: #selector(triggerActionHandleBlock))
    }
}
