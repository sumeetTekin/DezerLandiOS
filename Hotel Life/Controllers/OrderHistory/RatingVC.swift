//
//  RatingVC.swift
//  Resort Life
//
//  Created by Amit Verma on 18/03/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import UIKit

protocol RatingVCDelegate {
    func ratingVCResponse(controller : UIViewController)
    func cancelRatingVC(controller : UIViewController)
    
}

class RatingVC: BaseViewController , UITextViewDelegate{
    var delegate : RatingVCDelegate?
    var orderId : String?
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    @IBOutlet weak var messageTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        messageTextView.layer.borderColor = UIColor.gray.cgColor
        messageTextView.layer.borderWidth = 1.0;
        messageTextView.layer.cornerRadius = 5.0;
        
        messageTextView.text = "Enter a message..."
        messageTextView.textColor = UIColor.lightGray
        
        messageTextView.becomeFirstResponder()
        
        messageTextView.selectedTextRange = messageTextView.textRange(from: messageTextView.beginningOfDocument, to: messageTextView.beginningOfDocument)
        
        
        floatRatingView.backgroundColor = UIColor.clear
        
        /** Note: With the exception of contentMode, type and delegate,
         all properties can be set directly in Interface Builder **/
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings

        // Do any additional setup after loading the view.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "Enter a message..."
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.white
            textView.text = text
        }
            
            // For every other case, the text should change with the usual
            // behavior...
        else {
            return true
        }
        
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.delegate?.cancelRatingVC( controller: self)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        
        if messageTextView.text == ""{
            
            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: "Please fill massage field.")
            
        }else if messageTextView.textColor == .lightGray{
            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: "Please fill massage field.")
        }
        else if floatRatingView.rating == 0{
            
            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: "Please rate.")
            
        }else{
            self.rateOrderHistoryApi()
        }
        
        
      
    }
    
    private func rateOrderHistoryApi(){
        
        if let userID = Helper.ReadUserObject()?.userId{
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.activateView(self.view, loaderText:LOADER_TEXT.loading)
            })
            let bizz = BusinessLayer()
            var parms = [String:Any]()
            parms["_id"] = orderId!
            parms["value"] = self.floatRatingView.rating
            parms["review"] = messageTextView.text
            
            
            bizz.rateOrderHistory(userId: userID, params: parms) { (success, message) in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.deactivateView(self.view)
                    
                    if success{
                        self.delegate?.ratingVCResponse( controller: self)
                        
                    } else {
                        Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                    }
                })
                
            }
            
        }
        
    }
  

}

extension RatingVC: FloatRatingViewDelegate {
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        
    }
    
}
