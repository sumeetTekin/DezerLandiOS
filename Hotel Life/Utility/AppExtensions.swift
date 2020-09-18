import UIKit

extension UIView {
	// Name this function in a way that makes sense to you... 
	// slideFromLeft, slideRight, slideLeftToRight, etc. are great alternative names
	func slideInFromLeft(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
		// Create a CATransition animation
		let slideInFromLeftTransition = CATransition()
		
		// Set its callback delegate to the completionDelegate that was provided (if any) 
		if let delegate: AnyObject = completionDelegate {
			slideInFromLeftTransition.delegate = delegate as? CAAnimationDelegate
		}
		
		// Customize the animation's properties
		slideInFromLeftTransition.type = kCATransitionPush
		slideInFromLeftTransition.subtype = kCATransitionFromLeft
		slideInFromLeftTransition.duration = duration
		slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		slideInFromLeftTransition.fillMode = kCAFillModeRemoved
		
		// Add the animation to the View's layer
		self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
	}
    func slideInFromRight(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromRightTransition.delegate = delegate as? CAAnimationDelegate
        }
        
        // Customize the animation's properties
        slideInFromRightTransition.type = kCATransitionPush
        slideInFromRightTransition.subtype = kCATransitionFromRight
        slideInFromRightTransition.duration = duration
        slideInFromRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromRightTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(slideInFromRightTransition, forKey: "slideInFromLeftTransition")
    }
    
    func cornerRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }
    func setBorderColor(borderWidth : CGFloat, borderColor : UIColor, cornerRadius : CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
    }
    func roundCornersWithLayerMask(cornerRadii: CGFloat, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.width
    }
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
extension UIApplication {
   @objc class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
extension Date
{
    func isBetween(startDate:Date, endDate:Date)->Bool
    {
        return (startDate.compare(self) == .orderedAscending) && (endDate.compare(self) == .orderedDescending)
    }
}
//extension CLLocation {
//    // In meteres
//    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
//        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
//        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
//        return from.distance(from: to)
//    }
//}
extension NSMutableAttributedString {
    func bold(_ text:String, font: UIFont) -> NSMutableAttributedString {
        let attrs:[NSAttributedStringKey:AnyObject] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : font]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    func normalText(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
//    func calculateDuration(from date: Date) -> String {
//        let totalSeconds  = self.seconds(from: date)
//        let hr = totalSeconds / 3600
//        let min = (totalSeconds % 3600) / 60
//        let sec = ((totalSeconds % 3600) % 60)
//        var time = ""
//        if (hr >= 1) {
//            time = String(format: "%02d:%02d",hr, min)
//            return (hr == 1) ? time + " " + LocalizedString("hr") : time + " " + LocalizedString("hrs")
//        } else if (min >= 1) {
//            time = String(format: "%02d:%02d",min, sec)
//            return (min == 1) ? time +  " " + LocalizedString("min") : time + " " + LocalizedString("mins")
//        } else {
//            return (sec == 1) ? "\(sec)" + " " + LocalizedString("sec") : "\(sec)" + " " + LocalizedString("secs")
//        }
//    }
    
//    func calculateDurationInDays(from date: Date) -> String {
//        let day = date.days(from: Date())
//        let totalSeconds  = self.seconds(from: date)
//        let hr = totalSeconds / 3600
//        let min = (totalSeconds % 3600) / 60
//        let sec = ((totalSeconds % 3600) % 60)
//        var time = ""
//        if (day == 1) {
//            time = String(format: "%02d %@ %02d",day, LocalizedString("day"), hr)
//            return (hr == 1) ? time + " " + LocalizedString("hr") : time + " " + LocalizedString("hrs")
//        }else if (day > 1) {
//            time = String(format: "%02d %@ %02d",day, LocalizedString("days"), hr)
//            return (hr == 1) ? time + " " + LocalizedString("hr") : time + " " + LocalizedString("hrs")
//        }else if (hr >= 1) {
//            time = String(format: "%02d:%02d",hr, min)
//            return (hr == 1) ? time + " " + LocalizedString("hr") : time + " " + LocalizedString("hrs")
//        } else if (min >= 1) {
//            time = String(format: "%02d:%02d",min, sec)
//            return (min == 1) ? time +  " " + LocalizedString("min") : time + " " + LocalizedString("mins")
//        } else {
//            return (sec == 1) ? "\(sec)" + " " + LocalizedString("sec") : "\(sec)" + " " + LocalizedString("secs")
//        }
//    }
}

extension Double {
    
    func formateCurrency
        () -> String {
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        //currencyFormatter.locale = NSLocale.current
        currencyFormatter.locale = NSLocale.init(localeIdentifier :  "de_DE") as Locale!
        let priceString = currencyFormatter.string(from: NSNumber.init(value: self))
        return priceString!
        
    }
    
    func numberFormatter() -> String {
        
        let nf = NumberFormatter()
        nf.locale = Locale.current
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 2
        let outputVal = nf.string(from: NSNumber(value: self))
        return outputVal!
        
    }
}

extension UITextField{
    func textFieldDesign()-> UITextField  {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        let leftPaddingViewyearsTxt = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        self.leftView = leftPaddingViewyearsTxt
        self.leftViewMode = .always
        return self
    }
}
