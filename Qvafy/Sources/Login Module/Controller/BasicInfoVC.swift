
//
//  BasicInfoVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 09/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class BasicInfoVC: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate, UIGestureRecognizerDelegate  , VehicleSheetVCDelegate {
    //MARK: - Outlets
    
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var viewNext: UIView!
    @IBOutlet weak var viewImgNext: UIView!
    @IBOutlet weak var vwProgress: UIView!
    @IBOutlet weak var vwRound: UIView!
    @IBOutlet weak var vwRegistration: UIView!
    @IBOutlet weak var vwImgRegistration: UIView!
    @IBOutlet weak var vwLicense: UIView!
    @IBOutlet weak var vwImgLicense: UIView!
    @IBOutlet weak var vwYear: UIView!
    @IBOutlet weak var vwModel: UIView!
    @IBOutlet weak var vwNumber: UIView!
    @IBOutlet weak var vwMake: UIView!
    @IBOutlet weak var vwType: UIView!
    @IBOutlet weak var vwBlur: UIView!
    @IBOutlet weak var vwTable: UIView!
    @IBOutlet weak var imgRegistration: UIImageView!
    @IBOutlet weak var imgLicense: UIImageView!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtModel: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var lblMake: UILabel!
    @IBOutlet weak var lblType: UILabel!
    
    @IBOutlet weak var lblMakePalceHolder: UILabel!
    @IBOutlet weak var lblTypePalceHolder: UILabel!
    
    
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    
    // bottom sheet
    @IBOutlet weak var lblTableHeader: UILabel!
    @IBOutlet weak var tblBottom: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var tblBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwTableBottomConstraint: NSLayoutConstraint!
    
    //localizaton outlets-
    
    @IBOutlet weak var lblYouAreINStep: UILabel!
    @IBOutlet weak var lblHeaderPLeaseFillAllINdo: UILabel!
    @IBOutlet weak var lblHeaderText: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblModelNumber: UILabel!
    @IBOutlet weak var lblVehicleNUmber: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblLOMake: UILabel!

    
    @IBOutlet weak var lblLIcence: UILabel!
    @IBOutlet weak var lblRegistration: UILabel!
    @IBOutlet weak var lblUpload: UILabel!
    @IBOutlet weak var lblUploadLicence: UILabel!
    
    
    //
    
    // deepak new
    //MARK: - Variables
    
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    
    var pickedImageRegistration:UIImage?
    var pickedImageLicense:UIImage?
    
    var strType: Int = 0
    var strDriverType:String = ""
    var strMake: Int = 0
    var arrMake:[VehicleModel] = []
    var arrType:[VehicleModel] = []
    var strVehicleTypeId: String = ""
    var strMakeId: String = ""
    var strMakeSelection = ""
    var strTypeSelection = ""
    var isFromLogin:Bool = false
        
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.imagePicker.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
        
        
        let defaults = UserDefaults.standard
        let role = (defaults.string(forKey:UserDefaults.KeysDefault.kRole))
        
        if role == "2"{
            self.strDriverType = "1"
        }
        
        
        self.callWsForUserVehicleRole()
     //   self.tblBottom.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localization()
        if self.isFromLogin == true {
            self.vwBack.isHidden = true
        }else{
             self.vwBack.isHidden = true
        }
    }
    
    //MARK: - Functions
    func setUI(){
        
        self.vwBlur.isHidden = true
        self.vwImgLicense.isHidden = true
        self.vwImgRegistration.isHidden = true
        
        self.vwYear.setCornerRadiusQwafy(vw: self.vwYear)
        self.vwMake.setCornerRadiusQwafy(vw: self.vwMake)
        self.vwModel.setCornerRadiusQwafy(vw: self.vwModel)
        self.vwType.setCornerRadiusQwafy(vw: self.vwType)
        self.vwNumber.setCornerRadiusQwafy(vw: self.vwNumber)

       // self.vwNumber.setCornerRadBoarder(color: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) , cornerRadious: 20)
        self.vwImgRegistration.setCornerRadius(radius: 14)
        self.vwImgLicense.setCornerRadius(radius: 14)
        self.viewNext.setButtonView(vwOuter : self.viewNext , vwImage : self.viewImgNext, btn: self.btnNext )
        
        self.vwProgress?.layer.cornerRadius = (vwProgress?.frame.size.height)!/2.0
        self.vwProgress?.layer.masksToBounds = true
        
        
        self.vwTable.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
    
        self.vwBlur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))

        
    }
      
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        self.vwBlur.isHidden = true
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtYear{
          //  self.txtYear.resignFirstResponder()
            self.txtModel.becomeFirstResponder()
        }else if textField == self.txtModel{
          //  self.txtModel.resignFirstResponder()
            self.txtNumber.becomeFirstResponder()
        }else if textField == self.txtNumber{
            self.txtNumber.resignFirstResponder()
        }
        return true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == self.txtYear{
            
            
            return checkAccountNumberFormat(string: string, str: str)
        }
        else  if textField == txtModel{
            let maxLength = 30
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 31{
                //textField.resignFirstResponder()
            }
            return newString.length <= maxLength
        }
        else  if textField == txtNumber{
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 21{
                //textField.resignFirstResponder()
            }
            return newString.length <= maxLength
        }else{
            return true
        }
    }
    

    
    
    
    
    func checkAccountNumberFormat(string: String?, str: String?) -> Bool{
        var isbool: Bool = false
        if string == ""{

            isbool = true
        }
        else if str!.count > 4  {
           
            isbool = false
        }else{
            isbool = true
        }
        return isbool
    }
    
    func validationForBasicInfo(){
        
        self.txtYear.text = self.txtYear.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtModel.text = self.txtModel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtNumber.text = self.txtNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let strYear = self.txtYear.text?.count ?? 0
        
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let enteredYear = Int(txtYear.text ?? "") ?? 0
        
     //   let strModel = self.txtModel.text?.count ?? 0
     //   let strNumber = self.txtNumber.text?.count ?? 0
        
        if self.txtYear.text?.isEmpty == true{
            objAlert.showAlert(message: BlankYear.localize, title: kAlert.localize, controller: self)
        }
        
        else if strYear < 4{
            objAlert.showAlert(message: YearValidation.localize, title: kAlert.localize, controller: self)
        }

        else if self.txtModel.text?.isEmpty == true{
            objAlert.showAlert(message: BlankModel.localize, title: kAlert.localize, controller: self)
        }
        
  
        
        else if self.lblMake.text?.isEmpty == true{
            objAlert.showAlert(message: BlankMake.localize, title: kAlert.localize, controller: self)
        }else if self.lblType.text?.isEmpty == true{
            objAlert.showAlert(message: BlankVehicle.localize, title: kAlert.localize, controller: self)
        }else if self.txtNumber.text?.isEmpty == true{
            objAlert.showAlert(message: BlankNumber.localize, title: kAlert.localize, controller: self)
        }
//        else if strNumber < 5 {
//            objAlert.showAlert(message: NumberValidation, title: kAlert, controller: self)
//        }
        else if self.pickedImageRegistration == nil{
            objAlert.showAlert(message: BlankRegistration.localize, title: kAlert.localize, controller: self)
        }else if self.pickedImageLicense == nil{
            objAlert.showAlert(message: BlankLicense.localize, title: kAlert.localize, controller: self)
        }else if enteredYear > currentYear {
            objAlert.showAlert(message: "You can't enter future date", title: kAlert.localize, controller: self)

        }
        else{
            // objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
            self.callWsForVehicleDetails()
        }
        
    }
    
    
    //MARK: - Button Actions
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
        // handling code
        
    }
    
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.view.endEditing(true)
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        self.view.endEditing(true)
        self.validationForBasicInfo()
        
    }
    
    @IBAction func btnRegistration(_ sender: UIButton) {
        self.view.endEditing(true)
        print("btn Registration is click")
        self.strType = 0
        self.setImage()
    }
    
    @IBAction func btnLicense(_ sender: UIButton) {
        self.view.endEditing(true)
        print("btn License is click")
        self.strType = 1
        self.setImage()
    }
    @IBAction func btnDeleteRegistration(_ sender: UIButton) {
        self.view.endEditing(true)
        print("btn DeleteRegistration is click")
        
//        self.vwImgRegistration.isHidden = true
//        self.vwRegistration.isHidden = false
        
        self.strType = 0
        self.setImage()
    }
    
    @IBAction func btnDeleteLicense(_ sender: UIButton) {
        self.view.endEditing(true)
        print("btn DeleteLicense is click")
        
//        self.vwImgLicense.isHidden = true
//        self.vwLicense.isHidden = false
        
        self.strType = 1
        self.setImage()
    }
    
    @IBAction func btnMake(_ sender: Any) {
        self.view.endEditing(true)
//        self.vwBlur.isHidden = false
//        self.strMake = 0
//        self.lblTableHeader.text = "Select Make"
//        self.tblBottom.reloadData()
        
            self.strMake = 0

        self.showBotttomSheet(arr: self.arrMake,str: "Select_Make".localize , makeId : self.strMakeId, vehicleTypeId: "")

    }
    @IBAction func btnType(_ sender: Any) {
        self.view.endEditing(true)
        
        if  self.strMakeId == ""  {
            objAlert.showAlert(message: "Please_select_vehicle_make".localize, title: kAlert.localize, controller: self)
            
        }else{

            
                  self.strMake = 1

            self.showBotttomSheet(arr: self.arrType,str: "Please_select_vehicletype".localize, makeId: "" ,vehicleTypeId: self.strVehicleTypeId)

        }
    }
    
    func showBotttomSheet(arr : Array<Any>, str: String ,makeId: String , vehicleTypeId: String){
        
        let sb = UIStoryboard.init(name: "TaxiDProfile", bundle:Bundle.main)
              let vc = sb.instantiateViewController(withIdentifier:"VehicleSheetVC") as! VehicleSheetVC
        vc.arrBottom = arr as! [VehicleModel]
        vc.strHeader = str
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.strMakeId = makeId
        vc.strVehicleTypeId = vehicleTypeId
        // new deepak
         vc.closerCallApi = {
             isClearListData in
             if isClearListData{
                 self.callWsForUserVehicleRole()
             }
         }
         // new deepak
        self.present(vc, animated: false, completion: nil)
        
    }
    
        //MARK: step 6 finally use the method of the contract
    func sendDataFromVehicleSheetVC(strId: String, strName: String) {
                print(" my strId is \(strId)")
                print(" my strName is \(strName)")
            
        if  self.strMake == 0 {
            self.strMakeId = strId
            self.lblMake.text = strName
            self.strMakeSelection =  strName
            self.lblMakePalceHolder.isHidden = true
            
            self.lblTypePalceHolder.isHidden = false
            self.lblType.isHidden = true
            self.strVehicleTypeId = ""
            self.lblType.text = ""
            
        } else  if  self.strMake == 1 {
            self.lblTypePalceHolder.isHidden = true
            self.lblType.isHidden = false
            
        self.strVehicleTypeId = strId
        self.lblType.text = strName
        self.strTypeSelection = strName
        self.lblTypePalceHolder.isHidden = true

        }
            
                    
        }
    
    func sendObjFromVehicleSheetVC(obj: VehicleModel) {
        self.arrType.removeAll()
        print("obj is \(obj.strModel)")
        
        self.arrType = obj.arrVehicleType
        print("arrType count is \(self.arrType.count)")
    }
    
    
    @IBAction func btnCancle(_ sender: Any) {
        self.view.endEditing(true)
        self.vwBlur.isHidden = true
        
    }
    
    //MARK: - imagePicker Actions
    
    
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
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.modalPresentationStyle = .fullScreen
            imagePicker.allowsEditing = true
            self .present(imagePicker, animated: true, completion: nil)
        } else {
            self.openGallery()
            print("Camera is not open in Simulator")
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
            if self.strType == 0 {
      
                self.pickedImageRegistration = editedImage
                self.vwImgRegistration.isHidden = false
                self.vwRegistration.isHidden = true
                //  self.imgRegistration.image = self.pickedImage
                self.imgRegistration.image = self.pickedImageRegistration
                
            }else{
                self.pickedImageLicense = editedImage
                self.vwImgLicense.isHidden = false
                self.vwLicense.isHidden = true
                // self.imgLicense.image = self.pickedImage
                self.imgLicense.image = self.pickedImageLicense
            }
            
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}


extension BasicInfoVC {
    // TODO: Webservice For UserVehicleRole
    func callWsForUserVehicleRole(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            //  objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        //objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
 
        param = [
            WsParam.vehicleType: self.strDriverType
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.vehicleList  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
            print(response)
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                let dict  = response["data"] as? [String:Any]
                
                
                if let arrVehicleData = dict?["vehicle_list"] as? [[String:Any]]{
                    self.arrMake.removeAll()
                    self.arrType.removeAll()
                    //       if let arrVehicleData = dict["vehicle_list"] as! [[String: Any]]{
                    for dictVehicleData in arrVehicleData{
                        let objVehicleData = VehicleModel.init(dict: dictVehicleData)
                        self.arrMake.append(objVehicleData)
                    }
                    
//                    for obj in self.arrMake{
//                        // new deepak
//                        print("self.strMakeId is \(self.strMakeId)")
//                        print("str vehicle company is \(obj.strVehicleCompanyId)")
//                        if self.strMakeId == obj.strVehicleCompanyId {
//                            self.arrType.append(contentsOf: obj.arrVehicleType)
//
//                       }// new deepak
//                    }
                    print("arrMake count is \(self.arrMake.count)")
                    
                }
              ///  self.tblBottom.reloadData()
            }else
            {
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
        }, failure: { (error) in
            print(error)
            // objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
        
    }
    
    // TODO: Webservice For Vehicle Details
    
    func callWsForVehicleDetails(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param = [String:Any]()

       
        
//        let imageData1 = (self.pickedImageRegistration?.jpegData(compressionQuality: 1.0))!
//        let imageData2 = (self.pickedImageLicense?.jpegData(compressionQuality: 1.0))!
        
        var arrDataa = [Data]()
//        arrDataa.append(imageData1)
//        arrDataa.append(imageData2)
        
        var imageData1 : Data?
        var imageData2 : Data?
        
        if self.pickedImageRegistration != nil{
            imageData1 = objAppShareData.compressImage(image: self.pickedImageRegistration!) as Data?
            arrDataa.append(imageData1!)
        }
        if self.pickedImageLicense != nil{
            imageData2 = objAppShareData.compressImage(image: self.pickedImageLicense!) as Data?
            arrDataa.append(imageData2!)
        }
        
        
          var arrParam = [String]()
        
          arrParam.append(contentsOf: ["registration_image","license_image"])
          
        param = ["type_of_driver": self.strDriverType,
                 "year": self.txtYear.text ?? "",
                 "model_number":self.txtModel.text ?? "",
                 "vehicle_number": self.txtNumber.text ?? "",
                 "make":  self.strMakeId,
                 "vehicle_type": self.strVehicleTypeId
        ]
                
        print(param)
        
        
        objWebServiceManager.uploadMultipartMultipleImagesData(strURL: WsUrl.vehicleAdd, params: param, showIndicator: false, imageData: imageData1, imageToUpload: arrDataa, imagesParam: arrParam, fileName: "", mimeType: "image/jpeg", success: { response in
                    
            print(response)
            objWebServiceManager.StopIndicator()
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            if status == "success"
            {
                let dic  = response["data"] as? [String:Any]
                //  if let user_details = dic!["user_detail"] as? [String:Any]{
                let user_details  = dic!["user_detail"] as? [String:Any]
                
                objAppShareData.saveDataInDeviceLogin(dict: user_details!)

                self.NavigationToBankDetail()
                // }
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
    
    
    func NavigationToBankDetail(){
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "AddBankDetailVC") as! AddBankDetailVC
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func localization(){
        self.lblHeaderText.text = "There_are_many_variations_of_passages_of_Lorem_Ipsum_available".localize
        self.lblHeaderPLeaseFillAllINdo.text = "Please_fill_all_information".localize
        self.lblYouAreINStep.text = "You_are_in_step_3".localize
        self.lblModelNumber.text = "Model_Number".localize
        self.lblVehicleType.text = "Vehicle_Type".localize
        self.lblVehicleNUmber.text = "Vehicle_Number".localize
        self.lblYear.text = "Year".localize
        self.lblRegistration.text = "Registration".localize
        self.lblLIcence.text = "License".localize
        self.lblLOMake.text = "Make".localize
        self.lblMakePalceHolder.text = "Select_Make".localize
        self.lblTypePalceHolder.text = "Select_vehicle_type".localize

        self.lblUploadLicence.text = "Upload_License".localize
        self.lblUpload.text = "Upload_Id".localize
        self.txtYear.placeholder = "Enter_year".localize
        self.txtModel.placeholder = "Enter_model_number".localize
        self.txtNumber.placeholder = "Enter_vehicle_number".localize
        self.btnNext.setTitle("Next".localize, for: .normal)
  
    }

}

