//
//  PastOrderRatingVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 28/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import HCSStarRatingView

class PastOrderRatingVC: UIViewController {
  
    @IBOutlet weak var vwBlurBottom: UIView!
    @IBOutlet weak var vwSubmit: UIView!
    @IBOutlet weak var vwImgSubmit: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
        
    @IBOutlet weak var vwCustomerProfile: UIView!
    @IBOutlet weak var imgCustomerProfile: UIImageView!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblCustomerRating: UILabel!
    
    @IBOutlet weak var vwRestaurantProfile: UIView!
    @IBOutlet weak var imgRestaurantProfile: UIImageView!
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblRestaurantRating: UILabel!
    
    
    @IBOutlet weak var vwRestaurantRating: HCSStarRatingView!
    @IBOutlet weak var vwCustomerRating: HCSStarRatingView!
    
    @IBOutlet weak var vwRestaurantTxt: UIView!
    @IBOutlet weak var txtRestaurantReview: UITextView!
    @IBOutlet weak var vwCustomerTxt: UIView!
    @IBOutlet weak var txtCustomerReview: UITextView!
    
    @IBOutlet weak var vwDotted1: UIView!
    //@IBOutlet weak var vwDotted2: UIView!
    
    @IBOutlet weak var vwStatus: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    
    //localisation outlets
    
    @IBOutlet weak var lblLOReviewsCustoemr: UILabel!
    
    @IBOutlet weak var lblLOReviewRestorentRatting: UILabel!
    
    
    //MARK: - Varibles
    
    //
    var strOrderId = ""
    var strRestaurantId = ""
    var strDriverId = ""
    var strRestaurantImage  = ""
    var strDriverImage = ""
    var strCurrentStatus = ""
    var strRestaurantName  = ""
    var strDriverName = ""
    var strRestaurantRating  = ""
    var strDriverRating = ""
   
    var strProfile = ""
    var strName = ""
    var isFromMap = false
    var placeholderLabel : UILabel!
    var placeholderFontSize: CGFloat = 12
    
    var placeholderLabel2 : UILabel!
    var placeholderFontSize2: CGFloat = 12
    
    var closerDeleteAlertList:((_ isClearList:Bool)   ->())?
    let txtViewMsgMaxHeight: CGFloat = 70
    let txtViewMsgMinHeight: CGFloat = 40
    //  var strRatingcount = ""
    var isFromForgroundNotification = false

    var strCustomerRatingCount = ""
    var strRestaurantRatingCount = ""
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.localisation()
        
        self.vwDotted1.creatDashedLine(view: vwDotted1)
       // self.vwDotted2.creatDashedLine(view: vwDotted2)

        self.vwBlurBottom.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
        self.vwSubmit.setButtonView(vwOuter : self.vwSubmit , vwImage : self.vwImgSubmit, btn: self.btnSubmit )
        
            // #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.vwCustomerTxt.setCornerRadBoarder(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cornerRadious: 12)
        self.vwRestaurantTxt.setCornerRadBoarder(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cornerRadious: 12)
        
        self.vwCustomerProfile.setProfileVerifyView(vwOuter: self.vwCustomerProfile, img: self.imgCustomerProfile)
        
        self.vwRestaurantProfile.setProfileVerifyView(vwOuter: self.vwRestaurantProfile, img: self.imgRestaurantProfile)
        
        if self.strDriverImage != "" {
                    let url = URL(string: self.strDriverImage)
                    self.imgCustomerProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                }else{
                    self.imgCustomerProfile.image = UIImage.init(named: "inactive_profile_ico")
                }
        
        if self.strRestaurantImage != "" {
                           let url = URL(string: self.strRestaurantImage)
                           self.imgRestaurantProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                       }else{
                           self.imgRestaurantProfile.image = UIImage.init(named: "inactive_profile_ico")
                       }
        
        
        self.lblCustomerName.text = self.strDriverName.capitalizingFirstLetter()
        self.lblRestaurantName.text = self.strRestaurantName.capitalizingFirstLetter()
        
        let string = NSString(string: self.strRestaurantRating)
        self.lblRestaurantRating.text = String(string.doubleValue)

        
        let string1 = NSString(string: self.strDriverRating)
        self.lblCustomerRating.text = String(string1.doubleValue)
        
                   if self.strCurrentStatus == "6"{
                    self.lblStatus.text = " \("Delivered".localize) "
                       self.lblStatus.textColor = #colorLiteral(red: 0, green: 0.5725490196, blue: 0.02745098039, alpha: 1)
                       self.vwStatus.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.9490196078, blue: 0.8784313725, alpha: 1)
                       
                   }else if self.strCurrentStatus == "7" {
                    self.lblStatus.text = " \("Cancelled".localize) "
                       self.lblStatus.textColor = #colorLiteral(red: 0.9647058824, green: 0.1647058824, blue: 0.1647058824, alpha: 1)
                       self.vwStatus.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
                   }
                   
        self.setCustomerPlaceHolderText()
        self.setRestaurantPlaceHolderText()
        self.txtCustomerReview.tintColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1) // deepak new works
        self.txtRestaurantReview.tintColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1) // deepak new works
  
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
        

    }
    
    @objc func refrershUI(){
        self.txtCustomerReview.resignFirstResponder()
        self.txtRestaurantReview.resignFirstResponder()

        self.isFromForgroundNotification = true
        
    }
    
    func localisation(){

        
        self.lblLOReviewsCustoemr.text = "Reviews".localize
        self.lblLOReviewRestorentRatting.text = "Reviews".localize

        self.btnSubmit.setTitle("Submit".localize, for: .normal)
        
    }
    
    @IBAction func btnCrossAction(_ sender: Any) {
        self.view.endEditing(true)
       // self.closerDeleteAlertList?(true)
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        self.view.endEditing(true)
        
        
        let CustomerRating = Double(self.vwCustomerRating.value)
        self.strCustomerRatingCount = String(CustomerRating)
        
        let RestaurantRating = Double(self.vwRestaurantRating.value)
        self.strRestaurantRatingCount = String(RestaurantRating)
        
        //   self.lblRating.text = "You rated \(self.strName) \(self.strRatingcount) stars"
        
        print("self.strCustomerRatingCount is \(self.strCustomerRatingCount)")
        print("self.strRestaurantRatingCount is \(self.strRestaurantRatingCount)")

//        print("self.strCustomerRatingCount text is \(self.txtCustomerReview.text)")
//        print("self.strRestaurantRatingCount  text is \(self.txtRestaurantReview.text)")

        
        
        if CustomerRating == 0 || RestaurantRating == 0 {
            objAlert.showAlert(message: "Please_rate_restaurant_and_driver_both.".localize, title: kAlert.localize, controller: self)
            
        } else{
              self.callWsForRatingReview()
        }
        
    }
    
    
}
//MARK:- TextViewDelegate
extension PastOrderRatingVC: UITextViewDelegate{
    
    
   
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
       
        
        if textView == self.txtCustomerReview {
            
            if(text == "\n") {
                txtCustomerReview.resignFirstResponder()
                return false
            }

        }else{
            if(text == "\n") {
                txtRestaurantReview.resignFirstResponder()
                return false
                
            }
        }
        
        return textView.text.count + (text.count - range.length) <= 250

       
//        if textView == txtCustomerReview{
//            let maxLength = 250
//            let currentString: NSString = textView.text! as NSString
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: txtCustomerReview.text) as NSString
//            if newString.length == 251{
//                //textField.resignFirstResponder()
//            }
//            return newString.length <= maxLength
//
//        }else if textView == txtRestaurantReview{
//            let maxLength = 250
//            let currentString: NSString = textView.text! as NSString
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: txtRestaurantReview.text) as NSString
//            if newString.length == 251{
//                //textField.resignFirstResponder()
//            }
//            return newString.length <= maxLength
//        }
//        else{
//            return true
//        }
       // return true
    }
    
    
    func textViewDidChange(_ textView: UITextView){
        
        if textView == self.txtCustomerReview {
            
            placeholderLabel.isHidden = !self.txtCustomerReview.text.isEmpty
            
            if txtCustomerReview.contentSize.height >= self.txtViewMsgMaxHeight
            {
                self.txtCustomerReview.isScrollEnabled = true
            }
            else
            {
                self.txtCustomerReview.frame.size.height = self.txtCustomerReview.contentSize.height
                self.txtCustomerReview.isScrollEnabled = false
            }
        }else if  textView == self.txtRestaurantReview{
            
            placeholderLabel2.isHidden = !self.txtRestaurantReview.text.isEmpty
            
            if txtRestaurantReview.contentSize.height >= self.txtViewMsgMaxHeight
            {
                self.txtRestaurantReview.isScrollEnabled = true
            }
            else
            {
                self.txtRestaurantReview.frame.size.height = self.txtRestaurantReview.contentSize.height
                self.txtRestaurantReview.isScrollEnabled = false
            }
            
            
            
        }
    }

    
    
}

extension PastOrderRatingVC {
//     TODO: Webservice For update location
        func callWsForRatingReview() {
    
            if !objWebServiceManager.isNetworkAvailable(){
                objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
                return
            }

            
            var param: [String: Any] = [:]
            param = [
                WsParam.orderID: self.strOrderId ,
                WsParam.driverId: self.strDriverId ,
                WsParam.restaurantId: self.strRestaurantId ,
                WsParam.driverRating: self.strCustomerRatingCount ,
                WsParam.restaurantRating: self.strRestaurantRatingCount,
                WsParam.driverReview: self.txtCustomerReview.text ?? "" ,
                WsParam.restaurantReview: self.txtRestaurantReview.text ?? "" ,
                ] as [String : Any]
    
            print(param)
    
            objWebServiceManager.requestPost(strURL: WsUrl.orderRating, params: param, strCustomValidation: "", showIndicator: false, success: {response in
                print(response)
                let status =   (response["status"] as? String)
                let message =  (response["message"] as? String)
                objWebServiceManager.StopIndicator()
                if status == "success"{
                    
                    objAlert.showAlertCallOneBtnAction(btnHandler: "OK".localize, title: kAlert.localize, message: message ?? "", controller: self) {
                        
                        self.closerDeleteAlertList?(true)
                        self.dismiss(animated: false, completion: nil)
                    }
                }
                else
                {
                    objAlert.showAlert(message:message ?? "" , title: kAlert.localize, controller: self)
                }
            }, failure: { (error) in
                print(error)
                objWebServiceManager.StopIndicator()
                objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            })
        }
}


extension PastOrderRatingVC {
    
    func setCustomerPlaceHolderText(){
        self.txtCustomerReview.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "\("Say_somthing_about".localize) \(self.strDriverName) \("service?".localize)"
        placeholderLabel.sizeToFit()
        placeholderLabel.textAlignment = .left
        self.txtCustomerReview.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.txtCustomerReview.font?.pointSize)! / 2)
        placeholderLabel.font = UIFont(name: "Poppins-Light", size: 10)
        placeholderLabel.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        placeholderLabel.isHidden = !self.txtCustomerReview.text.isEmpty
    }
    
    func setRestaurantPlaceHolderText(){
        self.txtRestaurantReview.delegate = self
        placeholderLabel2 = UILabel()
        
        print(self.strRestaurantName)
        placeholderLabel2.text = "\("Say_somthing_about".localize) \(self.strRestaurantName) \("service?".localize)"
        placeholderLabel2.sizeToFit()
        placeholderLabel2.textAlignment = .left

        self.txtRestaurantReview.addSubview(placeholderLabel2)
        placeholderLabel2.frame.origin = CGPoint(x: 5, y: (self.txtRestaurantReview.font?.pointSize)! / 2)
        placeholderLabel2.font = UIFont(name: "Poppins-Light", size: 10.0)
        placeholderLabel2.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        placeholderLabel2.isHidden = !self.txtRestaurantReview.text.isEmpty
    }
    
}


