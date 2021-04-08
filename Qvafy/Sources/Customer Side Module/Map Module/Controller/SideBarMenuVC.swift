//
//  SideBarMenuVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 23/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import SVProgressHUD
import SDWebImage
import HCSStarRatingView

//MARK: - Enum

enum LeftMenu: Int {
    case profile = 0
    case wishlist
    case orderlist
    case cartlist
    case chat
    case account
    case newOrder
    case myOrder
    case myProduct
    case addProduct
    case shop
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class SideBarMenuVC: UIViewController,LeftMenuProtocol {
    func changeViewController(_ menu: LeftMenu) {
        
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var vwDashedLine: UIView!
    @IBOutlet weak var vwLogout: UIView!
    @IBOutlet weak var vwImgLogout: UIView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var vwProfile: UIView!
    @IBOutlet weak var vwRating: HCSStarRatingView!
    @IBOutlet weak var lblChatCount: UILabel!
    
    // Localisation Outlets -
    
    @IBOutlet weak var lblLOPastOrder: UILabel!
    @IBOutlet weak var lblLOLogout: UILabel!
    @IBOutlet weak var lblLOSettings: UILabel!
    @IBOutlet weak var lblLOAccounts: UILabel!
    @IBOutlet weak var lblLOPastTrips: UILabel!
    @IBOutlet weak var lblLOMessages: UILabel!
    
    //MARK: - Variables
    var strTitle = ""
    var selectIndex = 0
    var isExpand = false
    var isInitial = false
    var ProfileViewController: UIViewController!
    var FilterHomeViewController: UIViewController!
    var homeViewController : UIViewController!
    
    var strStatusCode : Int!
    var strMessage : String = ""
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.vwLogout.setButtonView(vwOuter : self.vwLogout , vwImage : self.vwImgLogout, btn: self.btnLogout )

        self.creatDashedLine()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localisation()
        
        self.lblChatCount.layer.cornerRadius = self.lblChatCount.frame.height/2
        self.lblChatCount.clipsToBounds = true
         objAppShareData.showChatCountFromFirebase(lbl: self.lblChatCount)
        
        let profilePic = objAppShareData.UserDetail.strAvatar
        if profilePic != "" {
            let url = URL(string: profilePic)
            imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
        }else{
            imgProfile.image = UIImage.init(named: "inactive_profile_ico")
        }
        self.lblFullName.text = objAppShareData.UserDetail.strFullName.capitalizingFirstLetter()
        self.vwProfile.setProfileVerifyView(vwOuter: self.vwProfile, img: self.imgProfile)
        
    }
    
    func localisation(){

        self.lblLOPastOrder.text = "Past_Orders".localize
        self.lblLOLogout.text = "Logout".localize
        self.lblLOSettings.text = "Settings".localize
        self.lblLOAccounts.text = "Accounts".localize
        self.lblLOPastTrips.text = "Past_Trips".localize
        self.lblLOMessages.text = "Messages".localize

    }
    
    //MARK: Create Dash Line
       func creatDashedLine(){
           let topPoint = CGPoint(x: self.vwDashedLine.bounds.minX, y: self.vwDashedLine.bounds.maxY)
           let bottomPoint = CGPoint(x: self.vwDashedLine.bounds.maxX, y: self.vwDashedLine.bounds.maxY)
           self.vwDashedLine.createDashedLine(from: topPoint, to: bottomPoint, color: .lightGray, strokeLength: 8, gapLength: 4, width: 0.5)
       }
    
    
    //MARK: - Button Actions
    
    @IBAction func btnPastOrder(_ sender: Any) {
        self.view.endEditing(true)
        self.slideMenuController()?.closeLeft()
        
        let sb = UIStoryboard(name: "CustomerProfile", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "CustomerPastOrder") as! CustomerPastOrder
        self.navigationController?.pushViewController(detailVC, animated: true)

            }
    
    @IBAction func btnPastTrip(_ sender: Any) {
        self.view.endEditing(true)
        self.slideMenuController()?.closeLeft()
        
        let sb = UIStoryboard(name: "PastTrip", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "PastTripVC") as! PastTripVC
        detailVC.isFromCustomer = true
                self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @IBAction func btnMessage(_ sender: Any) {
        self.slideMenuController()?.closeLeft()
        let sb = UIStoryboard(name: "Chat", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "ChatHistoryVC") as! ChatHistoryVC
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @IBAction func btnAccount(_ sender: Any) {
        self.view.endEditing(true)
        self.slideMenuController()?.closeLeft()
//        let sb = UIStoryboard(name: "Map", bundle: nil)
//        let detailVC = sb.instantiateViewController(withIdentifier: "PaymentMethodVC") as! PaymentMethodVC
//        self.navigationController?.pushViewController(detailVC, animated: true)
        objAlert.showAlert(message: "Under Development", title: kAlert.localize, controller: self)
    }
    
    @IBAction func btnSettings(_ sender: Any) {
        self.view.endEditing(true)
        self.slideMenuController()?.closeLeft()
        let sb = UIStoryboard(name: "Setting", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        detailVC.strUserType = "1"
        self.navigationController?.pushViewController(detailVC, animated: true)
       //    objAlert.showAlert(message: "Under Development", title: kAlert.localize,, controller: self)
    }
    
    @IBAction func btnUserProfile(_ sender: Any) {
        objAppDelegate.showCustomerTabbar()
        selected_TabIndex = 4
   
    }
    
    @IBAction func btnLogOut(_ sender: Any) {
        self.view.endEditing(true)
        self.userLogout()

    }
   
       func userLogout(){
        let alert = UIAlertController(title:kAlert.localize,message: "Are_you_sure_you_want_to_logout?".localize, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No".localize, style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
               
               
                     if !objWebServiceManager.isNetworkAvailable(){
                         objWebServiceManager.StopIndicator()
                         objAlert.showAlert(message: NoNetwork , title: kAlert.localize,  controller: self)
                         return
                     }else{
                       objAppShareData.callWsLogoutApi()

               }
               
              }))
              self.present(alert, animated: true, completion: nil)
          }
    
}
