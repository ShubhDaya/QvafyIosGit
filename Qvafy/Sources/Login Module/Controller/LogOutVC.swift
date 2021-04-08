//
//  LogOutVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 19/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

//import UIKit

//class LogOutVC: UIViewController {
//
//     @IBOutlet weak var vwBack: UIView!
//
//     var isFromLogin:Bool = false
//
//     override func viewDidLoad() {
//         super.viewDidLoad()
//
//         // Do any additional setup after loading the view.
//     }
//
//     @IBAction func btnLogout(_ sender: Any) {
//       self.view.endEditing(true)
//        self.userLogout()
//
//   }
//
//     func userLogout(){
//            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
//            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
//
//
//                   if !objWebServiceManager.isNetworkAvailable(){
//                       objWebServiceManager.StopIndicator()
//                       objAlert.showAlert(message: NoNetwork , title: kAlert , controller: self)
//                       return
//                   }else{
//                     objAppShareData.callWsLogoutApi()
//
//             }
//
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
//
//
//
//}
