//
//  HashtagTextView.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 09/10/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
enum wordType {
    case hashtag
}

typealias callback = (String, wordType) -> Void
class HashtagTextView: UITextView {
    var textString : NSString?
    var attrString : NSMutableAttributedString?
    var callback : (callback)?
//    var words : [String] = []
    public func setText(text : String, hashtagColor : UIColor, normalFont : UIFont, hashtagFont : UIFont, callback : @escaping callback) {
        self.callback = callback
        self.attrString = NSMutableAttributedString(string: text)
        self.textString = NSString(string: text)
        
//      set initial font for our string
        attrString?.addAttribute(NSAttributedStringKey.font, value: normalFont, range: NSRange.init(location: 0, length: text.characters.count))
        attrString?.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange.init(location: 0, length: text.characters.count))
        
//      call a custom  set hashtag and mention 
        setAttrWithName(attrName: "Hashtag", wordPrefix: "#", color: hashtagColor, text: text, font: hashtagFont)
        
        //add gesture recogniozer if required
    }
    public func setText(text : String, hashtagColor : UIColor, normalColor : UIColor, normalFont : UIFont, hashtagFont : UIFont) {
        self.attrString = NSMutableAttributedString(string: text)
        self.textString = NSString(string: text)
        
        //      set initial font for our string
        attrString?.addAttribute(NSAttributedStringKey.font, value: normalFont, range: NSRange.init(location: 0, length: text.characters.count))
        attrString?.addAttribute(NSAttributedStringKey.foregroundColor, value: normalColor, range: NSRange.init(location: 0, length: text.characters.count))
        
        //      call a custom  set hashtag and mention
        setAttrWithName(attrName: "Hashtag", wordPrefix: "#", color: hashtagColor, text: text, font: hashtagFont)
        
        //add gesture recogniozer if required
    }
    
    private func setAttrWithName(attrName: String, wordPrefix: String, color: UIColor, text: String, font: UIFont) {
        let words = text.components(separatedBy: " ")
        var location = 0
        for word in words {
            if word.hasPrefix(wordPrefix) {
                guard var range = getRange(word: word)
                    else{
                        continue
                }
                if range.location < location {
                    range.location = location
                }
                attrString?.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
                attrString?.addAttribute(NSAttributedStringKey.font, value: font, range: range)
            }
            location = location + word.characters.count + 1
        }
        self.attributedText = attrString
    }
    
    func getRange(word : String) -> NSRange?{
        let range = textString?.range(of: word)
        return range
    }
}





