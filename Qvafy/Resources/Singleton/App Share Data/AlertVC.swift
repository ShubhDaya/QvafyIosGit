//
//  AlertVc.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 27/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//
//


import UIKit
//import Toast_Swift

var objAlert:AlertVC = AlertVC()

class AlertVC: UIViewController {
    
    //var style = ToastStyle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAlert(message: String, title: String = "", controller: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Customization alert view  below comment code- for border color ,styles
        
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.layer.cornerRadius = 10
        alertContentView.alpha = 1
        //        alertContentView.layer.borderWidth = 1
        //        alertContentView.layer.borderColor = UIColor.red.cgColor
        //        alertController.view.tintColor = UIColor.red
        let OKAction = UIAlertAction(title: "OK".localize, style: .default, handler: nil)
        alertController.addAction(OKAction)
        controller.present(alertController, animated: true, completion: nil)
        view.endEditing(true)
    }
    // Alert call back function
    func showAlertCallOneBtnAction( btnHandler:String,  title: String, message: String ,controller: UIViewController, callback: @escaping () -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

         alert.addAction(UIAlertAction(title: btnHandler, style: .default, handler: {
           alertAction in
            callback()
         }))
        
         controller.present(alert, animated: true, completion: nil)
       }
    // Alert call back function
    func showAlertCallBack(alertLeftBtn:String, alertRightBtn:String,  title: String, message: String ,controller: UIViewController, callback: @escaping () -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title:alertLeftBtn, style: .default, handler: {
            alertAction in
            
        }))
        
        alert.addAction(UIAlertAction(title: alertRightBtn, style: .default, handler: {
            alertAction in
            callback()
        }))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    
    // For alert show on UIWindow if you have no Viewcontroller then show this alert.
    func showAlertVc(message: String = "", title: String , controller: UIWindow) {
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let subView = alertController.view.subviews.first!
            let alertContentView = subView.subviews.first!
            alertContentView.backgroundColor = UIColor.gray
            alertContentView.layer.cornerRadius = 20
            
            let OKAction = UIAlertAction(title: "OK".localize, style: .default, handler: nil)
            alertController.addAction(OKAction)
            
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        })
    }

    
    func showAlert(message: String = "", title: String , controller: UIWindow) {
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let subView = alertController.view.subviews.first!
            let alertContentView = subView.subviews.first!
            alertContentView.backgroundColor = UIColor.gray
            alertContentView.layer.cornerRadius = 20
            let OKAction = UIAlertAction(title: "OK".localize, style: .default, handler: nil)
            alertController.addAction(OKAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        })
    }
    
}





