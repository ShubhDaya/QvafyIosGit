//
//  SignUpVC.swift
//  Qvafy
//
//  Created by IOS-Aradhana-cat on 03/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import PhoneNumberKit

class SignUpVC: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var imgPasswordHideShow: UIImageView!
    @IBOutlet weak var imgConfirmPasswordHideShow: UIImageView!
    @IBOutlet weak var viewFullName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewConfirmPassword: UIView!
    @IBOutlet weak var viewSignUp: UIView!
    @IBOutlet weak var viewImgSignUp: UIView!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var vwPhoneNumber: UIView!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblDialCode: UILabel!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    //Localization Outlets-
    
    @IBOutlet weak var lblheaderSignUp: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblConfirmPassword: UILabel!
    @IBOutlet weak var lblAreadyHaveAccount: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    
    //MARK: - Variables
    var countries = [[String: String]]()
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    var isFromLogin:Bool = false

    var strCountryName = ""
    var strCountryCode = ""
    var strCountryDialCode = ""
    let phoneNumberKit = PhoneNumberKit()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        self.setCornerRadius()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
        self.strCountryDialCode = "+1"
        self.strCountryCode = "US"
        
        self.getInfoFromRegion()
        self.jsonSerial()
        self.collectCountries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localization()

    }
    //MARK: - get country code and dial code From device region

    func getInfoFromRegion(){

    if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
    print("locale.regionCode countryCode is \(countryCode)")
    self.strCountryCode = countryCode
    let imagePath = "CountryPicker.bundle/\(countryCode).png"
    self.imgFlag.image = UIImage(named: imagePath)
    // self.collectCountries()
    }

    }
    func collectCountries() {
    for country in countries {


    if self.strCountryCode == country["code"] ?? "" {
    let dailcode = country["dial_code"] ?? ""
    self.lblDialCode.text = dailcode
        self.strCountryDialCode = dailcode

    print("dailcode is \(dailcode)")
    }
    }
    }

    func jsonSerial() {
    let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "countries", ofType: "json")!))
    do {
    let parsedObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
    countries = parsedObject as! [[String : String]]
    // print("country list \(countries)")
    }catch{
    print("not able to parse")
    }
    }
    
    //MARK: - Functions
    
    
    func setCornerRadius(){
        self.vwPhoneNumber.setCornerRadiusQwafy(vw: self.vwPhoneNumber)
        self.viewEmail.setCornerRadiusQwafy(vw: self.viewEmail)
        self.viewPassword.setCornerRadiusQwafy(vw: self.viewPassword)
        self.viewFullName.setCornerRadiusQwafy(vw: self.viewFullName)
        self.viewConfirmPassword.setCornerRadiusQwafy(vw: self.viewConfirmPassword)
        self.viewSignUp.setButtonView(vwOuter : self.viewSignUp , vwImage : self.viewImgSignUp, btn: self.btnSignUp )
        self.imgProfile.layer.cornerRadius = self.imgProfile.layer.frame.size.height / 2
        self.imgProfile.layer.masksToBounds = true
        self.imgProfile.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.imgProfile.layer.borderWidth = 1.5
    }
    
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
        
       // cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        // alert.view.tintColor = UIColor.black
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
    func openGallery()
    {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtFullName{
           // self.txtFullName.resignFirstResponder()
            self.txtEmail.becomeFirstResponder()
        }else if textField == self.txtEmail{
           // self.txtEmail.resignFirstResponder()
            self.txtPhoneNumber.becomeFirstResponder()
        }else if textField == self.txtPhoneNumber {
          //  self.txtPhoneNumber.resignFirstResponder()
            self.txtPassword.becomeFirstResponder()
        }else if textField == self.txtPassword{
          //  self.txtPassword.resignFirstResponder()
            self.txtConfirmPassword.becomeFirstResponder()
        }else if textField == self.txtConfirmPassword{
            self.txtConfirmPassword.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
     
        if textField == txtPassword{
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 21{
                //textField.resignFirstResponder()
            }
            return newString.length <= maxLength
        }
        else if textField == txtEmail{

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
        else if textField == txtConfirmPassword{
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 21{
                //textField.resignFirstResponder()
            }
            return newString.length <= maxLength
            
        }
       else{
            return true
        }
    }
    
    func validationForSignUp(){
        
        self.txtEmail.text = self.txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtPassword.text = self.txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtConfirmPassword.text = self.txtConfirmPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtFullName.text = self.txtFullName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtPhoneNumber.text = self.txtPhoneNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let isValidPassword = objValidationManager.ValidPassWord8digit(with: txtPassword.text ?? "")
        
        if self.txtFullName.text?.isEmpty == true{
            objAlert.showAlert(message: FullName.localize, title: kAlert.localize, controller: self)
        }
        else if self.txtFullName.text?.count ?? 0 < 2{
            objAlert.showAlert(message: FullNameValidation.localize, title: kAlert.localize, controller: self)
        }
            
        else if self.txtEmail.text?.isEmpty == true{
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
       }
        else if self.strCountryDialCode == "" {
            objAlert.showAlert(message: BlankDialCode.localize, title: kAlert.localize, controller: self)
        } else if  self.txtPhoneNumber.text?.isEmpty == true {
            objAlert.showAlert(message: BlankPhone.localize, title: kAlert.localize, controller: self)
        }else if !objValidationManager.isvalidPhoneNo(value: self.txtPhoneNumber.text ?? ""){
            objAlert.showAlert(message: InvalidPhone.localize, title: kAlert.localize, controller: self)
        }
        else if self.txtPassword.text?.isEmpty == true{
            objAlert.showAlert(message: BlankPassword.localize, title: kAlert.localize, controller: self)
        }

        else if !isValidPassword {
            objAlert.showAlert(message: validPassword8Digit.localize, title: kAlert.localize, controller: self)
        }else if self.txtConfirmPassword.text?.isEmpty == true{
            objAlert.showAlert(message: BlankConfirmPw.localize, title: kAlert.localize, controller: self)
        }
        else if(self.txtPassword.text != self.txtConfirmPassword.text){
            objAlert.showAlert(message: ConfirmPassInvalid.localize, title: kAlert.localize, controller: self)
        }
        else{
            
            do {
            print("Current number is \(self.txtPhoneNumber.text ?? "")")
                print(self.strCountryDialCode)
                print(self.lblDialCode.text ?? "")
                let phoneNumber = try phoneNumberKit.parse(strCountryDialCode + (self.txtPhoneNumber.text ?? ""))

                self.callWsForSignup()

//            let strMessage:String = NumberConfirm+"\n"+objAppShareData.strContryCode+" "+txtMobile.text!+"\n"+IsNumberCorrect
//            self.alertToConfirmMobile(title: kAlert, message: strMessage, controller: self)

            }catch {
            print("Error occured")
                
                objAlert.showAlert(message: InvalidPhone.localize, title: kAlert.localize, controller: self)
//            CustomAlertView.shared.showAlertViewWithMessage(NSLocalizedString(EnterNumber, tableName: nil, comment: ""))

            }
            
        }
    }
    
    
    //MARK: Localization Method -
    func localization(){
        self.lblEmail.text = "Email".localize
        self.lblName.text = "Full_Name".localize.capitalizingFirstLetter()
        self.lblPassword.text = "Password".localize
        self.lblConfirmPassword.text = "Confirm_Password".localize
        self.lblheaderSignUp.text = "Sign_Up".localize
        self.lblAreadyHaveAccount.text = "Already_have_an_account?".localize
        self.lblPhoneNumber.text = "Phone_Number".localize
        self.txtEmail.placeholder = "Enter_email".localize
        self.txtPassword.placeholder = "Enter_password".localize
        self.txtFullName.placeholder = "Enter_full_name".localize.capitalizingFirstLetter()
        self.txtConfirmPassword.placeholder = "Enter_confirm_password".localize
        self.txtPhoneNumber.placeholder = "Enter_phone_number".localize
        self.btnSignUp.setTitle("Sign_Up".localize, for: .normal)
        self.btnLogin.setTitle("Login".localize, for: .normal)
    }
    
    
    //MARK: - Button Actions
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
        // handling code
        
    }
    
    @IBAction func btnSetProfileImage(_ sender: UIButton) {
        self.view.endEditing(true)
        self.setImage()
    }
    
    @IBAction func btnPasswordHideShow(_ sender: UIButton) {
       // self.view.endEditing(true)
        if self.imgPasswordHideShow.image == #imageLiteral(resourceName: "show_view_ico"){
            self.imgPasswordHideShow.image = #imageLiteral(resourceName: "hide_view_ico")
            self.txtPassword.isSecureTextEntry = true
        }else{
            self.imgPasswordHideShow.image = #imageLiteral(resourceName: "show_view_ico")
            self.txtPassword.isSecureTextEntry = false
        }
    }
    
    @IBAction func btnConfirmPasswordHideShow(_ sender: UIButton) {
    //    self.view.endEditing(true)
        if self.imgConfirmPasswordHideShow.image == #imageLiteral(resourceName: "show_view_ico"){
            self.imgConfirmPasswordHideShow.image = #imageLiteral(resourceName: "hide_view_ico")
            self.txtConfirmPassword.isSecureTextEntry = true
        }else{
            self.imgConfirmPasswordHideShow.image = #imageLiteral(resourceName: "show_view_ico")
            self.txtConfirmPassword.isSecureTextEntry = false
        }
    }
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        self.view.endEditing(true)
        
        
        
        self.validationForSignUp()
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension SignUpVC {
    
    func callWsForSignup(){
        
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
        
        let currentTimeZone = objWebServiceManager.getCurrentTimeZone()
        
        var param: [String: Any] = [:]
        
        param = [
            WsParam.email: self.txtEmail.text ?? "",
            WsParam.fullname: self.txtFullName.text ?? "",
            WsParam.password: self.txtPassword.text ?? "",
            WsParam.confirmPassword: self.txtConfirmPassword.text ?? "",
            WsParam.signupfrom: "1",
            WsParam.deviceToken: deviceToken!,
            WsParam.profileTimezone: currentTimeZone ,
            WsParam.phoneNumber: self.txtPhoneNumber.text ?? "" ,
            WsParam.dialCode: self.lblDialCode.text ?? "",
            WsParam.countryCode: self.strCountryCode

            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.uploadMultipartData(strURL:  WsUrl.signUp, params: param , queryParams: [:], strCustomValidation: "", showIndicator: false, imageData: imageData, fileName: WsParam.profilePicture, mimeType: "image/jpeg", success: { response in
            
            print(response)
            objWebServiceManager.StopIndicator()
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            if status == "success"
            {
                let dic  = response["data"] as? [String:Any]
                
                let user_details  = dic!["user_detail"] as? [String:Any]
                objAppShareData.saveDataInDeviceLogin(dict: user_details!)
                
                self.NavigateToUserRole()
                
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
    
    
    func NavigateToUserRole(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "UserRoleVC") as! UserRoleVC
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension SignUpVC : RSCountrySelectedDelegate {
    
    func RScountrySelected(countrySelected country: CountryInfo) {
        
        let imagePath = "CountryPicker.bundle/\(country.country_code).png"
        self.imgFlag.image = UIImage(named: imagePath)
        strCountryDialCode = country.dial_code
        self.lblDialCode.text = country.dial_code
        strCountryCode = country.country_code
        
      //  print("country.country_code is \(country.country_code)")
        
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
