//
//  BusinessLayer.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/25/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

enum METHOD {
    case post
    case get
    case put
    case delete
}
class CommunicationManager: NSObject {
    
    func request(type: METHOD, urlString : String, jsonString : String?) -> URLRequest? {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            // set method type
            switch type {
            case .post:
                request.httpMethod = "POST"
            case .get:
                request.httpMethod = "GET"
            case .put:
                request.httpMethod = "PUT"
            case .delete:
                request.httpMethod = "DELETE"
            }
            
            request.timeoutInterval = 60
            request.httpShouldHandleCookies = false
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            var language = "en"
            if let code = AppInstance.applicationInstance.user?.default_language {
                if code == "pt-BR" {
                    language = "pt"
                }else{
                    language = code
                }
            }
            request.setValue(language, forHTTPHeaderField: "language")
            request.setValue(String(format:"%@_%@",language, Locale.current.regionCode ?? ""), forHTTPHeaderField: "Accept-Language")
            request.setValue("ios", forHTTPHeaderField: "device_type")
            if let userId = AppInstance.applicationInstance.user?.userId{
                request.setValue(userId, forHTTPHeaderField: "user_id")
            }
            if let name = AppInstance.applicationInstance.user?.getSoapParamName(){
                request.setValue(name, forHTTPHeaderField: "name")
            }
            if let name = AppInstance.applicationInstance.user?.firstName{
                request.setValue(name, forHTTPHeaderField: "first_name")
            }
            if let name = AppInstance.applicationInstance.user?.lastName{
                request.setValue(name, forHTTPHeaderField: "last_name")
            }
            if let booking_no = Helper.getBookingNumber(){
                request.setValue(booking_no, forHTTPHeaderField: "booking_number")
            }
            
            if let token =  UserDefaults.standard.value(forKey: USERDEFAULTKEYS.DEVICE_TOKEN) as? String {
                request.setValue(token, forHTTPHeaderField: "device_id")
            }else{
                request.setValue("12345", forHTTPHeaderField: "device_id")
            }
            
            if let jsonData:Data = jsonString?.data(using: .utf8) {
                let postLength:String = String( jsonData.count )
                request.httpBody = jsonData
                request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            }
            else{
                request.httpBody = nil
                request.setValue("0", forHTTPHeaderField: "Content-Length")
            }
            
            if let token = AppInstance.applicationInstance.auth_token{
                //request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.setValue("\(token)", forHTTPHeaderField: "Authorization")

            }
            
            //            #if DEBUG
            //                request.setValue("false", forHTTPHeaderField: "production")
            //            #else
            //                request.setValue("true", forHTTPHeaderField: "production")
            //            #endif
            
            print(request.allHTTPHeaderFields ?? "No Headers")
            return request
        }
        else{
            //error in creating request
            return nil
        }
    }
    
    func POST(api:String, jsonString:String?, completionHandler:@escaping (_ success:Bool,_ response:String) -> Void) {
        if let request = request(type:.post, urlString: api, jsonString: jsonString) {
            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                print("request->\(request)")
                
                if error != nil {
                    Crashlytics.sharedInstance().recordError(error!, withAdditionalUserInfo: self.getRequiredInfo(requestURL: request.url, params: jsonString, response: response as? HTTPURLResponse, data: data))
                    self.handleError(error: error, {status, response in
                        completionHandler(status,response)
                    })
                }
                else{
                    self.handleResponse(request: request, jsonString: jsonString, response: response as? HTTPURLResponse, responseData: data, {status , response in
                        completionHandler(status,response)
                    })
                }
                
            }
            task.resume()
        }
        else{
            completionHandler(false,ERRORMESSAGE.INVALID_REQUEST)
        }
        
    }
    
    func GET(api:String, completionHandler:@escaping (_ success:Bool,_ response:String) -> Void) {
        
        if let request = request(type: .get, urlString: api, jsonString: nil){
            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                print("request->\(request)")
                
                if error != nil {
                    Crashlytics.sharedInstance().recordError(error!, withAdditionalUserInfo: self.getRequiredInfo(requestURL: request.url, params: nil, response: response as? HTTPURLResponse, data: data))
                    self.handleError(error: error, {status, response in
                        completionHandler(status,response)
                    })
                }
                else {
                    self.handleResponse(request: request, jsonString: nil, response: response as? HTTPURLResponse, responseData: data, {status , response in
                        //                        print("response->\(response)")
                        completionHandler(status,response)
                    })
                }
            }
            task.resume()
            
        }
        else{
            completionHandler(false,ERRORMESSAGE.INVALID_REQUEST)
        }
    }
    
    func PUT(api:String, jsonString:String?, completionHandler:@escaping (_ success:Bool,_ response:String) -> Void) {
        if let request = request(type: .put, urlString: api, jsonString: jsonString){
            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                print("request->\(request)")
                
                if error != nil {
                    Crashlytics.sharedInstance().recordError(error!, withAdditionalUserInfo: self.getRequiredInfo(requestURL: request.url, params: jsonString, response: response as? HTTPURLResponse, data: data))
                    self.handleError(error: error, {status, response in
                        completionHandler(status,response)
                    })
                }
                else {
                    self.handleResponse(request: request, jsonString: jsonString, response: response as? HTTPURLResponse, responseData: data, {status , response in
                        //                        print("response->\(response)")
                        completionHandler(status,response)
                    })
                }
            }
            task.resume()
        }
        else{
            completionHandler(false,ERRORMESSAGE.INVALID_REQUEST)
        }
    }
    func DELETE(api:String, jsonString:String?, completionHandler:@escaping (_ success:Bool,_ response:String) -> Void) {
        if let request = request(type: .delete, urlString: api, jsonString: jsonString){
            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                print("request->\(request)")
                
                if error != nil {
                    Crashlytics.sharedInstance().recordError(error!, withAdditionalUserInfo: self.getRequiredInfo(requestURL: request.url, params: jsonString, response: response as? HTTPURLResponse, data: data))
                    self.handleError(error: error, {status, response in
                        completionHandler(status,response)
                    })
                }
                else {
                    self.handleResponse(request: request, jsonString: jsonString, response: response as? HTTPURLResponse, responseData: data, {status , response in
                        //                        print("response->\(response)")
                        completionHandler(status,response)
                    })
                }
            }
            task.resume()
        }
        else{
            completionHandler(false,ERRORMESSAGE.INVALID_REQUEST)
        }
    }
    
    func handleResponse(request : URLRequest, jsonString : String?, response : HTTPURLResponse?, responseData : Data?, _ completionBlock : @escaping(_ success:Bool,_ response:String)->Void) {
        if let httpResponse = response {
            
            if httpResponse.statusCode != 200 {
                Crashlytics.sharedInstance().recordError(self.getErrorObj(code: httpResponse.statusCode), withAdditionalUserInfo: self.getRequiredInfo(requestURL: request.url, params: jsonString, response: response, data: responseData))
            }
            
            if httpResponse.statusCode == 808 || httpResponse.statusCode == 811 {
                let statusMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                
                
                DispatchQueue.main.async(execute: {
                    Helper.deactivateView(kAppDelegate.window!)
                    if let data = responseData{
                        if let responseString = String(data: data, encoding: .utf8) {
                            Helper.showalert(response: responseString)
                            completionBlock(false, responseString)
                        }else{
                            Helper.showalert(response: statusMessage)
                            completionBlock(false, statusMessage)
                        }
                    }
                    completionBlock(false, statusMessage)
                })
            }
            else if httpResponse.statusCode == 400{
                let statusMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                if let data = responseData{
                    if var responseString = String(data: data, encoding: .utf8) {
                        if responseString.characters.count == 0 {
                            responseString = String.localizedStringWithFormat("%@", statusMessage)
                        }
                        print(responseString,statusMessage)
                        DispatchQueue.main.async(execute: {
                            Helper.deactivateView(kAppDelegate.window!)
                        })
                        if let dict = Helper.convertToDictionary(text: responseString) {
                            print(dict)
                            
                            if let err = (dict["error"] as? NSArray)?.firstObject as? NSDictionary{
                                if let message = err["message"] as? String {
                                    completionBlock(false, message)
                                    return
                                }
                            }
                            if let facebook = dict["is_facebook"] as? Bool {
                                if facebook {
                                    completionBlock(false, "")
                                    return
                                }
                            }
                            if let message = dict["message"] as? String {
                                completionBlock(false, message)
                                return
                            }
                            //Important do not change
                            // for facebook login + signup we handle status 400 and respose string ""
                            completionBlock(false, "")
                            return
                            
                        }
                        completionBlock(false, statusMessage)
                    }else{
                        completionBlock(false, statusMessage)
                    }
                }
            }
            else if httpResponse.statusCode == 401{
                let statusMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                if let data = responseData{
                    if var responseString = String(data: data, encoding: .utf8) {
                        if responseString.characters.count == 0 {
                            responseString = String.localizedStringWithFormat("%@", statusMessage)
                        }
                        print(responseString,statusMessage)
                        DispatchQueue.main.async(execute: {
                            Helper.deactivateView(kAppDelegate.window!)
                        })
                        if let dict = Helper.convertToDictionary(text: responseString) {
                            print("response->\(dict)")
                            if let message = dict["message"] as? String{
                                completionBlock(false, message)
                            }
                            else{
                                completionBlock(false, statusMessage)
                            }
                        }
                        completionBlock(false, statusMessage)
                    }else{
                        completionBlock(false, statusMessage)
                    }
                }
                let obj = BusinessLayer()
                obj.signOut({ (status, message) in
                    if status {
                        print(message)
                    }
                    else{
                        print (message)
                    }
                    
                })
            }else if httpResponse.statusCode == 500{
                let statusMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                if let data = responseData{
                    if var responseString = String(data: data, encoding: .utf8) {
                        if responseString.characters.count == 0 {
                            responseString = String.localizedStringWithFormat("%@", statusMessage)
                        }
                        print(responseString,statusMessage)
                        DispatchQueue.main.async(execute: {
                            Helper.deactivateView(kAppDelegate.window!)
                        })
                        if let dict = Helper.convertToDictionary(text: responseString) {
                            print(dict)
                            
                            if let err = dict["error"]  as? NSDictionary{
                                if let message = err["message"] as? String {
                                    completionBlock(false, message)
                                    return
                                }
                            }
                            if let message = dict["message"] as? String {
                                completionBlock(false, message)
                                return
                            }
                            //Important do not change
                            // for facebook login + signup we handle status 400 and respose string ""
                            completionBlock(false, "")
                            return
                            
                        }
                        completionBlock(false, statusMessage)
                    }else{
                        completionBlock(false, statusMessage)
                    }
                }
            }
            else if httpResponse.statusCode != 200{
                let statusMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                if let data = responseData{
                    if var responseString = String(data: data, encoding: .utf8) {
                        if responseString.characters.count == 0 {
                            responseString = String.localizedStringWithFormat("%@", statusMessage)
                        }
                        DispatchQueue.main.async(execute: {
                            Helper.deactivateView(kAppDelegate.window!)
                        })
                        if let dict = Helper.convertToDictionary(text: responseString) {
                            print("response->\(dict)")
                            if let message = dict["message"] as? String{
                                completionBlock(false, message)
                            }
                            else{
                                completionBlock(false, statusMessage)
                            }
                        }
                        completionBlock(false, statusMessage)
                    }else{
                        completionBlock(false, statusMessage)
                    }
                }
            }
            else{
                let statusMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                if let data = responseData{
                    if let responseString = String(data: data, encoding: .utf8){
                        if let dict = Helper.convertToDictionary(text: responseString) {
                            print("response->\(dict)")
                        }
                        completionBlock(true, responseString)
                    }else{
                        completionBlock(false, statusMessage)
                    }
                }else{
                    completionBlock(false, statusMessage)
                }
            }
        }
    }
    
    func handleError(error : Error?, _ completionBlock : @escaping(_ success:Bool,_ response:String)->Void) {
        DispatchQueue.main.async(execute: {
            Helper.deactivateView(kAppDelegate.window!)
        })
        if let desc = error?.localizedDescription{
            completionBlock(false, desc)
        }
        else{
            completionBlock(false, ERRORMESSAGE.INCORRECT_RESPONSE)
        }
        
    }
    func getResponseDictionary(_ responseData:Data) -> NSDictionary? {
        do {
            if let responseDictionary: [String : AnyObject] = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary as! [String : AnyObject]?
            {
                return responseDictionary as NSDictionary?
            }
        } catch let error as NSError {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
        return nil
    }
    func getErrorObj(code : Int) -> Error {
        let error = NSError(domain:"Server Error", code:code, userInfo:nil)
        return  error as Error
    }
    func getRequiredInfo(requestURL : URL?, params : String?, response : HTTPURLResponse?, data : Data?) -> [String : Any]?{
        var dict : [String : Any] = [:]
        
        if let id = AppInstance.applicationInstance.user?.userId {
            dict["user_id"] = id
        }
        if let url = requestURL {
            dict["request_url"] = url
        }
        if let requestParams = params {
            dict["param"] = requestParams
        }
        if let urlResponse = response {
            dict["statusCode"] = urlResponse.statusCode
        }
        if let data = data {
            if let responseString = String(data: data, encoding: .utf8){
                dict["server_response"] = responseString
            }
        }
        //        print(dict)
        return dict
    }
    func getRequiredInfoDict(requestURL : URL?, params : [String:Any]?, response : HTTPURLResponse?, data : Data?) -> [String : Any]?{
        var dict : [String : Any] = [:]
        
        if let id = AppInstance.applicationInstance.user?.userId {
            dict["user_id"] = id
        }
        if let url = requestURL {
            dict["request_url"] = url
        }
        if let requestParams = params {
            dict["param"] = requestParams
        }
        if let urlResponse = response {
            dict["statusCode"] = urlResponse.statusCode
        }
        if let data = data {
            if let responseString = String(data: data, encoding: .utf8){
                dict["server_response"] = responseString
            }
        }
        //        print(dict)
        return dict
    }
    
    func PUTMULTIPART(api:String, parameters:[String:Any]?,file: Data?, completionHandler:@escaping (_ success:Bool,_ response:String) -> Void) {
        guard let url = URL(string: api) else {
            return
        }
        let request:NSMutableURLRequest? = NSMutableURLRequest(url: url)
        request?.httpMethod = "PUT"
        let boundary = _generateBoundaryString()
        let postData =  createBodyWithParameters(parameters: parameters, imagesData: file, boundary: boundary)
        request?.httpBody = postData as Data
        let postLength = NSString(format: "%ld", (postData as Data).count)
        request?.addValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request?.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if let userId = AppInstance.applicationInstance.user?.userId{
            request?.setValue(userId, forHTTPHeaderField: "user_id")
        }
        request?.timeoutInterval = 120.0
        print(request)
        if let request = request {
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in

                //            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                print("request->\(request)")

                if error != nil {
                    Crashlytics.sharedInstance().recordError(error!, withAdditionalUserInfo: self.getRequiredInfoDict(requestURL: request.url, params: parameters, response: response as? HTTPURLResponse, data: data))
                    self.handleError(error: error, {status, response in
                        completionHandler(status,response)
                    })
                }
                else {
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                        let jsonString = String(data: jsonData, encoding: .utf8)
                        self.handleResponse(request: request as URLRequest, jsonString: jsonString, response: response as? HTTPURLResponse, responseData: data, {status , response in
                            //                        print("response->\(response)")
                            completionHandler(status,response)
                        })
                    } catch{
                        Helper.printLog(error.localizedDescription as AnyObject?)
                    }
                }
            })
            task.resume()
        }
        else{
            completionHandler(false,ERRORMESSAGE.INVALID_REQUEST)
        }
    }
    private func createBodyWithParameters(parameters: [String: Any]?, imagesData: Data?,boundary: String) -> NSData {

        let body = NSMutableData()
        if let requestParameter = parameters {
            for (key, value) in requestParameter {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        if let data = imagesData {
                let key = Helper.getCurrentTimestampString()
                let filename = "\(key).jpeg"
                let mimetype = "image/jpeg"
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                body.append(data)
                body.appendString("\r\n")
        }
        // body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        return body
    }

    private func _generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
 
}
//extension CommunicationManager {
//    func UPLOADIMAGE(method : String, imageArray : [UIImage], api:String, params: [String:Any], completionHandler: @escaping (_ success:Bool, _ response:String) -> Void) {
//
//        guard let url = URL(string:api) else{
//            return
//        }
//        var request = URLRequest.init(url: url)
//        request.httpMethod = method
//
//
//        let boundary = generateBoundaryString()
//
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        request.httpBody = createBodyWithParameters(parameters: params, filePathKey: "fileName", images: imageArray, boundary: boundary)
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if error != nil {
//                print("error=",error?.localizedDescription ?? "Error in image upload")
//                return
//            }
//
//            // You can print out response object
//            print("******* response =",response ?? "No response in image upload")
//
//            // Print out reponse body
//            if let data = data {
//                let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
//                print("****** response data = \(responseString!)")
//                completionHandler(true, responseString as! String)
//            }
//
//        }
//        task.resume()
//    }
//
//
//    func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String, images: [UIImage], boundary: String) -> Data {
//        let body = NSMutableData();
//        //  appent parameters
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.appendString("--\(boundary)\r\n")
//                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.appendString("\(value)\r\n")
//            }
//        }
//        //        body.appendString("--\(boundary)\r\n")
//
//        // append images
//        var i = 1
//        let mimetype = "image/jpg"
//        for image in images {
//            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
//                let name = "image\(i)"
//                let filename = "\(randomString(length: 20)).jpg"
//                body.appendString("--\(boundary)\r\n")
//                body.appendString("Content-Disposition: form-data; name=\"\(name)\"; fileName=\"\(filename)\"\r\n")
//                body.appendString("Content-Type: \(mimetype)\r\n\r\n")
//                body.append(imageData)
//                body.appendString("\r\n")
//                i = i + 1
//            }
//        }
//        body.appendString("--\(boundary)--\r\n")
//        return body as Data
//    }
//
//    func generateBoundaryString() -> String {
//        return "Boundary-\(NSUUID().uuidString)"
//    }
//
//    func randomString(length: Int) -> String {
//        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        let len = UInt32(letters.length)
//        var randomString = ""
//        for _ in 0 ..< length {
//            let rand = arc4random_uniform(len)
//            var nextChar = letters.character(at: Int(rand))
//            randomString += NSString(characters: &nextChar, length: 1) as String
//        }
//        return randomString
//    }
//}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true) {
            append(data)
        }
    }
}


