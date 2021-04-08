
//  WebServiceManager.swift
//  Qvafy
//
//  Created by ios-deepak b on 09/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.

import UIKit
import Alamofire

//import KRProgressHUD
//import KRActivityIndicatorView
import SVProgressHUD
import MBProgressHUD

var  strAuthToken : String = ""
//let stripeKey = "Bearer sk_test_51HICv5AinsnjiJjUKIBJ8gfkFGWm0beQeJCRKW3SpCo1BtkVMKnhROuYXfsfk3lEDb4btxwS1FfODPKwGFyT98R100G8APXwK0" // new for dev

let objWebServiceManager = WebServiceManager.sharedObject()
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
class WebServiceManager: NSObject {
    var hud: MBProgressHUD = MBProgressHUD()
    //MARK: - Shared object
    
    private static var sharedNetworkManager: WebServiceManager = {
        let networkManager = WebServiceManager()
        return networkManager
    }()
    // MARK: - Accessors
    class func sharedObject() -> WebServiceManager {
        return sharedNetworkManager
    }
    
    // MARK: - Multipart method Multiple Image Upload  start----
    
      public func uploadMultipartMultipleImagesData(strURL:String, params :  [String:Any]?,showIndicator:Bool, imageData:Data?,imageToUpload:[Data],imagesParam:[String], fileName:String?, mimeType:String?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void){
        
            if !NetworkReachabilityManager()!.isReachable{
                let app = UIApplication.shared.delegate as? AppDelegate
                let window = app?.window
                objAlert.showAlertVc(title: NoNetwork.localize, controller: window!)
                DispatchQueue.main.async {
                    self.StopIndicator()
                }
                return
            }
        
              strAuthToken = ""
               if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
                   strAuthToken = "Bearer" + " " + token
               }
        
        let selectedlanguage =  String(UserDefaults.standard.string(forKey: "Selectdlanguage") ?? "")
       // var selectedLanguage  = LocalizationSystem.sharedInstance.getLanguage()
      //  WsHeader.CurrentLanguage:selectedLanguage
        
//        if BASE_URL.contains("dev"){
//
//        }else{
//            selectedLanguage = ""
//        }

            var strUdidi = ""
            if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.strVenderId) {
                print("defaults VenderID: \(MyUniqueId)")
                strUdidi = MyUniqueId
            }

            let currentTimeZone = getCurrentTimeZone()

            let header: HTTPHeaders = [
                "Authorization": strAuthToken,
                "Accept": "application/json",
                WsHeader.deviceId:strUdidi,
                WsHeader.deviceType:"1",
                WsHeader.timeZone: currentTimeZone,
                WsHeader.CurrentLanguage:selectedlanguage
                
            ]
        
            Alamofire.upload(multipartFormData:{ multipartFormData in

                let count = imageToUpload.count

                for i in 0..<count{
                    multipartFormData.append(imageToUpload[i], withName: "\(imagesParam[i])", fileName: "file\(i).jpeg" , mimeType: mimeType!)
                }
                
                
                for (key, value) in params ?? [:] {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            },
                             usingThreshold:UInt64.init(),
                             to:strURL,
                             method:.post,
                             headers: header,
                             
                             encodingCompletion: { encodingResult in
                                switch encodingResult {
//                                case .success(let upload, , ):
//                                    upload.responseJSON { response in
//
                                        case .success(let upload, _, _):
                                            upload.responseJSON { response in
                                        
                                        do {
                                            let dictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                            
                                            //////
                                            let error =  dictionary["error_type"] as? String
                                            let statusCode =   dictionary["status_code"] as? Int ?? 0
                                            print(statusCode)
                                            if statusCode ==  400 {
                                               
                                                
                                                if error == "SESSION_EXPIRED" ||  error == "USER_NOT_FOUND" ||  error == "ACCOUNT_DISABLED" || error == "ACCOUNT_INACTIVE"  {
                                                   
                                                    self.showSessionFailAlert(msg: "Your session is expired , please login again".localize)
                                                    return
                                                }
                                            }
                                            /////
                                            
                                            success(dictionary as! Dictionary<String, Any>)
                                        }catch{
                                        }
                                        
                                    }
                                case .failure(let encodingError):
                                    print(encodingError)
                                    failure(encodingError)
                                }
            })
        }

    
    // MARK: - Request Post  method ----
    
    public func requestPost(strURL:String, params : [String:Any], strCustomValidation:String , showIndicator:Bool, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void) {

        
        if !NetworkReachabilityManager()!.isReachable{
            DispatchQueue.main.async {
            }
            return
        }
        
        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
            strAuthToken = "Bearer" + " " + token
        }
       // let selectedLanguage  = LocalizationSystem.sharedInstance.getLanguage()
        let selectedlanguage =  String(UserDefaults.standard.string(forKey: "Selectdlanguage") ?? "")
                
        var strUdidi =  ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        let header: HTTPHeaders = [
            "Authorization": strAuthToken,
            "Accept": "application/json",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.timeZone: currentTimeZone,
            WsHeader.CurrentLanguage:selectedlanguage
        ]
        print("header....\(header)")
        
        print("Url....\(strURL)")
        Alamofire.upload(multipartFormData:{ multipartFormData in
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }},
                         usingThreshold:UInt64.init(),
                         to:strURL,
                         method:.post,
                         headers:  header,
                         
                         
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                                
                                
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    
                                    do {
                                        let dictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                        
                                      //  let status =   dictionary["status"] as? String
                                        let error =  dictionary["error_type"] as? String
                                        let statusCode =   dictionary["status_code"] as? Int ?? 0
                                        let message =  dictionary["message"] as? String
                                        print(statusCode)
                                        if statusCode ==  400 {
                                           
                                            
                                            if error == "SESSION_EXPIRED" ||  error == "USER_NOT_FOUND" ||  error == "ACCOUNT_DISABLED" || error == "ACCOUNT_INACTIVE"  {
                                               
                                               // text.contains("success")
                                                if strURL.contains("api/v1/auth/login"){
                                                    self.showSessionFailAlert(msg: message!)
                                                }else{
                                                    self.showSessionFailAlert(msg: "Your session is expired , please login again".localize)
                                                    return
                                                }
                                            }
                                        }
                                        success(dictionary as! Dictionary<String, Any>)
                                        
                                        
                                    }catch{
                                    }
                                    self.StopIndicator()
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                self.StopIndicator()
                                failure(encodingError)
                            }
        })
    }
    

    
    ////
    // MARK: - Multipart method Image Upload ----
    
    public func uploadMultipartData(strURL:String, params :  [String:Any]?,queryParams : [String:Any],strCustomValidation:String ,showIndicator:Bool, imageData:Data?, fileName:String?, mimeType:String?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void){
        
        if !NetworkReachabilityManager()!.isReachable{
            DispatchQueue.main.async {
            }
            return
        }
    
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        var strUdidi =  ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let selectedlanguage =  String(UserDefaults.standard.string(forKey: "Selectdlanguage") ?? "")
//        let selectedLanguage  = LocalizationSystem.sharedInstance.getLanguage()
      //  WsHeader.CurrentLanguage:selectedLanguage

        
        let currentTimeZone = getCurrentTimeZone()
        
        let header: HTTPHeaders = [
            "Authorization": strAuthToken,
            "Accept": "application/json",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.timeZone: currentTimeZone,
            WsHeader.CurrentLanguage:selectedlanguage

        ]
        print("header....\(header)")
        
        print("Url....\(strURL)")
        
        var StrCompleteUrl = ""
        if strCustomValidation ==  WsParamsType.PathVariable{
            let pathvariable = queryParams.PathString
            StrCompleteUrl  = "\(strURL)"   + (pathvariable) +  "/attachments"
            print("pathvariablepathvariable.....\(pathvariable)")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams{
            StrCompleteUrl = self.queryString(strURL, params: queryParams ?? [:]) ?? ""
        }
        else{
            StrCompleteUrl = strURL
        }
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            if let data = imageData {
                multipartFormData.append(data,
                                         withName:fileName!,
                                         fileName: "file.jpeg",
                                         mimeType:mimeType!)
            }
            
            for (key, value) in params ?? [:] {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        },
                         usingThreshold:UInt64.init(),
                         to:StrCompleteUrl,
                         method:.post,
                         headers: header,
                         
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    
                                    do {
                                        let dictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                        //////
                                        let error =  dictionary["error_type"] as? String
                                        let statusCode =   dictionary["status_code"] as? Int ?? 0
                                        print(statusCode)
                                        if statusCode ==  400 {
                                           
                                            
                                            if error == "SESSION_EXPIRED" ||  error == "USER_NOT_FOUND" ||  error == "ACCOUNT_DISABLED" || error == "ACCOUNT_INACTIVE"  {
                                               
                                                self.showSessionFailAlert(msg: "Your session is expired , please login again".localize)
                                                return
                                            }
                                        }
                                        /////
                                        success(dictionary as! Dictionary<String, Any>)
                                    }catch{
                                    }
                                    
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                failure(encodingError)
                            }
        })
    }
    ////
    
    // MARK: - Request get method ----
    
    public func requestGet(strURL:String, Queryparams : [String : Any]?, body : [String : Any]?, strCustomValidation:String , success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        
        if !NetworkReachabilityManager()!.isReachable{
            DispatchQueue.main.async {
            }
            return
        }

        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        var strUdidi =  ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        let selectedlanguage =  String(UserDefaults.standard.string(forKey: "Selectdlanguage") ?? "")
        //let selectedLanguage  = LocalizationSystem.sharedInstance.getLanguage()
            //WsHeader.CurrentLanguage:selectedLanguage

        let headers: HTTPHeaders = [
            "Authorization": strAuthToken ,
            "Accept": "application/json",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.timeZone: currentTimeZone,
            WsHeader.CurrentLanguage:selectedlanguage

        ]
     
        var StrCompleteUrl = ""
        
        if strCustomValidation ==  WsParamsType.PathVariable
        {
            let pathvariable = Queryparams?.PathString
            StrCompleteUrl  = "\(strURL)"   + (pathvariable ?? "")
            print("pathvariablepathvariable.....\(pathvariable ?? "")")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams
        {
            StrCompleteUrl = self.queryString(strURL, params: Queryparams ?? [:]) ?? ""
        }
        else
        {
            StrCompleteUrl = strURL
        }
        
        StrCompleteUrl = StrCompleteUrl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print("url....\(StrCompleteUrl)")
        print("header....\(headers)")
        Alamofire.request(StrCompleteUrl, method: .get, parameters: body, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
            
            self.StopIndicator()
            
            if responseObject.result.isSuccess {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                  //  let status =   dictionary["status"] as? String
                    let error =  dictionary["error_type"] as? String
                    let statusCode =   dictionary["status_code"] as? Int ?? 0
                    print(statusCode)
                    if statusCode ==  400 {
                       
                        
                        if error == "SESSION_EXPIRED" ||  error == "USER_NOT_FOUND" ||  error == "ACCOUNT_DISABLED" || error == "ACCOUNT_INACTIVE"  {
                           
                            self.showSessionFailAlert(msg: "Your session is expired , please login again".localize)
                            return
                        }
                    }
                    
                    success(dictionary as! Dictionary<String, Any>)
                    
                    
                }catch{
                    
                    let error : Error = responseObject.result.error!
                    failure(error)
                    let str = String(decoding:  responseObject.data!, as: UTF8.self)
                    print("PHP ERROR : \(str)")
                }
            }
            if responseObject.result.isFailure {
                self.StopIndicator()
                let error : Error = responseObject.result.error!
                failure(error)
                
                let str = String(decoding:  responseObject.data!, as: UTF8.self)
                print("PHP ERROR : \(str)")
            }
        }
    }
        
    // MARK: - Request Patch method ----
    
    public func requestPatch(strURL:String, params : [String : AnyObject]?, strCustomValidation:String , success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        if !NetworkReachabilityManager()!.isReachable{
            DispatchQueue.main.async {
            }
            return
        }
        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        var strUdidi =  ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let selectedlanguage =  String(UserDefaults.standard.string(forKey: "Selectdlanguage") ?? "")       // let selectedLanguage  = LocalizationSystem.sharedInstance.getLanguage()
            //WsHeader.CurrentLanguage:selectedLanguage
        
        let headers: HTTPHeaders = [
            "Authorization": strAuthToken ,
            "Accept": "application/json",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.timeZone: currentTimeZone,
            WsHeader.CurrentLanguage:selectedlanguage

        ]
        
        print("url....\(strURL)")
        print("header....\(headers)")
        Alamofire.request(strURL, method: .patch, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
            
            self.StopIndicator()
            
            if responseObject.result.isSuccess {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    
                 //  let status =   dictionary["status"] as? String
                    let error =  dictionary["error_type"] as? String
                    let statusCode =   dictionary["status_code"] as? Int ?? 0
                    print(statusCode)
                    if statusCode ==  400 {
                       
                        
                        if error == "SESSION_EXPIRED" ||  error == "USER_NOT_FOUND" ||  error == "ACCOUNT_DISABLED" || error == "ACCOUNT_INACTIVE"  {
                           
                            self.showSessionFailAlert(msg: "Your session is expired , please login again".localize)
                            return
                        }
                    }
                    
                    success(dictionary as! Dictionary<String, Any>)
                    
                }catch{
                    
                    let error : Error = responseObject.result.error!
                    failure(error)
                    let str = String(decoding:  responseObject.data!, as: UTF8.self)
                    print("PHP ERROR : \(str)")
                }
            }
            if responseObject.result.isFailure {
                self.StopIndicator()
                let error : Error = responseObject.result.error!
                failure(error)
                
                let str = String(decoding:  responseObject.data!, as: UTF8.self)
                print("PHP ERROR : \(str)")
            }
        }
    }
    
    
    // MARK: - Request Put  method ----
    
    public func requestPut(strURL:String, Queryparams : [String:Any]?, body : [String:Any]?,strCustomValidation:String, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        if !NetworkReachabilityManager()!.isReachable{
            DispatchQueue.main.async {
            }
            return
        }

        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        var strUdidi =  ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        
        let selectedlanguage =  String(UserDefaults.standard.string(forKey: "Selectdlanguage") ?? "")
//        let selectedLanguage  = LocalizationSystem.sharedInstance.getLanguage()
            //WsHeader.CurrentLanguage:selectedLanguage
        
        
        
        let headers: HTTPHeaders = [
            "Authorization": strAuthToken ,
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.timeZone: currentTimeZone,
            WsHeader.CurrentLanguage:selectedlanguage

        ]
        
        var StrCompleteUrl = ""
        
        if strCustomValidation ==  WsParamsType.PathVariable
        {
            let pathvariable = Queryparams?.PathString
            StrCompleteUrl  = "\(strURL)"   + (pathvariable ?? "")
            print("pathvariablepathvariable.....\(pathvariable ?? "")")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams
        {
            StrCompleteUrl = self.queryString(strURL, params: Queryparams ?? [:]) ?? ""
        }
        else
        {
            StrCompleteUrl = strURL
        }
        
        
        print("url.....\(StrCompleteUrl)")
        Alamofire.request(StrCompleteUrl, method: .put, parameters: body, encoding: URLEncoding.httpBody, headers: headers).responseJSON { responseObject in
            
            if responseObject.result.isSuccess {
                
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    
                  //  let status =   dictionary["status"] as? String
                    let error =  dictionary["error_type"] as? String
                    let statusCode =   dictionary["status_code"] as? Int ?? 0
                    print(statusCode)
                    if statusCode ==  400 {
                       
                        
                        if error == "SESSION_EXPIRED" ||  error == "USER_NOT_FOUND" ||  error == "ACCOUNT_DISABLED" || error == "ACCOUNT_INACTIVE"  {
                           
                            self.showSessionFailAlert(msg: "Your session is expired , please login again".localize)
                            return
                        }
                    }
                    
                    success(dictionary as! Dictionary<String, Any>)
                    
                }catch{
                    
                }
            }
            if responseObject.result.isFailure {
                self.StopIndicator()
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    
    
    
    // MARK: - Request Delete  method ----
    
    public func requestDELETE(strURL:String, Queryparams : [String:Any]?, body : [String:Any]?,strCustomValidation:String, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        if !NetworkReachabilityManager()!.isReachable{
            DispatchQueue.main.async {
            }
            return
        }

        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        var strUdidi =  ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let selectedlanguage =  String(UserDefaults.standard.string(forKey: "Selectdlanguage") ?? "")

///        let selectedLanguage  = LocalizationSystem.sharedInstance.getLanguage()
            //WsHeader.CurrentLanguage:selectedLanguage
        
        let headers: HTTPHeaders = [
            "Authorization": strAuthToken ,
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.timeZone: currentTimeZone,
            WsHeader.CurrentLanguage:selectedlanguage

        ]
        
        var StrCompleteUrl = ""
        
        if strCustomValidation ==  WsParamsType.PathVariable
        {
            let pathvariable = Queryparams?.PathString
            StrCompleteUrl  = "\(strURL)"   + (pathvariable ?? "")
            print("pathvariablepathvariable.....\(pathvariable ?? "")")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams
        {
            StrCompleteUrl = self.queryString(strURL, params: Queryparams ?? [:]) ?? ""
        }
        else
        {
            StrCompleteUrl = strURL
        }
        
        print("url.....\(StrCompleteUrl)")
        Alamofire.request(StrCompleteUrl, method: .delete, parameters: body, encoding: URLEncoding.httpBody, headers: headers).responseJSON { responseObject in
            
            if responseObject.result.isSuccess {
                
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    
                  //  let status =   dictionary["status"] as? String
                    let error =  dictionary["error_type"] as? String
                    let statusCode =   dictionary["status_code"] as? Int ?? 0
                    print(statusCode)
                    if statusCode ==  400 {
                       
                        
                        if error == "SESSION_EXPIRED" ||  error == "USER_NOT_FOUND" ||  error == "ACCOUNT_DISABLED" || error == "ACCOUNT_INACTIVE"  {
                           
                            self.showSessionFailAlert(msg: "Your session is expired , please login again".localize)
                            return
                        }
                    }
                    
                    success(dictionary as! Dictionary<String, Any>)
                    
                }catch{
                    
                }
            }
            if responseObject.result.isFailure {
                self.StopIndicator()
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    
    
    
    
    //MARK:- video upload with progress bar
    public func uploadMultipartDataVideoWithUploadingProgress(strURL:String, Queryparams : [String:Any]?, body : [String : AnyObject]?,strCustomValidation:String,showIndicator:Bool, imageData:Data?, fileName:String?, imageMimeType:String?, videoData:Data?,audioData:Data?, videoFileName:String, videoThumb:Data? , thumbParamName:String?,audioMimeType:String? ,videoMimeType:String,ProgressValue:((_ strProgressValue : Int) ->())? ,success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void){
        
        if !NetworkReachabilityManager()!.isReachable{
            DispatchQueue.main.async {
            }
            return
        }
        
        
//        strAuthToken = ""
//
//        strAuthToken = "Bearer" + " " + objAppShareData.UserDetail.strAuthtoken
        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kAuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        var strUdidi =  ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let headers: HTTPHeaders = [
            "Authorization": strAuthToken ,
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.timeZone: currentTimeZone
        ]
        
        var StrCompleteUrl = ""
        
        if strCustomValidation ==  WsParamsType.PathVariable
        {
            let pathvariable = Queryparams?.PathString
            StrCompleteUrl  = "\(strURL)"   + (pathvariable ?? "")
            print("pathvariablepathvariable.....\(pathvariable ?? "")")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams
        {
            StrCompleteUrl = self.queryString(strURL, params: Queryparams ?? [:]) ?? ""
        }
        else
        {
            StrCompleteUrl = strURL
        }
        
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            
            //if do not have image
            if let imgData = imageData{
                multipartFormData.append(imgData,
                                         withName:fileName ?? "",
                                         fileName: "file.jpeg",
                                         mimeType:imageMimeType ?? "")
            }
            
            //if do not have audio
            if let audioData = audioData{
                multipartFormData.append(audioData ,
                                         withName:fileName ?? "",
                                         fileName: "file.m4a",
                                         mimeType:audioMimeType ?? "")
            }
            
            //if do not have videoThumb
            if let thumbData = videoThumb{
                multipartFormData.append(thumbData,
                                         withName:thumbParamName!,
                                         fileName: "file.jpeg",
                                         mimeType:imageMimeType ?? "")
            }
            
            if let videoData = videoData{
                multipartFormData.append(videoData,
                                         withName:videoFileName,
                                         fileName: "file.mp4",
                                         mimeType:videoMimeType)
            }
            
            
            
            for (key, value) in body! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        },
                         // usingThreshold:UInt64.init(),
            to:StrCompleteUrl,
            method:.post,
            headers:headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { responseObject in
                        print(responseObject)
                        
                        if responseObject.error == nil {
                            print("Upload Status Success: ", responseObject)
                        }
                        else{
                            print("Upload Status Fail: ", responseObject)
                        }
                        
                        if responseObject.result.isSuccess {
                            
                            do {
                                let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                
                              //  let status =   dictionary["status"] as? String
                                let error =  dictionary["error_type"] as? String
                                let statusCode =   dictionary["status_code"] as? Int ?? 0
                                print(statusCode)
                                if statusCode ==  400 {
                                   
                                    
                                    if error == "SESSION_EXPIRED" ||  error == "USER_NOT_FOUND" ||  error == "ACCOUNT_DISABLED" || error == "ACCOUNT_INACTIVE"  {
                                       
                                        self.showSessionFailAlert(msg: "Your session is expired , please login again".localize)
                                        return
                                    }
                                }
                                
                                success(dictionary as! Dictionary<String, Any>)
                                
                                
                            }catch{
                                
                            }
                        }
                        
                        
                        if responseObject.result.isFailure {
                            self.StopIndicator()
                            let error : Error = responseObject.result.error!
                            failure(error)
                        }
                    }
                    
                    upload.uploadProgress(closure: { (progress) in
                        let value =  Int(progress.fractionCompleted * 100)
                        ProgressValue?(value)
                    })
                    
                    
                case .failure(let encodingError):
                    print(encodingError)
                    failure(encodingError)
                }
                
        })
        
    }
    
    
    
    
    func showSessionFailAlert(msg : String) {
            objWebServiceManager.StopIndicator()
            let alert = UIAlertController(title: kAlert.localize, message: msg , preferredStyle: .alert)
           
        let yesButton = UIAlertAction(title: "OK".localize, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                objAppShareData.resetDefaultsAlluserInfo()
                objAppDelegate.fromloginNavigation = true
                objAppDelegate.showLogInNavigation()
            })
            alert.addAction(yesButton)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    
    
    
    
    func getCurrentTimeZone() -> String{
        
        return TimeZone.current.identifier

    }
    
    // When session expired
    func setRootSessionExpired(){
        
        objAppShareData.callWsLogoutApi()

        
    }
    
    func StartIndicator(){
  
        var load : MBProgressHUD = MBProgressHUD()
        load = MBProgressHUD.showAdded(to: (objAppDelegate.window?.rootViewController?.view)!, animated: true)
        load.backgroundColor = .clear// #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3537356954)
        load.label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        load.mode = MBProgressHUDMode.indeterminate

        load.label.text = "Please wait...".localize

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
//        UIApplication.shared.beginIgnoringInteractionEvents()
//        SVProgressHUD.show()
        
    }
    
    func StopIndicator(){
        
        MBProgressHUD.hide(for: (objAppDelegate.window?.rootViewController?.view)!, animated: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
//        UIApplication.shared.endIgnoringInteractionEvents()
//        SVProgressHUD.dismiss()
    }
    
    
    func queryString(_ value: String, params: [String: Any]) -> String? {
        var components = URLComponents(string: value)
        components?.queryItems = params.map { element in URLQueryItem(name: element.key, value: element.value as? String ) }
        
        return components?.url?.absoluteString
    }
    func isNetworkAvailable() -> Bool{
        if !NetworkReachabilityManager()!.isReachable{
            return false
        }else{
            return true
        }
    }

    
    // method foer json
    public func requestWithJson(strURL:String, params : [String : AnyObject]?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        if !NetworkReachabilityManager()!.isReachable{
            DispatchQueue.main.async {
            }
            return
        }
        if UserDefaults.standard.string(forKey:kAuthToken)==nil {
            strAuthToken=""
        }else{
            strAuthToken=UserDefaults.standard.string(forKey:kAuthToken)!
        }
        
        //  let headers = ["authToken" : strAuthToken]
        //                      "Content-Type":"Application/json"]
        Alamofire.request(strURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { responseObject in
            
            self.StopIndicator()
            
            if responseObject.result.isSuccess {
                //                let resJson = JSON(responseObject.result.value!)
                //                success(resJson)
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    success(dictionary as! Dictionary<String, Any>)
                    print(dictionary)
                }catch{
                    
                    let error : Error = responseObject.result.error!
                    failure(error)
                    let str = String(decoding:  responseObject.data!, as: UTF8.self)
                    print("PHP ERROR : \(str)")
                }
            }
            if responseObject.result.isFailure {
                self.StopIndicator()
                let error : Error = responseObject.result.error!
                failure(error)
                
                let str = String(decoding:  responseObject.data!, as: UTF8.self)
                print("PHP ERROR : \(str)")
            }
        }
    }
    
    public func requestPostForArray(strURL:String, params : [String:Any]?, success:@escaping(NSArray) ->Void, failure:@escaping (Error) ->Void ) {
        if !NetworkReachabilityManager()!.isReachable{
            DispatchQueue.main.async {
            }
            return
        }
        
        if UserDefaults.standard.string(forKey:kAuthToken)==nil {
            strAuthToken=""
        }else{
            strAuthToken=UserDefaults.standard.string(forKey:kAuthToken)!
        }
        // let url = BaseURL + strURL
        let headers = ["authToken" : strAuthToken]
        
        Alamofire.request(strURL, method: .post, parameters: params, headers: headers).responseJSON { responseObject in
            self.StopIndicator()
            if responseObject.result.isSuccess {
                
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                    success(dictionary )
                    print(dictionary)
                }catch{
                    
                }
            }
            if responseObject.result.isFailure {
                self.StopIndicator()
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
}
extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        return output
    }
    
    var PathString: String {
        var output: String = ""
        for (_,value) in self {
            output +=   "\(value)"
        }
        output = String(output)
        return output
    }
    
}


//MARK:-  stripe payment method
extension WebServiceManager{
    public func requestAddCardOnStripe(strURL:String, params :[String : Any]?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        
        
        let url = strURL
        print("url = \(url)")
        
        let headers = ["Authorization" :  stripeKey,"Content-Type":"application/x-www-form-urlencoded"]
        
        
        Alamofire.request(url, method: .post, parameters: params, headers: headers).responseJSON { responseObject in
            
            print(responseObject)
            if responseObject.result.isSuccess {
                do {
                    SVProgressHUD.show(withStatus: "Please wait..")
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    success(dictionary as! Dictionary<String, Any>)
                    // print(dictionary)
                    SVProgressHUD.dismiss()
                }catch{
                    SVProgressHUD.dismiss()
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
            if responseObject.result.isFailure {
                SVProgressHUD.dismiss()
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    // Delete card
    public func requestDeleteCardFromStripe(strURL:String, params :[String : Any]?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        
        
        let url = strURL
        print("url = \(url)")
        
        let headers = ["Authorization" :  stripeKey,"Content-Type":"application/x-www-form-urlencoded"]
        
        Alamofire.request(url, method: .delete, parameters: params, headers: headers).responseJSON { responseObject in
            
            print(responseObject)
            if responseObject.result.isSuccess {
                do {
                    SVProgressHUD.show(withStatus: "Please wait..")
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    success(dictionary as! Dictionary<String, Any>)
                    // print(dictionary)
                    SVProgressHUD.dismiss()
                }catch{
                    SVProgressHUD.dismiss()
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
            if responseObject.result.isFailure {
                SVProgressHUD.dismiss()
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    // Get all card List
    public func requestGetCardsFromStripe(strURL:String, params :[String : Any]?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        
        
        let url = strURL
        print("url = \(url)")
        
        let headers = ["Authorization" : stripeKey,"Content-Type":"application/x-www-form-urlencoded"]
        
        Alamofire.request(url, method: .get, parameters: params, headers: headers).responseJSON { responseObject in
            
            // print(responseObject)
            if responseObject.result.isSuccess {
                do {
                    SVProgressHUD.show(withStatus: "Please wait..")
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    success(dictionary as! Dictionary<String, Any>)
                    // print(dictionary)
                    SVProgressHUD.dismiss()
                }catch{
                    SVProgressHUD.dismiss()
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
            if responseObject.result.isFailure {
                SVProgressHUD.dismiss()
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
}
