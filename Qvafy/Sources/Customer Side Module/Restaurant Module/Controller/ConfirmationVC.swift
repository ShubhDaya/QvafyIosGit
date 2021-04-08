//
//  ConfirmationVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 11/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class ConfirmationVC: UIViewController {

     //MARK: Outlets
  
     @IBOutlet weak var vwHeader: UIView!
     @IBOutlet weak var btnTrack: UIButton!
     @IBOutlet weak var vwTrack: UIView!
     @IBOutlet weak var vwImgTrack: UIView!
    
    // Localization outlets -
    
    @IBOutlet weak var lblLOConfirmHeader: UILabel!
    @IBOutlet weak var lblLOThankYouOrder: UILabel!
    @IBOutlet weak var lblLOYouCanTrackDesc: UILabel!
    @IBOutlet weak var btnLOGotoHome: UIButton!
    
     //MARK: - Variables
    var strOrderId = ""
     
     //MARK: LifeCycle
     
     
     override func viewDidLoad() {
         super.viewDidLoad()
     }
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        self.localisation()
        self.vwHeader.setviewbottomShadow()
        self.vwTrack.setButtonView(vwOuter : self.vwTrack , vwImage : self.vwImgTrack, btn: self.btnTrack )
     }
     
     
    func localisation(){

        
        self.lblLOConfirmHeader.text = "Confirmation".localize
        self.lblLOThankYouOrder.text = "Thank_you_for_your_order.".localize
        self.lblLOYouCanTrackDesc.text = "You_can_track_your_order_in_My_orders_section".localize

        self.btnTrack.setTitle("Track_My_Order".localize, for: .normal)
        self.btnLOGotoHome.setTitle("Go_to_Home_Page".localize, for: .normal)


    }
    
     //MARK: - Button Action
     
     @IBAction func btnTrackOrder(_ sender: Any) {
         self.view.endEditing(true)
        
//        objAppDelegate.showCustomerTabbar()
//        selected_TabIndex = 2
        
        let sb = UIStoryboard(name: "Upcoming", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "UpcomingDetailVC") as! UpcomingDetailVC
        detailVC.strOrderId = self.strOrderId
        detailVC.isFromConfirmation = true
        self.navigationController?.pushViewController(detailVC, animated: true)

    }
    @IBAction func btnGoToHomePage(_ sender: Any) {
        self.view.endEditing(true)
        
        for vc in (self.navigationController?.viewControllers) ?? []{
            if vc is RestaurantListVC {
                self.navigationController?.popToViewController(vc, animated: false)
                break
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
