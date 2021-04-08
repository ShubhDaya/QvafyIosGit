//
//  ForgotPasswordVC.swift
//  Qvafy
//
//  Created by IOS-Aradhana-cat on 02/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController , UITextFieldDelegate , UIGestureRecognizerDelegate{
    
    //MARK: - Outlets
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var vwBack: UIView!
    
    //Localization Outlets-
    
    @IBOutlet weak var lblHeaderForgotPassword: UILabel!
    @IBOutlet weak var lblHeaderText: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgSendImage: UIImageView!
    
    //MARK: - Variables
    
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgSendImage.image = UIImage(named: "send_btn_img".localize)
        self.lblHeaderText.text = "Please_enter_your_email_address,_You_Will_receive_alink_to_create_a_new_password_\nvia email.".localize
        self.viewEmail.setCornerRadiusQwafy(vw: self.viewEmail)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.localization()
    }
    
    //MARK: - Functions
    
    func validationForForgotPassword(){
        if self.txtEmail.text?.isEmpty == true{
            objAlert.showAlert(message: BlankEmail.localize, title: kAlert.localize, controller: self)
        }else if !objValidationManager.validateEmail(with: self.txtEmail.text ?? ""){
            objAlert.showAlert(message: ValidEmail.localize, title: kAlert.localize, controller: self)
        }else{
            self.callWsForForgotPassword()
        }
    }
    //Localization
    func localization(){
        //
        self.lblEmail.text = "Email".localize
        self.lblHeaderText.text = "Please_enter_your_email_address,_You_Will_receive_alink_to_create_a_new_password_\nvia email.".localize
        self.lblHeaderForgotPassword.text = "Forgot_password".localize
        self.txtEmail.placeholder = "Enter_email".localize
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail{
            self.txtEmail.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - Button Action
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
        // handling code
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSend(_ sender: UIButton) {
        self.validationForForgotPassword()
    }
}


extension ForgotPasswordVC {
    
    func callWsForForgotPassword(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        
        
        param = [
            WsParam.email: self.txtEmail.text ?? ""
            ] as [String : Any]
        
        print(param)
        
        
        objWebServiceManager.requestPut(strURL: WsUrl.resetPassword, Queryparams:[:], body:param,strCustomValidation: "", success: {response in
            
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                objAlert.showAlertCallOneBtnAction( btnHandler: "OK".localize, title: kAlertTitle.localize, message: message ?? "", controller: self) {
                    
                    self.navigationController?.popViewController(animated: true)
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
    
}

