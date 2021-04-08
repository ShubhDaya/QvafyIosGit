//
//  CustomerEditProfileVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 14/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import PhoneNumberKit
import Foundation

class CustomerEditProfileVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    //MARK: - Outlets
    
    @IBOutlet weak var vwEdit: UIView!
    @IBOutlet weak var vwImgEdit: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var vwDotted: UIView!
    @IBOutlet weak var vwDotted1: UIView!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var vwPhoneNumber: UIView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblDialCode: UILabel!
    
    @IBOutlet weak var vwMale: UIView!
    @IBOutlet weak var vwFemale: UIView!
    @IBOutlet weak var imgMale: UIImageView!
    @IBOutlet weak var imgFemale: UIImageView!
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var lblFemale: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    // localisation outlets -
    
    @IBOutlet weak var lblLOHeaderEditProfile: UILabel!
    @IBOutlet weak var lblLOEmail: UILabel!
    
    @IBOutlet weak var lblLOPhoneNumber: UILabel!
    @IBOutlet weak var lblLOSelectGender: UILabel!
    
    
    
    //MARK: - Variables
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    let phoneNumberKit = PhoneNumberKit()
    
    
    var strCountryName = ""
    var strCountryCode = ""
    var strCountryDialCode = ""
    var strGender = ""
    
    
    var userDetail = userDetailModel(dict: [:])
    
    
    var imgCountryLogo = UIImage()
    var needToSessionExpired = Bool()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        
        self.loadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setUI()
        self.localisation()
        
        
    }
    
    func localisation(){
        
        self.lblLOHeaderEditProfile.text = "Edit_Profile".localize
        self.lblLOEmail.text = "Email".localize
        self.lblLOPhoneNumber.text = "Phone_Number".localize
        self.lblLOSelectGender.text = "Select_Gender".localize
        
        self.txtEmail.placeholder = "Enter_email".localize
        self.txtPhoneNumber.placeholder = "Enter_phone_number".localize
        
        self.btnEdit.setTitle("Update_Profile".localize, for: .normal)
        self.lblMale.text = "Male".localize
        self.lblFemale.text = "Female".localize
        
    }
    func setUI(){
        self.vwDotted.creatDashedLine(view: vwDotted)
        self.vwDotted1.creatDashedLine(view: vwDotted1)
        
        self.vwEmail.setCornerRadiusQwafy(vw: self.vwEmail)
        self.vwPhoneNumber.setCornerRadiusQwafy(vw: self.vwPhoneNumber)
        
        //self.vwProfile.setProfileVerifyView(vwOuter: self.vwProfile, img: self.imgProfile)
        self.vwEdit.setButtonView(vwOuter : self.vwEdit , vwImage : self.vwImgEdit, btn: self.btnEdit )
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.layer.frame.size.height / 2
        self.imgProfile.layer.masksToBounds = true
        //               self.imgProfile.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //               self.imgProfile.layer.borderWidth = 2.0
        
    }
    
    
    func loadData(){
        
        
        
        
        
        
        self.strCountryCode = userDetail.strCountryCode
        
        let imagestring = self.strCountryCode
        let imagePath = "CountryPicker.bundle/\(imagestring).png"
        self.imgFlag.image = UIImage.init(named: imagePath) ?? UIImage()
        
        //                                    self.imgCountryLogo = UIImage.init(named: imagePath) ?? UIImage()
        //                                  self.imgFlag.image = self.imgCountryLogo
        
        
        if self.userDetail.strDialCode == ""{
            self.lblDialCode.text = "+1"
            self.imgFlag.image = #imageLiteral(resourceName: "usa_flag_ico")
            self.strCountryDialCode = "+1"
            
        }else{
            self.lblDialCode.text = userDetail.strDialCode
            self.strCountryDialCode = userDetail.strDialCode
        }
        
        
        self.txtEmail.text = userDetail.strEmail
        self.txtPhoneNumber.text  = userDetail.strPhoneNumber
        
        
        let profilePic = userDetail.strAvatar
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
        }else{
            self.imgProfile.image = UIImage.init(named: "inactive_profile_ico")
        }
        
        self.strGender = userDetail.strGender
        self.checkGender(isMale : self.strGender )
    }
    
    //MARK: - Button Action
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSetProfileImage(_ sender: UIButton) {
        self.view.endEditing(true)
        self.setImage()
    }
    
    @IBAction func btnUpdateProfile(_ sender: Any) {
        self.view.endEditing(true)
        self.validationForUpdateProfile()
    }
    
    @IBAction func btnMale(_ sender: Any) {
        self.view.endEditing(true)
        self.checkGender(isMale :"1" )
        
    }
    @IBAction func btnFemale(_ sender: Any) {
        self.view.endEditing(true)
        self.checkGender(isMale :"2" )
    }
    
    func checkGender(isMale :String ){
        
        if isMale  == "1" {
            self.vwMale.setCornerRadBoarder(color: #colorLiteral(red: 0.9725490196, green: 0.7725490196, blue: 0.2156862745, alpha: 1), cornerRadious: 8)
            self.vwFemale.setCornerRadBoarder(color: #colorLiteral(red: 0.7176470588, green: 0.7176470588, blue: 0.7176470588, alpha: 1), cornerRadious: 8)
            self.lblMale.textColor = #colorLiteral(red: 0.9725490196, green: 0.7725490196, blue: 0.2156862745, alpha: 1)
            self.lblFemale.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
            self.strGender = "1"
            self.imgMale.image = #imageLiteral(resourceName: "active_male_ico")
            self.imgFemale.image = #imageLiteral(resourceName: "inactive_woman_ico")
            
            
        } else if isMale  == "2" {
            self.vwFemale.setCornerRadBoarder(color:  #colorLiteral(red: 0.9725490196, green: 0.7725490196, blue: 0.2156862745, alpha: 1) , cornerRadious: 8)
            self.vwMale.setCornerRadBoarder(color: #colorLiteral(red: 0.7176470588, green: 0.7176470588, blue: 0.7176470588, alpha: 1) , cornerRadious: 8)
            self.lblFemale.textColor = #colorLiteral(red: 0.9725490196, green: 0.7725490196, blue: 0.2156862745, alpha: 1)
            self.lblMale.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
            self.strGender = "2"
            self.imgFemale.image = #imageLiteral(resourceName: "active_woman_ico")
            self.imgMale.image = #imageLiteral(resourceName: "inactive_male_ico")
        }else{
            
            self.vwMale.setCornerRadBoarder(color: #colorLiteral(red: 0.7176470588, green: 0.7176470588, blue: 0.7176470588, alpha: 1) , cornerRadious: 8)
            self.vwFemale.setCornerRadBoarder(color: #colorLiteral(red: 0.7176470588, green: 0.7176470588, blue: 0.7176470588, alpha: 1) , cornerRadious: 8)
            self.lblMale.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
            self.lblFemale.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
            self.imgFemale.image = #imageLiteral(resourceName: "inactive_woman_ico")
            self.imgMale.image = #imageLiteral(resourceName: "inactive_male_ico")
        }
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail {
            // self.txtEmail.resignFirstResponder()
            self.txtPhoneNumber.becomeFirstResponder()
        }else if textField == self.txtPhoneNumber {
            self.txtPhoneNumber.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtEmail{
            
            let dotsCount = txtEmail.text!.components(separatedBy: ".").count - 1
            if dotsCount > 1 && (string == "." || string == ",") {
                return false
            }
            
            if string == "," {
                textField.text! += "."
                return false
            }
            
            return true
            
        }
        
        else{
            return true
        }
    }
    
    
    
    func validationForUpdateProfile(){
        
        self.txtEmail.text = self.txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtPhoneNumber.text = self.txtPhoneNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.txtEmail.text?.isEmpty == true{
            objAlert.showAlert(message: BlankEmail.localize, title: kAlert.localize, controller: self)
        }else if !objValidationManager.validateEmail(with: self.txtEmail.text ?? ""){
            objAlert.showAlert(message: ValidEmail.localize, title: kAlert.localize, controller: self)
        }else if  ((self.txtEmail.text?.contains(".@")) == true){
            print(self.txtEmail.text ?? "")
            objAlert.showAlert(message: ValidEmail.localize, title: kAlert.localize, controller: self)
        }else  if txtEmail.text?.prefix(1) == "." {
            print(self.txtEmail.text ?? "")
            objAlert.showAlert(message: ValidEmail.localize, title: kAlert.localize, controller: self)
        }else if  ((self.txtEmail.text?.contains("..")) == true){
            print(self.txtEmail.text ?? "")
            objAlert.showAlert(message: ValidEmail.localize, title: kAlert.localize, controller: self)
        } else if self.strCountryDialCode == "" {
            objAlert.showAlert(message: BlankDialCode.localize, title: kAlert.localize, controller: self)
        } else if  self.txtPhoneNumber.text?.isEmpty == true {
            objAlert.showAlert(message: BlankPhone.localize, title: kAlert.localize, controller: self)
        }else if !objValidationManager.isvalidPhoneNo(value: self.txtPhoneNumber.text ?? ""){
            objAlert.showAlert(message: InvalidPhone.localize, title: kAlert.localize, controller: self)
        }else if self.strGender == ""{
            objAlert.showAlert(message: Gender.localize, title: kAlert.localize, controller: self)
        }
        else{
            
            do {
                print("Current number is \(self.txtPhoneNumber.text ?? "")")
                print(self.strCountryDialCode)
                print(self.lblDialCode.text ?? "")
                let phoneNumber = try phoneNumberKit.parse(strCountryDialCode + (self.txtPhoneNumber.text ?? ""))
               self.callWsForUpdateCustomerProfile()
                
            }catch {
                print("Error occured")
                
                objAlert.showAlert(message: InvalidPhone.localize, title: kAlert.localize, controller: self)
            }
        }
    }
}

extension CustomerEditProfileVC {
    
    func setImage(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        let alert:UIAlertController=UIAlertController(title: "Choose_Image".localize, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera".localize, style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery".localize, style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localize, style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    // Open camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.modalPresentationStyle = .fullScreen
            imagePicker.allowsEditing = true
            self .present(imagePicker, animated: true, completion: nil)
        } else {
            self.openGallery()
        }
    }
    
    // Open gallery
    func openGallery(){
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.pickedImage = editedImage
            self.imgProfile.image = self.pickedImage
            imagePicker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.pickedImage = originalImage
            self.imgProfile.image = pickedImage
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
}
extension CustomerEditProfileVC : RSCountrySelectedDelegate {
    
    func RScountrySelected(countrySelected country: CountryInfo) {
        
        let imagePath = "CountryPicker.bundle/\(country.country_code).png"
        self.imgFlag.image = UIImage(named: imagePath)
        strCountryDialCode = country.dial_code
        self.lblDialCode.text = country.dial_code
        //      self.lblCode.text = self.lblCode.text!
        strCountryCode = country.country_code
        self.strCountryName = country.country_name
        //   self.txtPhoneNumber.becomeFirstResponder()
    }
    
    @IBAction func btnCountryPicker(_ sender: UIButton) {
        self.view.endEditing(true)
        //  self.txtPhoneNumber.resignFirstResponder()
        let sb = UIStoryboard.init(name: "CustomerProfile", bundle: Bundle.main).instantiateViewController(withIdentifier: "RSCountryPickerController")as! RSCountryPickerController
        sb.RScountryDelegate = self
        sb.strCheckCountry = self.strCountryName
        sb.modalPresentationStyle = .fullScreen
        self.navigationController?.present(sb, animated: true, completion: nil)
    }
}

extension CustomerEditProfileVC {
    // MARK:- API Calling
    
    func callWsForUpdateCustomerProfile(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        
        var imageData : Data?
        if self.pickedImage != nil{
            //  imageData = (self.pickedImage?.jpegData(compressionQuality: 1.0))!
            
            imageData = objAppShareData.compressImage(image: self.pickedImage!) as Data?
            
        }
        
        
        var param: [String: Any] = [:]
        
        
        param = [
            WsParam.email: self.txtEmail.text ?? "",
            WsParam.dialCode: self.lblDialCode.text ?? "",
            WsParam.phoneNumber: self.txtPhoneNumber.text ?? "" ,
            WsParam.gender: self.strGender ,
            WsParam.countryCode: self.strCountryCode
        ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.uploadMultipartData(strURL:  WsUrl.updateProfile, params: param , queryParams: [:], strCustomValidation: "", showIndicator: false, imageData: imageData, fileName: WsParam.profilePicture, mimeType: "image/jpeg", success: { response in
            
            print(response)
            objWebServiceManager.StopIndicator()
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            if status == "success"
            {
                self.updateAlert(msg: "Profile_updated_successfully".localize)
                // self.navigationController?.popViewController(animated: true)
                
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
        alert.addAction(UIAlertAction(title: "OK".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            self.navigationController?.popViewController(animated: true)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
