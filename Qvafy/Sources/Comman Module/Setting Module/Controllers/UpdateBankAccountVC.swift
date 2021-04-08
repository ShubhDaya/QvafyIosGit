//
//  UpdateBankAccountVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 29/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//


import UIKit

class UpdateBankAccountVC: UIViewController , UINavigationControllerDelegate , UITextFieldDelegate, UIGestureRecognizerDelegate{
    //MARK: - Outlets
    
    @IBOutlet weak var vwBlur: UIView!
    @IBOutlet weak var btnAddAccount: UIButton!
    @IBOutlet weak var btnVerifyAccount: UIButton!
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtAccountHolderName: UITextField!
    @IBOutlet weak var txtAccountNo: UITextField!
    @IBOutlet weak var txtRoutingNo: UITextField!
    @IBOutlet weak var vwBankName: UIView!
    @IBOutlet weak var vwAccountHolderName: UIView!
    @IBOutlet weak var vwAccountNo: UIView!
    @IBOutlet weak var vwRoutingNo: UIView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var viewAddAccount: UIView!
    @IBOutlet weak var viewImgAddAccount: UIView!
    @IBOutlet weak var viewVerifyAccount: UIView!
    @IBOutlet weak var viewImgVerifyAccount: UIView!
    @IBOutlet weak var lblAccountVerifyed: UILabel!
    @IBOutlet weak var btnProceed: UIButton!
    @IBOutlet weak var vwProceed: UIView!
    @IBOutlet weak var btnNotnow: UIButton!
    @IBOutlet weak var vwNotnow: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var vwHeader: UIView!
    
    //Localisation  outlets -
    
    @IBOutlet weak var lblLOBankName: UILabel!
    @IBOutlet weak var lblLOAccountHolderName: UILabel!
    @IBOutlet weak var lblLOAccountNUmber: UILabel!
    @IBOutlet weak var lblLORoutingNumber: UILabel!
    @IBOutlet weak var lblLOKycDesc: UILabel!
    @IBOutlet weak var lblLOCmolpetKycHeader: UILabel!
    
    //MARK: - Variables
    
    var strDriverType:String = ""
    var strVehicleTypeId: String = ""
    var strMakeId: String = ""
    var strMakeSelection = ""
    var strTypeSelection = ""
    var isFromLogin:Bool = false
    var strIsVerifyed:Int = 0
    var strAccountNo = ""
    var strHeaderText: String = ""
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
//        ////// new case
        self.viewVerifyAccount.isHidden = false
        self.lblAccountVerifyed.isHidden = true

        ////// new case
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localization()
        self.vwBlur.isHidden = true
        self.callWsForVerifyConnectedAccount()
    }
    
    //MARK: - Functions
    func setUI(){
        self.vwHeader.setviewbottomShadow()

        self.vwBankName.setCornerRadiusQwafy(vw: self.vwBankName)
        self.vwAccountHolderName.setCornerRadiusQwafy(vw: self.vwAccountHolderName)
        self.vwAccountNo.setCornerRadiusQwafy(vw: self.vwAccountNo)
        self.vwRoutingNo.setCornerRadiusQwafy(vw: self.vwRoutingNo)
        self.btnProceed.layer.cornerRadius = 17.5
        self.btnNotnow.layer.cornerRadius = 17.5
        self.viewAddAccount.setButtonView(vwOuter : self.viewAddAccount , vwImage : self.viewImgAddAccount, btn: self.btnAddAccount )
        self.viewVerifyAccount.setButtonView(vwOuter : self.viewVerifyAccount , vwImage : self.viewImgVerifyAccount, btn: self.btnVerifyAccount )
        self.vwBottom.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
        

       // self.vwBlur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        
    }
    
    func setData(){
        
        print(" strIsUserCuba is \(objAppShareData.UserDetail.strIsUserCuba)")
        print(" strCubaBankId is \(objAppShareData.UserDetail.strCubaBankId)")
        print(" strCubaBankCard is \(objAppShareData.UserDetail.strCubaBankCard)")
        if self.txtAccountHolderName.text == ""{
            self.lblHeader.text = "Add_Bank_Account".localize
            self.btnAddAccount.setTitle("Add_Account".localize, for: .normal)

        } else {
            self.lblHeader.text = "Update_Bank_Account".localize
            self.btnAddAccount.setTitle("Update_Account".localize, for: .normal)

        }
        
    }
    
    func localization(){
        self.lblAccountVerifyed.text = "Verified Account".localize
        
        self.lblLOAccountHolderName.text = "Account_holder_name".localize
        self.lblLOAccountNUmber.text = "Account_Number".localize
        self.lblLOBankName.text = "Bank_Name".localize

        self.lblLORoutingNumber.text = "Routing_Number".localize
        self.lblLOCmolpetKycHeader.text = "Complete_Kyc".localize
        self.lblLOKycDesc.text = "We_would_not_be_able_to_do_any_trasacation_in_your_account_without_completing_account verification,However_you_may_complete_it_in_future_also._Would_you_like_you_complete_your_account_verification?".localize

        self.txtAccountNo.placeholder = "Enter_account_number".localize
        self.txtBankName.placeholder = "Enter_bank_name".localize
        self.txtRoutingNo.placeholder = "Enter_routing_number".localize
        self.txtAccountHolderName.placeholder = "Enter_account_holder_name".localize
          
        self.btnNotnow.setTitle("Not_Now".localize, for: .normal)
        self.btnProceed.setTitle("Proceed".localize, for: .normal)
        self.btnAddAccount.setTitle("Add_Account".localize, for: .normal)
        self.btnVerifyAccount.setTitle("Verify_account".localize, for: .normal)

    }
    
    //MARK: Create Dash Line
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtBankName{
                // self.txtBankName.resignFirstResponder()
                 self.txtAccountHolderName.becomeFirstResponder()
             }else if textField == self.txtAccountHolderName{
                // self.txtAccountHolderName.resignFirstResponder()
                 self.txtAccountNo.becomeFirstResponder()
             }else if textField == self.txtAccountNo{
                // self.txtAccountNo.resignFirstResponder()
                 self.txtRoutingNo.becomeFirstResponder()
             }else if textField == self.txtRoutingNo{
                 self.txtRoutingNo.resignFirstResponder()
             }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            return true
        }
        if textField == txtBankName{
            let maxLength = 50
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 51{
                //textField.resignFirstResponder()
            }
            return newString.length <= maxLength
        } else  if textField == txtAccountHolderName{
            let maxLength = 30
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 31{
                //textField.resignFirstResponder()
            }
            return newString.length <= maxLength
        }else  if textField == txtAccountNo{
            let maxLength = 16
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 17{
                //textField.resignFirstResponder()
            }
            return newString.length <= maxLength
        }
        
        else if textField == txtRoutingNo{
            let maxLength = 9
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 10{
                //textField.resignFirstResponder()
            }
            return newString.length <= maxLength
        }
        else{
            return true
        }
    }
    

  
    func validationForAddBank(){
        
        self.txtBankName.text = self.txtBankName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtAccountHolderName.text = self.txtAccountHolderName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtRoutingNo.text = self.txtRoutingNo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtAccountNo.text = self.txtAccountNo.text!.trimmingCharacters(in: .whitespacesAndNewlines)


        if self.txtBankName.text?.isEmpty == true{
            objAlert.showAlert(message: BlankBankAccount.localize, title: kAlert.localize, controller: self)
        }
//        else if self.txtBankName.text?.count ?? 0 < 3{
//            objAlert.showAlert(message: BankNameValidation, title: kAlert, controller: self)
//        }
        else  if self.txtAccountHolderName.text?.isEmpty == true{
            objAlert.showAlert(message: BlankAccountHolderName.localize, title: kAlert.localize, controller: self)
        }
//        else if self.txtAccountHolderName.text?.count ?? 0 < 3{
//            objAlert.showAlert(message: AccountHolderNameValidation, title: kAlert, controller: self)
//        }
        else if self.txtAccountNo.text?.isEmpty == true{
            objAlert.showAlert(message: BlankAccountNo.localize, title: kAlert.localize, controller: self)
        }
        else if self.txtRoutingNo.text?.isEmpty == true{
            objAlert.showAlert(message: BlankRoutingNo.localize, title: kAlert.localize, controller: self)
        }

        else{
           
            self.callWsForAddBankAccount()
        }
        
    }
    
    
    //MARK: - Button Actions
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
        // handling code
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddAccountAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.validationForAddBank()
        
    }
    
    @IBAction func btnVerifyAccountAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.vwBlur.isHidden = false
    }
    
    @IBAction func btnNotNowAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.vwBlur.isHidden = true
        
    }
    @IBAction func btnProceedAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.callWsForCreateAccountLink()
        

    }
    
    func NavigateToVerifyBankVC(str: String){
        
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let detailVC = sb.instantiateViewController(withIdentifier: "VerifyBankVC") as! VerifyBankVC
        detailVC.strURL = str
                self.navigationController?.pushViewController(detailVC, animated: true)
                
    }
  
}

extension UpdateBankAccountVC {
    // TODO: Webservice For VerifyConnectedAccount
    func callWsForVerifyConnectedAccount(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            //  objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        //objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        
        let stripeId = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.KStripeConnectAccountId) ?? ""
        
        print("stripeId is \(stripeId)")
        
        param = [
            WsParam.stripeConnectAccountId: stripeId
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.VerifyConnectedAccount  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
            print(response)
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                let dict  = response["data"] as? [String:Any]
                
                
                if let bankDetail = dict?["bank_detail"] as? [String:Any]{
                    
                    if let holderName = bankDetail["account_holder_name"]as? String{
                        self.txtAccountHolderName.text = holderName
                    }
                    if let accountNumber = bankDetail["account_number"]as? String{
                        self.txtAccountNo.text = accountNumber
                    }
                    if let bankName = bankDetail["bank_name"]as? String{
                        self.txtBankName.text = bankName
                    }
                    if let routingNumber = bankDetail["routing_number"]as? String{
                        self.txtRoutingNo.text = routingNumber
                    }
                    
                }
                let user_details  = dict!["user_detail"] as? [String:Any]
                objAppShareData.saveDataInDeviceLogin(dict: user_details!)
                
                
                if let userDetail = dict?["user_detail"] as? [String:Any]{
                    if let accountVerified = userDetail["stripe_connect_account_verified"]as? String{
                        
                        self.strIsVerifyed = Int(accountVerified)!
                                       }
                }

                print("self.strIsVerifyed is \(self.strIsVerifyed)")
                
                
                if self.strIsVerifyed == 1 {
                    self.lblAccountVerifyed.isHidden = false
                    self.viewVerifyAccount.isHidden = true

                }else{
                    self.viewVerifyAccount.isHidden = false
                    self.lblAccountVerifyed.isHidden = true
                }
                
                
                if self.strAccountNo != "" && self.strIsVerifyed == 1 {
                  //  self.NavigateToGuideVC()
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                    objAppShareData.fetchUserInfoFromAppshareData()
                }
                self.setData()
            }else
            {
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
        }, failure: { (error) in
            print(error)
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
    }
    
    // TODO: Webservice For Add Bank Account
    
    func callWsForAddBankAccount(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
              let stripeId = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.KStripeConnectAccountId)
        
        var param = [String:Any]()
        param = [
                   "stripe_connect_account_id": stripeId ?? "",
                   "bank_name": self.txtBankName.text ?? "" ,
                   "holder_name": self.txtAccountHolderName.text ?? "" ,
                   "routing_number": self.txtRoutingNo.text ?? "" ,
                   "account_number": self.txtAccountNo.text ?? ""
            ]
        
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.addBankAccount, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            
            
            if status == "success"{
                
                let dic  = response["data"] as? [String:Any]
                
                let user_details  = dic!["user_detail"] as? [String:Any]
                objAppShareData.saveDataInDeviceLogin(dict: user_details!)

                
                if let bank_details = dic?["bank_detail"] as? [String:Any]{

                    
                    let accountNumber = bank_details["account_number"] as? String ?? ""
                    UserDefaults.standard.setValue(bank_details["account_number"], forKey: UserDefaults.KeysDefault.kAccountNo)
                    self.strAccountNo = accountNumber
                    
                    }
                
                

                  
                if self.lblHeader.text == "Update Bank Account".localize || self.lblHeader.text == "Update Bank Account" {
                    
                    objAlert.showAlertCallOneBtnAction(btnHandler: "OK".localize, title: "Alert".localize, message: "Update_bank_detail_successfully".localize, controller: self ){
                        self.navigationController?.popViewController(animated: true)
                    }
                    
//                    objAlert.showAlert(message: "Update_bank_account_successfully".localize, title: kAlert.localize, controller: self)

                } else {
                    
                    objAlert.showAlertCallOneBtnAction(btnHandler: "OK".localize, title: "Alert".localize, message: "Add_bank_account_successfully".localize, controller: self ){
                        self.navigationController?.popViewController(animated: true)
                      
                    }
                    
                    
//                    objAlert.showAlert(message: "Add_bank_account_successfully".localize ,title: kAlert.localize, controller: self)

                }

                self.lblHeader.text = "Update_Bank_Account".localize
                self.btnAddAccount.setTitle("Update_Account".localize, for: .normal)
          
            }
            else
            {
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
    }
    
    //    // TODO: Webservice For Create Account link
    //
    func callWsForCreateAccountLink(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        
     //   let stripeId = objAppShareData.UserDetail.strStripeConnectAccountId
        let stripeId = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.KStripeConnectAccountId)

        param = [
            WsParam.stripeConnectAccountId: stripeId ?? ""
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.createAccountLink, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                                let dic  = response["data"] as? [String:Any]
                
               
                
                            if let dicLink = dic?["link_details"] as? [String:Any]{

                                
                                let strVerifyUrl = dicLink["url"] as? String ?? ""

                                self.NavigateToVerifyBankVC(str: strVerifyUrl)
                                }

            }
            else
            {
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
    }

    func updateAlert(msg : String){
           let alert = UIAlertController(title: kAlert.localize, message: msg , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"OK".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            self.navigationController?.popViewController(animated: true)
            
           }))
           self.present(alert, animated: true, completion: nil)
       }
    
}


