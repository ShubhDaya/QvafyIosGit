
//
//  EditVehicleInfoVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 22/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class EditVehicleInfoVC: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate, UIGestureRecognizerDelegate , VehicleSheetVCDelegate {
   
    
    //MARK: - Outlets
    
  //  @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var vwUpdate: UIView!
    @IBOutlet weak var vwImgUpdate: UIView!
   // @IBOutlet weak var vwProgress: UIView!
   // @IBOutlet weak var vwRound: UIView!
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
    
    //localization outlets-
    
    @IBOutlet weak var lblLocEditProfileHeader: UILabel!
    @IBOutlet weak var lblLocPleaseFillAllInfo: UILabel!
    @IBOutlet weak var lblLocYear: UILabel!
    @IBOutlet weak var lblLocModel: UILabel!
    @IBOutlet weak var lblLocMake: UILabel!
    
    @IBOutlet weak var lblLocVehicleType: UILabel!
    @IBOutlet weak var lblVehicleNumber: UILabel!
    @IBOutlet weak var lblLocRegistration: UILabel!
    @IBOutlet weak var lblLocLicense: UILabel!
    @IBOutlet weak var lblLocUploadId: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lblLocUploadLicense: UILabel!
    
    
   // @IBOutlet weak var lblHeaderText: UILabel!
//@IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    
    
    // bottom sheet
    @IBOutlet weak var lblTableHeader: UILabel!
    @IBOutlet weak var tblBottom: UITableView!
 //   @IBOutlet weak var tblHeight: NSLayoutConstraint!
   // @IBOutlet weak var tblBottomConstraint: NSLayoutConstraint!
   // @IBOutlet weak var vwTableBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwTableHeightConstraint: NSLayoutConstraint!


    //
    
    // deepak new
    //MARK: - Variables
    
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    
    var pickedImageRegistration:UIImage?
    var pickedImageLicense:UIImage?
    
    var strType: Int = 0
    var strDriverType:String = "2"
    var strMake: Int = 0
    var arrMake:[VehicleModel] = []
    var arrType:[VehicleModel] = []
    var strVehicleTypeId: String = ""
    var strMakeId: String = ""
    var strMakeSelection = ""
    var strTypeSelection = ""
    var isFromLogin:Bool = false
    var strVehicleInfoId = ""
    
    var isLicense:Bool = false
    var isRegistration:Bool = false

    var isFormFoodDriver = false
    var isFirstAppear = false
    var arrTxtID:[Int] = []
    var arrTxtName:[String] = []

    
    var registrationUpdate = false
    var licenseUpdate = false
   
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isFirstAppear = true
        self.setUI()
        self.imagePicker.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
        
        print("self.isFormFoodDriver is \(self.isFormFoodDriver)")
              
//              if self.isFormFoodDriver == true {
//                  self.strDriverType = "3"
//              }else{
//                  self.strDriverType = "2"
//
//              }
        self.callWsForUserVehicleRole()
        self.tblBottom.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localization()
   

    }


    
    
    //MARK: - Functions
    
    
   func setData() {
    
    if let vehicleInfoID = objAppShareData.dictVichleInfo["vehicleInfoID"]as? String{
        self.strVehicleInfoId = vehicleInfoID
    }
    
    if let vehicleYear = objAppShareData.dictVichleInfo["vehicle_year"]as? String{
        self.txtYear.text = vehicleYear
    }
    if let modelNumber = objAppShareData.dictVichleInfo["model_number"]as? String{
           self.txtModel.text = modelNumber
       }
    if let vehicleNumber = objAppShareData.dictVichleInfo["vehicle_number"]as? String{
           self.txtNumber.text = vehicleNumber
       }
    if let vehicleType = objAppShareData.dictVichleInfo["vehicle_type"]as? String{
        self.lblTypePalceHolder.isHidden = true
           self.lblType.text = vehicleType
        objAppShareData.strSelectedModelNames = vehicleType
       }
    if let make = objAppShareData.dictVichleInfo["make"]as? String{
           self.lblMakePalceHolder.isHidden = true
           self.lblMake.text = make
          objAppShareData.strSelectedCompanyNames = make
       }
    
    if let vehicleCompanyID = objAppShareData.dictVichleInfo["vehicleCompanyID"]as? String{
       self.strMakeId = vehicleCompanyID
        objAppShareData.strSelectedVehicleCompanyId = vehicleCompanyID
    }
    if let vehicleMetaID = objAppShareData.dictVichleInfo["vehicleMetaID"]as? String{
        self.strVehicleTypeId = vehicleMetaID
       objAppShareData.strSelectedVehicleMetaId = vehicleMetaID

    }
    if let type = objAppShareData.dictVichleInfo["type"]as? String{
        self.strDriverType = type

    }

    
    if let license = objAppShareData.dictVichleInfo["license"]as? String{
        self.vwImgLicense.isHidden = false
        self.vwLicense.isHidden = true

        if license != "" {
            let url = URL(string: license)
            self.imgLicense.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
            self.isLicense = true


        }
    }
    if let registration = objAppShareData.dictVichleInfo["registration"]as? String{
           self.vwImgRegistration.isHidden = false
        self.vwRegistration.isHidden = true

        if registration != "" {
                   let url = URL(string: registration)
                   self.imgRegistration.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
            
            self.isRegistration = true
                    
               }
       }

    }
    
    func setUI(){
        
        self.vwBlur.isHidden = true
//        self.vwImgLicense.isHidden = true
//        self.vwImgRegistration.isHidden = true
        
        self.vwYear.setCornerRadiusQwafy(vw: self.vwYear)
        self.vwMake.setCornerRadiusQwafy(vw: self.vwMake)
        self.vwModel.setCornerRadiusQwafy(vw: self.vwModel)
        self.vwType.setCornerRadiusQwafy(vw: self.vwType)
        self.vwNumber.setCornerRadiusQwafy(vw: self.vwNumber)

        self.vwImgRegistration.setCornerRadius(radius: 14)
        self.vwImgLicense.setCornerRadius(radius: 14)
        self.vwUpdate.setButtonView(vwOuter : self.vwUpdate , vwImage : self.vwImgUpdate, btn: self.btnUpdate )
        
        self.vwTable.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
        
    
        self.vwBlur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))

      self.setData()

    }
      
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        self.vwBlur.isHidden = true
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtYear{
           // self.txtYear.resignFirstResponder()
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
        }else  if textField == txtModel{
            let maxLength = 30
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 31{
                //textField.resignFirstResponder()
            }
            return newString.length <= maxLength
        }else  if textField == txtNumber{
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 21{
                //textField.resignFirstResponder()
            }
            return newString.length <= maxLength
        } else{
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
//        let strYear = self.txtYear.text?.count ?? 0
//        let strModel = self.txtModel.text?.count ?? 0
//        let strNumber = self.txtNumber.text?.count ?? 0
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let enterYear = Int(txtYear.text ?? "")
        
        if self.txtYear.text?.isEmpty == true{
            objAlert.showAlert(message: BlankYear.localize, title: kAlert.localize, controller: self)
        }
        
        else if self.txtModel.text?.isEmpty == true{
            objAlert.showAlert(message: BlankModel.localize, title: kAlert.localize, controller: self)
        }
        
//        else if strModel < 5{
//            objAlert.showAlert(message: ModelValidation, title: kAlert, controller: self)
//        }
        
        
        else if self.lblMake.text?.isEmpty == true{
            objAlert.showAlert(message: BlankMake.localize, title: kAlert.localize, controller: self)
        }else if self.lblType.text?.isEmpty == true{
            objAlert.showAlert(message: BlankVehicle, title: kAlert.localize, controller: self)
        }else if self.txtNumber.text?.isEmpty == true{
            objAlert.showAlert(message: BlankNumber.localize, title: kAlert.localize, controller: self)
        }
//        else if strNumber < 5 {
//            objAlert.showAlert(message: NumberValidation, title: kAlert, controller: self)
//        }
            
            
//        else if self.pickedImageRegistration == nil{
//            objAlert.showAlert(message: BlankRegistration, title: kAlert, controller: self)
//        }else if self.pickedImageLicense == nil{
//            objAlert.showAlert(message: BlankLicense, title: kAlert, controller: self)
//        }
        
        

        
        else if self.isRegistration == false{
                objAlert.showAlert(message: BlankRegistration.localize, title: kAlert.localize, controller: self)
            }else if self.isLicense == false{
                objAlert.showAlert(message: BlankLicense.localize, title: kAlert.localize, controller: self)
            }else if enterYear ?? 0 > currentYear {
                objAlert.showAlert(message: "You can't enter future date", title: kAlert.localize, controller: self)
                
            }
       
            
        
        else{
            // objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
            self.callWsForVehicleDetails()
        }
        
    }
    
    func localization(){
        self.lblLocEditProfileHeader.text = "Edit_Profile".localize
        self.lblLocPleaseFillAllInfo.text = "Please,fill_all_information".localize
        self.lblLocModel.text = "Model_Number".localize
        self.lblLocVehicleType.text = "Vehicle_Type".localize
        self.lblVehicleNumber.text = "Vehicle_Number".localize
        self.lblLocYear.text = "Year".localize
        self.lblLocRegistration.text = "Registration".localize
        self.lblLocLicense.text = "License".localize
        self.lblLocMake.text = "Make".localize
        self.lblMakePalceHolder.text = "Select_Make".localize
        self.lblTypePalceHolder.text = "Select_vehicle_type".localize


        self.lblLocUploadLicense.text = "Upload_License".localize
        self.lblLocUploadId.text = "Upload_Id".localize
        self.txtYear.placeholder = "Enter_year".localize
        self.txtModel.placeholder = "Model_Number".localize
        self.txtNumber.placeholder = "Enter_vehicle_number".localize
        self.btnUpdate.setTitle("Update_Profile".localize, for: .normal)
        self.btnCancel.setTitle("Cancel".localize, for: .normal)

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
    
    @IBAction func btnUpdateAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.validationForBasicInfo()
        //  objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
        
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
        
   
        
        self.strType = 0
        self.setImage()

    }
    
    @IBAction func btnDeleteLicense(_ sender: UIButton) {
        self.view.endEditing(true)
        print("btn DeleteLicense is click")
        
//        self.vwImgLicense.isHidden = true
//        self.vwLicense.isHidden = false
//        self.isLicense = false
        
        self.strType = 1
        self.setImage()

    }
    
    @IBAction func btnMake(_ sender: Any) {
        self.view.endEditing(true)

            self.strMake = 0

        self.showBotttomSheet(arr: self.arrMake,str: "Select_Make".localize, makeId : self.strMakeId, vehicleTypeId: "")

    }
    
        @IBAction func btnType(_ sender: Any) {
            self.view.endEditing(true)

            if  self.strMakeId == ""  {
                objAlert.showAlert(message: "Please_select_make_first".localize, title: kAlert.localize, controller: self)
                
            }else{
    //            self.vwBlur.isHidden = false
    //            self.lblTableHeader.text = "Select Vehicle Type"
    //            self.tblBottom.reloadData()
              // self.callWsForUserVehicleRole()
                self.strMake = 1

                self.showBotttomSheet(arr: self.arrType,str: "Select_vehicle_type".localize, makeId : "", vehicleTypeId: self.strVehicleTypeId)
            }
        }
    
    func showBotttomSheet(arr : Array<Any>, str: String , makeId: String , vehicleTypeId: String){
        
        let sb = UIStoryboard.init(name: "TaxiDProfile", bundle:Bundle.main)
              let vc = sb.instantiateViewController(withIdentifier:"VehicleSheetVC") as! VehicleSheetVC
        vc.arrBottom = arr as! [VehicleModel]
        vc.strHeader = str
        vc.strMakeId = makeId
        vc.strVehicleTypeId = vehicleTypeId
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        
       // new deepak
        vc.closerCallApi = {
            isClearListData in
            if isClearListData{
                self.isFirstAppear = false
                self.callWsForUserVehicleRole()
            }
        }
        // new deepak
        self.present(vc, animated: false, completion: nil)
        
    }
       
    func sendObjFromVehicleSheetVC(obj: VehicleModel) {
        self.arrType.removeAll()
        print("obj is \(obj.strModel)")
        
        self.arrType = obj.arrVehicleType
        print("arrType count is \(self.arrType.count)")
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
            // new deepak
            print(" self.strMakeId is \(self.strMakeId)")
            print(" objAppShareData.strSelectedVehicleCompanyId is \(objAppShareData.strSelectedVehicleCompanyId)")
            
            
            self.lblTypePalceHolder.isHidden = false
            self.lblType.isHidden = true
            self.strVehicleTypeId = ""
            self.lblType.text = ""
            // new deepak
        } else  if  self.strMake == 1 {

            self.lblTypePalceHolder.isHidden = true
            self.lblType.isHidden = false
            
        self.strVehicleTypeId = strId
        self.lblType.text = strName
        self.strTypeSelection = strName
        self.lblTypePalceHolder.isHidden = true
        }
    }
    
    
    @IBAction func btnCancle(_ sender: Any) {
        self.view.endEditing(true)
        self.vwBlur.isHidden = true
        
    }
    
    @IBAction func btnCancleCross(_ sender: Any) {
        self.view.endEditing(true)

        //self.ResetRoot()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func ResetRoot(){
        
        if self.isFormFoodDriver == true{
            
            for vc in (self.navigationController?.viewControllers) ?? []{
                if vc is FoodDriverProfileVC {
                    self.navigationController?.popToViewController(vc, animated: false)
                    break
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            
            
        } else {
            for vc in (self.navigationController?.viewControllers) ?? []{
                if vc is TaxiDriverProfileVC{
                    self.navigationController?.popToViewController(vc, animated: false)
                    break
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }
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
        
        let cancelAction = UIAlertAction(title:"Cancel".localize, style: UIAlertAction.Style.cancel)
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
                
                self.isRegistration = true
                self.pickedImageRegistration = editedImage
                self.vwImgRegistration.isHidden = false
                self.vwRegistration.isHidden = true
                //  self.imgRegistration.image = self.pickedImage
                self.imgRegistration.image = self.pickedImageRegistration
                self.registrationUpdate = true
            }else{
                        
                self.isLicense = true
                self.pickedImageLicense = editedImage
                self.vwImgLicense.isHidden = false
                self.vwLicense.isHidden = true
                // self.imgLicense.image = self.pickedImage
                self.imgLicense.image = self.pickedImageLicense
                self.licenseUpdate = true
            }
            
            imagePicker.dismiss(animated: true, completion: nil)
        }
//        else if let originalImage = info[.originalImage] as? UIImage {
//            //                self.pickedImage = originalImage
//            //                self.imgProfile.image = pickedImage
//            //                imagePicker.dismiss(animated: true, completion: nil)
//
//        }
    }
}


extension EditVehicleInfoVC {
    // TODO: Webservice For UserVehicleRole
    func callWsForUserVehicleRole(){
        
        if !objWebServiceManager.isNetworkAvailable(){
             objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        
        if  self.isFirstAppear == true{
            objWebServiceManager.StartIndicator()
        }
        
        //objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        
        
        param = [
            WsParam.vehicleType: self.strDriverType
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.vehicleList  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                let dict  = response["data"] as? [String:Any]
                
                //   if let data = response["data"] as? [String:Any]
                
                if let arrVehicleData = dict?["vehicle_list"] as? [[String:Any]]{
                    self.arrMake.removeAll()
                    self.arrType.removeAll()
                    
                    //       if let arrVehicleData = dict["vehicle_list"] as! [[String: Any]]{
                    for dictVehicleData in arrVehicleData{
                        let objVehicleData = VehicleModel.init(dict: dictVehicleData)
                        self.arrMake.append(objVehicleData)
                    }
                    

                    let objData = self.arrMake.filter(({
                        $0.strVehicleCompanyId == self.strMakeId
                    }))
                    
                    if objData.count > 0 {
                        self.arrType = objData[0].arrVehicleType
                    }
                    


//                    for obj in self.arrMake{
//                        // new deepak
//                        print("self.strMakeId is \(self.strMakeId)")
//                        if self.strMakeId == obj.strVehicleCompanyId {.
//                            self.arrType.append(contentsOf: obj.arrVehicleType)
//
//                       }// new deepak
//                    }
                    print("arrMake count is \(self.arrMake.count)")
                    
                }
                self.tblBottom.reloadData()
               
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
            objAlert.showAlert(message: NoNetwork.localize, title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param = [String:Any]()
        var arrDataa = [Data]()
        var arrParam = [String]()
        var imageData1 : Data?
        var imageData2 : Data?
        
        
        
       // let imageData1 = (self.pickedImageRegistration?.jpegData(compressionQuality: 1.0)) ??         (self.imgRegistration.image?.jpegData(compressionQuality: 1.0))
//
//        let imageData2 = (self.pickedImageLicense?.jpegData(compressionQuality: 1.0)) ??         (self.imgLicense.image?.jpegData(compressionQuality: 1.0))

        
        if self.pickedImageRegistration != nil{
           // let jpegData = pickedImageRegistration?.jpegData(compressionQuality: 1.0)
            
            imageData1 = objAppShareData.compressImage(image: self.pickedImageRegistration!) as Data?
            
//            (img?.jpegData(compressionQuality: 1.0)) ??         (self.imgRegistration.image?.jpegData(compressionQuality: 1.0))
            
           // arrDataa.append(imageData1!)
            
            
        }
        if self.pickedImageLicense != nil{
            imageData2 = objAppShareData.compressImage(image: self.pickedImageLicense!) as Data?
          //  arrDataa.append(imageData2!)
        }
        
        
        
        if self.registrationUpdate == true {
            arrDataa.append(imageData1!)
            arrParam.append(contentsOf: ["registration_image"])

        }
        if self.licenseUpdate == true{
            arrDataa.append(imageData2!)
            arrParam.append(contentsOf: ["license_image"])

        }else{
            arrParam.append(contentsOf: ["",""])
        }
        
          
         param = ["vehicle_info_id": self.strVehicleInfoId,
                      "year": self.txtYear.text ?? "",
                      "model_number":self.txtModel.text ?? "",
                      "vehicle_number": self.txtNumber.text ?? "",
                      "make":  self.strMakeId,
                      "vehicle_type": self.strVehicleTypeId
             ]
        
        
        print(param)
        
        objWebServiceManager.uploadMultipartMultipleImagesData(strURL: WsUrl.updateVehicleInfo, params: param, showIndicator: false, imageData: imageData1, imageToUpload: arrDataa, imagesParam: arrParam, fileName: "", mimeType: "image/jpeg", success: { response in
                    
            print(response)
            objWebServiceManager.StopIndicator()
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            if status == "success" {
                self.updateAlert(msg: "Profile_updated_successfully".localize)
              //  self.ResetRoot()
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
            
           // self.navigationController?.popViewController(animated: true)
             self.ResetRoot()
            
           }))
           self.present(alert, animated: true, completion: nil)
       }

}

extension EditVehicleInfoVC : UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

      return self.arrMake.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblBottom.dequeueReusableCell(withIdentifier: "BasicInfoCell")as! BasicInfoCell
 
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {


        }
        

    }
    
    
    
    @objc func buttonClicked(sender:UIButton) {

    }
    
    

}

