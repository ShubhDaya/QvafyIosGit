//
//  RatingVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 10/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import HCSStarRatingView

class RatingVC: UIViewController {
    
    @IBOutlet weak var vwBlurBottom: UIView!
    @IBOutlet weak var vwRatingProfile: UIView!
    @IBOutlet weak var imgRatingProfile: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var vwSubmit: UIView!
    @IBOutlet weak var vwImgSubmit: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var vwRating: HCSStarRatingView!
    @IBOutlet weak var vwTxt: UIView!
    @IBOutlet weak var txtRating: UITextView!
    //localisation OUtlets -
    @IBOutlet weak var lblMax250char: UILabel!
    @IBOutlet weak var lblLOAwsome: UILabel!
    

    //MARK: - Varibles
    var strBookingId = ""
    var strUserId = ""
    var strRatingcount = ""
    var strProfile = ""
    var strName = ""
    var isFromMap = false
    var placeholderLabel : UILabel!
    var placeholderFontSize: CGFloat = 14
    var strRating = ""
    var strReview = ""
    var closerDeleteAlertList:((_ isClearList:Bool)   ->())?
    let txtViewMsgMaxHeight: CGFloat = 70
    let txtViewMsgMinHeight: CGFloat = 40
    var isFromForgroundNotification = false

    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.strRating == "" {
            self.lblRating.text = "\("You_rated".localize) \(self.strName) 0 \("star".localize)"
        }else{
            self.lblRating.text = "\("You_rated".localize) \(self.strName) \(self.strRating) \("stars".localize)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.txtRating.resignFirstResponder()
        self.vwBlurBottom.isHidden = false
        self.lblLOAwsome.text = "AWESOME!".localize
        self.btnSubmit.setTitle("Submit".localize, for: .normal)
        self.lblMax250char.text = "Max 250 characters.".localize

        self.setTextFieldPlaceHolderText()
        self.vwBlurBottom.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
        self.vwSubmit.setButtonView(vwOuter : self.vwSubmit , vwImage : self.vwImgSubmit, btn: self.btnSubmit )
        self.vwTxt.backgroundColor = #colorLiteral(red: 0.9688121676, green: 0.9688346982, blue: 0.9688225389, alpha: 1)

        self.vwTxt.setCornerRadBoarder(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cornerRadious: 12)
        //self.vwRatingProfile.setProfileVerifyView(vwOuter: self.vwRatingProfile, img: self.imgRatingProfile)
        self.vwRatingProfile.setUserProfileView(vwOuter: self.vwRatingProfile, img: self.imgRatingProfile , radius : 2)

      //  self.vwRatingProfile.setShadowWithCornerRadius()
        if strProfile != "" {
            let url = URL(string: strProfile)
            self.imgRatingProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
        }else{
            self.imgRatingProfile.image = UIImage.init(named: "inactive_profile_ico")
        }
        
        if self.strRating == "" {
            self.txtRating.textAlignment = .left
            self.vwRating.isUserInteractionEnabled = true
            self.vwTxt.isUserInteractionEnabled = true
            self.vwSubmit.isHidden = false
            self.placeholderLabel.isHidden = false
            self.vwTxt.setCornerRadBoarder(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cornerRadious: 12)
            self.vwTxt.backgroundColor = #colorLiteral(red: 0.9688121676, green: 0.9688346982, blue: 0.9688225389, alpha: 1)
            self.lblMax250char.isHidden = false
            self.txtRating.tintColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1) // deepak new works
        }else{
            self.txtRating.textAlignment = .center
            self.vwTxt.setCornerRadBoarder(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), cornerRadious: 12)
            self.vwTxt.backgroundColor = .clear
            self.lblMax250char.isHidden = true
            self.vwRating.isUserInteractionEnabled = false
            self.vwTxt.isUserInteractionEnabled = false
            //self.btnSubmit.isUserInteractionEnabled = false
            self.vwSubmit.isHidden = true
            self.placeholderLabel.isHidden = true
            //let rating = Double(self.vwRating.value)
            //self.strRatingcount = String(rating)
            let ratingData = Double(self.strRating)
            self.vwRating.value  = CGFloat(ratingData!)
            
            if self.strRating == "1" {
                self.lblRating.text = "\("You_rated".localize) \(self.strName) \(self.strRating) \("star".localize)"

            }else{
                self.lblRating.text = "\("You_rated".localize) \(self.strName) \(self.strRating) \("stars".localize)"
            }
            self.txtRating.text = self.strReview
            print(strReview)
            print(strRating)
            
            // new for hide review text when review is nill
            if strReview == ""{
                self.vwTxt.isHidden = true
            }else{
                self.vwTxt.isHidden = false
            }
            //
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
    }
    
    
    @objc func refrershUI(){
        print("objAppShareData.isFromBannerNotification is \(objAppShareData.isFromBannerNotification)")
        self.txtRating.resignFirstResponder()
        self.isFromForgroundNotification = true
        self.vwBlurBottom.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.isFromForgroundNotification = false
    }
    
    @IBAction func ratingValueChanged(_ sender: HCSStarRatingView) {
        self.view.endEditing(true)
        let strV = Double(sender.value)
        let strRate = Int(strV)

        if strRate == 1 {
            self.lblRating.text = "\("You_rated".localize) \(self.strName) \(strRate) \("star".localize)"
            
        }else{
            self.lblRating.text = "\("You_rated".localize) \(self.strName) \(strRate) \("stars".localize)"
        }
    }
    
    @IBAction func btnCrossAction(_ sender: Any) {
        self.view.endEditing(true)
        self.closerDeleteAlertList?(true)

        self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        self.view.endEditing(true)
        
        let rating = Double(self.vwRating.value)
        self.strRatingcount = String(rating)
        
        let strRate = Int(rating)
       
        
        self.lblRating.text = "\("You_rated".localize) \(self.strName) \(strRate) \("stars".localize)"

        if rating == 0 {
            objAlert.showAlert(message: "Please_select_at_least_one_rating.".localize, title: kAlert.localize, controller: self)
        }
        
        else{
            self.callWsForRatingReview()
        }
    }
}
//MARK:- TextViewDelegate
extension RatingVC: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            txtRating.resignFirstResponder()
            return false
        }
        
        return textView.text.count + (text.count - range.length) <= 250
    }
    
    func textViewDidChange(_ textView: UITextView){
  
        placeholderLabel.isHidden = !self.txtRating.text.isEmpty
        
        if txtRating.contentSize.height >= self.txtViewMsgMaxHeight
        {
            self.txtRating.isScrollEnabled = true
        }
        else
        {
            self.txtRating.frame.size.height = self.txtRating.contentSize.height
            self.txtRating.isScrollEnabled = false
        }
    }
    
    
    func addAccesorryToKeyBoard(){
        let keyboardDoneButtonView = UIToolbar()
        
        keyboardDoneButtonView.sizeToFit()
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title:"Done".localize , style:.plain, target: self, action: #selector(self.resignKeyBoard))
        keyboardDoneButtonView.items = [flexBarButton, doneButton]
        txtRating.inputAccessoryView = keyboardDoneButtonView
    }
    
    @objc func resignKeyBoard(){
        self.txtRating.resignFirstResponder()
    }
}

extension RatingVC {
    // TODO: Webservice For Rating Review
    func callWsForRatingReview() {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()


        var param: [String: Any] = [:]
        param = [
            WsParam.rating: self.strRatingcount ,
            WsParam.review: self.txtRating.text ?? "" ,
            WsParam.referenceId: self.strBookingId ,
            WsParam.ratingType: "1" ,
            WsParam.ratingFor: self.strUserId
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.ratingReview, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            objWebServiceManager.StopIndicator()

            if status == "success"{
                self.vwBlurBottom.isHidden = true
                self.updateAlert(msg: message ?? "")
            }
            else
            {
                self.vwBlurBottom.isHidden = true
                self.updateAlert(msg: message ?? "")
                // objAlert.showAlert(message:message ?? "" , title: kAlert.localize, controller: self)
            }
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
    }
    
    func updateAlert(msg : String){
       // self.dismiss(animated: false, completion: nil)
           let alert = UIAlertController(title: kAlert.localize, message: msg , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            self.closerDeleteAlertList?(true)
            self.dismiss(animated: false, completion: nil)

           
            
           }))
           self.present(alert, animated: true, completion: nil)
       }
    
}


extension RatingVC {
    
    func setTextFieldPlaceHolderText(){
          self.txtRating.delegate = self
          placeholderLabel = UILabel()
          placeholderLabel.text = "\("Say_somthing_about".localize) \(self.strName) \("service?".localize)"
          placeholderLabel.sizeToFit()
        placeholderLabel.textAlignment = .left
        

          // placeholderLabel.adjustsFontSizeToFitWidth = true
          //  placeholderLabel.minimumScaleFactor = 0.1
          self.txtRating.addSubview(placeholderLabel)
          placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.txtRating.font?.pointSize)! / 2)
        placeholderLabel.font = UIFont(name: "Poppins-Light", size: 10)
        
        
          placeholderLabel.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
          placeholderLabel.isHidden = !self.txtRating.text.isEmpty
      }
}
