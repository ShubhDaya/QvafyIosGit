//
//  FilterVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 01/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import HCSStarRatingView
import GooglePlaces

class FilterVC: UIViewController ,FilterBottomSheetVCDelegate{
    
    //MARK: Outlets
    
    @IBOutlet weak var btnSlider: UISlider!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwDotted1: UIView!
    @IBOutlet weak var vwDotted2: UIView!
    @IBOutlet weak var vwDotted3: UIView!
    @IBOutlet weak var vwDotted4: UIView!
    @IBOutlet weak var lblSlider: UILabel!
    @IBOutlet weak var vwRating: HCSStarRatingView!
    @IBOutlet weak var vwApply: UIView!
    @IBOutlet weak var vwImgApply: UIView!
    @IBOutlet weak var btnApplyFilter : UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    
    // Localization Outlets -
    @IBOutlet weak var lblLOFilterHeader: UILabel!
    @IBOutlet weak var lblLOBussinesTYpe: UILabel!
    @IBOutlet weak var lblLOCatergory: UILabel!
    @IBOutlet weak var lblLOLocation: UILabel!
    @IBOutlet weak var lblLOSelectRadius: UILabel!
    @IBOutlet weak var lblLO0KMs: UILabel!
    @IBOutlet weak var lblLO30KMs: UILabel!

    @IBOutlet weak var lblLOReviews: UILabel!
    @IBOutlet weak var lblLOApplyFilter: UILabel!
    @IBOutlet weak var btnLOClear: UIButton!
    
    //MARK: - Variables
    
    var strRadius = "5"
    var strRatingcount = "0"
    var strBottomSheetFrom = ""
    var arrCategory:[FilterModel] = []
    var arrBusiness:[FilterModel] = []
    
    
    var strCategoryId = ""
    var strBusinessId = ""
    
    var strSourceLat = ""
    var strSourceLong = ""
    var StrCurrentSource : String = ""
    
       var isFromPlacePicker = false

    
    var arrSelectedBusinessId = [Int]()
    var arrSelectedCategoryId = [Int]()

    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiDesign()
        self.callWsGetCategoryList()
        self.callWsGetBusinessList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localization()
        self.uiDesign()
        
    }
    
    func uiDesign(){
        self.vwHeader.setviewbottomShadow()
        self.vwDotted1.creatDashedLine(view: vwDotted1)
        self.vwDotted2.creatDashedLine(view: vwDotted2)
        self.vwDotted3.creatDashedLine(view: vwDotted3)
        self.vwDotted4.creatDashedLine(view: vwDotted4)
        
        self.vwApply.setButtonView(vwOuter : self.vwApply , vwImage : self.vwImgApply, btn: self.btnApplyFilter )
        
        let ratingData = Double(objAppShareData.strRatingcount)
        self.vwRating.value  = CGFloat(ratingData!)
        
        
        
        
        self.lblSlider.text = objAppShareData.strRadius
        self.strRadius = objAppShareData.strRadius
        let value = "\(objAppShareData.strRadius)"
        let floatVal  = (value as NSString).floatValue //Now converted to float
        self.btnSlider.value = floatVal
        
        
        self.strBusinessId = objAppShareData.strBusinessId
        self.strCategoryId = objAppShareData.strCategoryId
        
        // deepak new works
        self.arrSelectedBusinessId = objAppShareData.arrSelectedBusinessId
        self.arrSelectedCategoryId = objAppShareData.arrSelectedCategoryId
        // deepak new works


        
        
        if self.isFromPlacePicker{
            self.isFromPlacePicker = false
            // deepak new
            self.lblLocation.text = self.StrCurrentSource
//            self.strSourceLat = objAppShareData.strSourceLat
//            self.strSourceLong = objAppShareData.strSourceLong
            
            // deepak new

        }else{
            self.lblLocation.text = self.StrCurrentSource
            self.strSourceLat = objAppShareData.strSourceLat
            self.strSourceLong = objAppShareData.strSourceLong
           
        }
        
        print("self.strCategory is \(self.strCategoryId)")

    }
    
    func localization(){
        
        self.lblLOFilterHeader.text = "Filter".localize
        self.lblLOBussinesTYpe.text = "Business_Type".localize
        self.lblLOCatergory.text = "Category".localize
        self.lblLOLocation.text = "Location".localize
        self.lblLOSelectRadius.text = "Select_Radius".localize
        self.lblLO0KMs.text = "0_Kms".localize
        self.lblLO30KMs.text = "30_Kms".localize
        self.lblLOReviews.text = "Reviews".localize
        self.lblLOApplyFilter.text = "Apply_Filter".localize
        self.btnLOClear.setTitle("Clear".localize, for: .normal)
        
        
    }
    
    //MARK: Button Actions
    
    @IBAction func btnBack(_ sender: Any){
        self.view.endEditing(true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnSliderAction(_ sender: UISlider) {
        
        print(" in normal \(sender.value)")
        print(" in int \(Int(sender.value))")
        print("in string \(String(sender.value))")
        
        self.lblSlider.text = (String(Int(sender.value)))
        
        self.strRadius = (String(Int(sender.value)))
        
        
    }
    
    @IBAction func btnApplyFilter(_ sender: Any){
        self.view.endEditing(true)
        
        let rating = Double(self.vwRating.value)
        // self.strRatingcount = String(rating)
        
        
        print("Stringrating is \(String(rating))")
     
        
        
        let ratingInt = Int(self.vwRating.value)
        
        print("ratingInt is \(ratingInt)")
        
        let strdata = String(ratingInt)
        print("strdata is \(strdata)")
        
        objAppShareData.strRatingcount = strdata
        
        //  objAppShareData.strRatingcount = String(rating)
        
        objAppShareData.strBusinessId = self.strBusinessId
        objAppShareData.strCategoryId = self.strCategoryId
        
        
        objAppShareData.arrSelectedBusinessId = self.arrSelectedBusinessId
        objAppShareData.arrSelectedCategoryId = self.arrSelectedCategoryId

        
        objAppShareData.strSourceLat = self.strSourceLat
        objAppShareData.strSourceLong = self.strSourceLong
        
        objAppShareData.strRadius = self.strRadius
        
        objAppShareData.strLoction =  self.StrCurrentSource
        
        objAppShareData.isFromFilter = true
        self.navigationController?.popViewController(animated: false)
        
    }
    
    @IBAction func btnClear(_ sender: Any){
        self.view.endEditing(true)
        
        self.strRadius = "5"
        objAppShareData.removeFilter()
        
        let ratingData = Double(objAppShareData.strRatingcount)
        self.vwRating.value  = CGFloat(ratingData!)
        self.lblLocation.text = self.StrCurrentSource
        self.lblSlider.text = "5"
        self.btnSlider.value = 5
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnBussinessType(_ sender: Any){
        self.view.endEditing(true)
        self.strBottomSheetFrom = "1"
        let str = "Bussiness Type".localize
        self.showBotttomSheet(arr: self.arrBusiness,str: str)
        
    }
    @IBAction func btnCategory(_ sender: Any){
        self.view.endEditing(true)
        self.strBottomSheetFrom = "2"
        let str = "Select Category".localize
        self.showBotttomSheet(arr: self.arrCategory,str: str)
        
        
    }
    @IBAction func btnLocation(_ sender: Any){
        self.view.endEditing(true)
        self.openPlacePickerForSource()
    }
    
    //MARK:- open Place Picker For Source
    
    func openPlacePickerForSource(){
        PlacePicker.shared.openPicker(controller: self, success: { (placeDict) in
            print("place info = \(placeDict)")
            
            self.isFromPlacePicker = true

            self.lblLocation.text = placeDict["formattedAddress"] as? String ?? ""
            self.StrCurrentSource = placeDict["formattedAddress"] as? String ?? ""
            
            //   objAppShareData.strLoction =  placeDict["formattedAddress"] as? String ?? ""
            
            self.strSourceLat = placeDict["lat"] as? String ?? ""
            print(self.strSourceLat)
            self.strSourceLong = placeDict["long"]
                as? String ?? ""
            print(self.strSourceLong)
            let coordLat = placeDict["clat"] as? CLLocationDegrees ?? 0.0
            let coordLong = placeDict["clong"] as? CLLocationDegrees ?? 0.0
            
            let Cordinate = CLLocationCoordinate2D.init(latitude: coordLat, longitude: coordLong)
            PlacePicker.shared.reverseGeocodeCoordinate(Cordinate, success: { (addressModel) in
                
            }) { (error) in
                print("error in getting address.")
            }
        }) { (error) in
            print("error = \(error.localizedDescription)")
        }
    }
    
    
    func showBotttomSheet(arr : Array<Any>, str: String ){
        
        let sb = UIStoryboard.init(name: "Restaurant", bundle:Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier:"FilterBottomSheetVC") as! FilterBottomSheetVC
        
        vc.arrBottom = arr as! [FilterModel]
        
        // deepak new
        if str == "Select Category".localize {
        vc.SelectedArrBottom = self.arrSelectedCategoryId
        }else{
        vc.SelectedArrBottom = self.arrSelectedBusinessId

        }
        // deepak new
        
        vc.strHeader = str
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
        
    }
    
    //MARK: step 6 finally use the method of the contract
    func sendDataToFirstViewController(arrId:[Int], arrName:[String]) {
        print(" my country is \(arrId)")
        // print(" my Country is \(arrName)")
        //            let varText = arrName.joined(separator:",")
        if self.strBottomSheetFrom == "1"{
            //objAppShareData.arrSelectedBusinessId = arrId
            self.arrSelectedBusinessId = arrId

            self.strBusinessId = (arrId.map{String($0)}).joined(separator: ",")
            print("self.strBusinessId is \(self.strBusinessId)")
            
            
        }else if self.strBottomSheetFrom == "2"{
            //objAppShareData.arrSelectedCategoryId = arrId
            self.arrSelectedCategoryId = arrId

            self.strCategoryId = (arrId.map{String($0)}).joined(separator: ",")
            print("self.strCategory is \(self.strCategoryId)")
            
        }
    }
    
    
}


extension FilterVC {
    // TODO: Webservice For getBusinessList
    func callWsGetBusinessList(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            //  objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        //objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        
        
        param = [
            WsParam.limit: 10,
            WsParam.offset: 0,
            WsParam.search: ""
            
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.getBusinessList  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
            print(response)
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                let dict  = response["data"] as? [String:Any]
                
                
                if let arrBusinessData = dict?["business_type_list"] as? [[String:Any]]{
                    // self.arrMake.removeAll()
                    
                    for dictBusinessData in arrBusinessData{
                        let objBusinessData = FilterModel.init(dict: dictBusinessData)
                        self.arrBusiness.append(objBusinessData)
                    }
                    print("arrBusiness count is \(self.arrBusiness.count)")
                    
                }
                // self.tblBottom.reloadData()
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
    
    // TODO: Webservice For getCategoryList
    func callWsGetCategoryList(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            //  objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        //objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        
        
        param = [
            WsParam.limit: 10,
            WsParam.offset: 0,
            WsParam.search: ""
            
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.getCategoryList  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
            print(response)
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                let dict  = response["data"] as? [String:Any]
                
                
                if let arrCategoryData = dict?["category_list"] as? [[String:Any]]{
                    // self.arrMake.removeAll()
                    
                    for dictCategoryData in arrCategoryData{
                        let objCategoryData = FilterModel.init(dict: dictCategoryData)
                        self.arrCategory.append(objCategoryData)
                    }
                    
                    print("arrCategory count is \(self.arrCategory.count)")
                    
                }
                // self.tblBottom.reloadData()
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
}
