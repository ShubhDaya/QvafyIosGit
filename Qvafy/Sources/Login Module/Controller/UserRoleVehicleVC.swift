//
//  UserRoleVehicleVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 09/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class UserRoleVehicleVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var vwFrist: UIView!
    @IBOutlet weak var vwSecond: UIView!
    @IBOutlet weak var imgCheck1: UIImageView!
    @IBOutlet weak var imgCheck2: UIImageView!
    @IBOutlet weak var lblFrist: UILabel!
    @IBOutlet weak var lblSecond: UILabel!
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var lblDeliveryText: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var vwProgress: UIView!
    @IBOutlet weak var lblProgress: UILabel!

    @IBOutlet weak var viewNext: UIView!
    @IBOutlet weak var viewImgNext: UIView!
    
    
    // LOcalization outlets -
    
    @IBOutlet weak var lblIfYouAreInStep3: UILabel!
    @IBOutlet weak var lblWhichTypeOfVehicle: UILabel!
    @IBOutlet weak var lblHeaderText: UILabel!

    
    //MARK: - Variables
    var strUserType:Int = 0
    var isFromLogin:Bool = false

    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
         self.Localization()
         if self.isFromLogin == true {
             self.vwBack.isHidden = true
         }else{
             self.vwBack.isHidden = true
         }
     }
    //MARK: - Functions
    func setUI(){

        self.vwFrist.setViewRole(view: self.vwFrist)
        self.vwSecond.setViewRole(view: self.vwSecond)
        self.viewNext.setButtonView(vwOuter : self.viewNext , vwImage : self.viewImgNext, btn: self.btnNext )
        self.vwProgress?.layer.cornerRadius = (vwProgress?.frame.size.height)!/2.0
        self.vwProgress?.layer.masksToBounds = true
    }
    
    
    //MARK: - Button Actions
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.view.endEditing(true)
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFrist(_ sender: UIButton) {
        self.view.endEditing(true)
        self.imgCheck2.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        self.imgCheck1.image = #imageLiteral(resourceName: "active_check_box_ico")
        self.lblDeliveryText.text = "Delivery_under_2km.".localize
        self.strUserType = 2

    }
    
    @IBAction func btnSecond(_ sender: UIButton) {
        self.view.endEditing(true)
        self.imgCheck2.image = #imageLiteral(resourceName: "active_check_box_ico")
        self.imgCheck1.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        self.lblDeliveryText.text = "Delivery_under_10km.".localize
        self.strUserType = 3


    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if  self.imgCheck1.image != #imageLiteral(resourceName: "active_check_box_ico") && self.imgCheck2.image != #imageLiteral(resourceName: "active_check_box_ico") {
            objAlert.showAlert(message: "Please_select_vehicle".localize, title: kAlert.localize, controller: self)
        }else{
            self.Navigation()
        }
    }
    
    func Navigation(){
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = sb.instantiateViewController(withIdentifier: "BasicInfoVC") as! BasicInfoVC
        
        if self.strUserType == 2{
             detailVC.strDriverType = "2"
        }else if self.strUserType == 3{
             detailVC.strDriverType = "3"
        }
            self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK: Localization Method -
    func Localization(){
        self.lblHeaderText.text = "Contrary_to_popular_belief,_Lorem_ipsum_is_not_simply_random_text.".localize
        self.lblFrist.text = "Bike".localize
        self.lblSecond.text = "Motorcycle".localize
        self.lblWhichTypeOfVehicle.text = "Which_type_of_vehicle_you_have?".localize
        self.lblIfYouAreInStep3.text = "You_are_in_step_3".localize
        
        self.btnNext.setTitle("Next".localize, for: .normal)

     
    }
}

