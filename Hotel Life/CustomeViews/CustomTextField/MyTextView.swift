//
//  MyTextView.swift
//  MyPortfolio
//
//  Created by jasvinders.singh on 8/30/17.
//  Copyright © 2017 Good Grid. All rights reserved.
//

import UIKit

class MyTextView: UITextView {
    var placeholder : String?
    var placeholderColor : UIColor?
    var text_color : UIColor?
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        // Drawing code
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0

    }
    func set(text : String, placeholder : String, placeholderColor : UIColor, text_color : UIColor) {
        self.delegate = self
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
        self.text_color = text_color
        if text == "" {
            self.text = placeholder
            self.textColor = placeholderColor
        }else{
            self.text = text
            self.textColor = text_color
        }
    }

}
extension MyTextView : UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = self.text_color
        }
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == "" {
            textView.text = placeholder
            textView.textColor = self.placeholderColor
        }
        return true
    }
}
