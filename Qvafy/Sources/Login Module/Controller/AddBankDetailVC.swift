//
//  AddBankDetailVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 15/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class AddBankDetailVC: UIViewController , UINavigationControllerDelegate , UITextFieldDelegate, UIGestureRecognizerDelegate{
    //MARK: - Outlets
    
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var viewNext: UIView!
    @IBOutlet weak var viewImgNext: UIView!
    @IBOutlet weak var vwProgress: UIView!
    @IBOutlet weak var vwRound: UIView!
    @IBOutlet weak var vwNumber: UIView!
    @IBOutlet weak var vwBank: UIView!
    @IBOutlet weak var vwBlur: UIView!
    @IBOutlet weak var vwTable: UIView!
    @IBOutlet weak var txtAccountNo: UITextField!
    @IBOutlet weak var lblBank: UILabel!
    @IBOutlet weak var lblHeaderText: UILabel!
    @IBOutlet weak var lblProgress: UILabel!
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    // bottom sheet
    @IBOutlet weak var lblTableHeader: UILabel!
    @IBOutlet weak var tblBottom: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var tblBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwTableBottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var imgToggle: UIImageView!
    @IBOutlet weak var vwAddBank: UIView!
    @IBOutlet weak var vwIsCuba: UIView!
    @IBOutlet weak var vwSelectBank: UIView!
    
    @IBOutlet weak var viewSkip: UIView!
    @IBOutlet weak var viewImgSkip: UIView!
    
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var viewImgContinue: UIView!
    
    // localisation outlets -
    @IBOutlet weak var lblYouAreStep: UILabel!
    @IBOutlet weak var lblLOHeaderBankAccount: UILabel!
    @IBOutlet weak var lblLOHeaderDesc: UILabel!
    @IBOutlet weak var lblLOAreYourFromCUba: UILabel!
    @IBOutlet weak var lblLOBank: UILabel!
    @IBOutlet weak var lblLOCubanBankCard: UILabel!
    @IBOutlet weak var lblBankPalceHolder: UILabel!
    @IBOutlet weak var lblLOPleaseBankAccontDetails: UILabel!
    
    
    var objCommon:CommonModel?
    
    //MARK: - Variables
    var arrBankList:[CommonModel] = []
    var strMakeSelection = ""
    var isFromLogin:Bool = false
    var strCubanBankId:String = ""
    var strIsCubanBank:Int = 0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
        
        self.callWsForGetContent()
        self.tblBottom.reloadData()
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
        self.vwAddBank.isHidden = false
        self.vwBank.isHidden = true
        //   self.creatDashedLine()
        
        self.vwSelectBank.setCornerRadiusQwafy(vw: self.vwSelectBank)
        self.vwNumber.setCornerRadiusQwafy(vw: self.vwNumber)
        self.viewNext.setButtonView(vwOuter : self.viewNext , vwImage : self.viewImgNext, btn: self.btnAdd )
        self.viewSkip.setButtonView(vwOuter : self.viewSkip , vwImage : self.viewImgSkip, btn: self.btnSkip)
        self.viewContinue.setButtonView(vwOuter : self.viewContinue , vwImage : self.viewImgContinue, btn: self.btnContinue)
        self.vwProgress?.layer.cornerRadius = (vwProgress?.frame.size.height)!/2.0
        self.vwProgress?.layer.masksToBounds = true
        self.vwRound.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 70.0)
        self.vwTable.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
        
        self.txtAccountNo.attributedPlaceholder = NSAttributedString(string: "Enter your card number".localize, attributes: [
            .foregroundColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1) ,
            .font: UIFont(name: "Poppins-Medium", size: 13.3)
        ])
        
        self.viewSkip.isHidden = true
    }
    
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        self.vwBlur.isHidden = true
    }
    
    //MARK: Create Dash Line
    func creatDashedLine(){
        let topPoint = CGPoint(x: self.vwIsCuba.bounds.minX, y: self.vwIsCuba.bounds.maxY)
        let bottomPoint = CGPoint(x: self.vwIsCuba.bounds.maxX, y: self.vwIsCuba.bounds.maxY)
        self.vwIsCuba.createDashedLine(from: topPoint, to: bottomPoint, color: .lightGray, strokeLength: 8, gapLength: 4, width: 0.5)
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtAccountNo{
            self.self.txtAccountNo.text = "xxxx xxxx xxxx"
            self.txtAccountNo.resignFirstResponder()
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            return true
        }
        
        if textField == txtAccountNo{
            let maxLength = 16
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 17{
                //textField.resignFirstResponder()
            }
            return newString.length <= maxLength
        }
        else{
            return true
        }
        
        
        
    }
    
    
    
    
    
    
    func validationForCubanBankInfo(){
        
        self.txtAccountNo.text = self.txtAccountNo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //   let strNumber = self.txtAccountNo.text?.count ?? 0
        
        
        
        if self.lblBank.text?.isEmpty == true{
            objAlert.showAlert(message: BlankBank.localize, title: kAlert.localize, controller: self)
        }else
        
        if self.txtAccountNo.text?.isEmpty == true{
            objAlert.showAlert(message: BlankCubanBankCard.localize, title: kAlert.localize, controller: self)
        }
        
        //            else if strNumber < 12{
        //            objAlert.showAlert(message: BlankCubanCardValidation, title: kAlert, controller: self)
        //        }
        
        //            else if !objValidationManager.isValidBankAccountNUmber(testStr: self.txtAccountNo.text ?? ""){
        //            objAlert.showAlert(message: ValidCubanBankCard, title: kAlert, controller: self)
        //        }
        else{
            // objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
            self.callWsForSetCubaBankAccount()
        }
    }
    
    
    func NavigateToAddBank(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "AddBankAccountVC") as! AddBankAccountVC
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    func localization(){
        self.lblYouAreStep.text = "You_are_in_step_4".localize
        self.lblLOHeaderBankAccount.text = "Add_Bank_Details".localize
        self.lblLOHeaderDesc.text = "There_are_many_variations_of_passages_of_Lorem_Ipsum_available".localize
        self.lblLOAreYourFromCUba.text = "Are_you_from_Cuba_?".localize
        self.lblLOBank.text = "Bank".localize
        self.lblBankPalceHolder.text = "Select_bank".localize
        self.lblLOCubanBankCard.text = "Cuban_Bank_Card".localize
        self.lblLOPleaseBankAccontDetails.text = "Please_add_your_bank_account_details_for_receiving_payment".localize
        
        self.txtAccountNo.placeholder = "Enter your card number".localize
        self.btnAdd.setTitle("Add".localize, for: .normal)
        self.btnSkip.setTitle("Skip".localize, for: .normal)
        self.btnContinue.setTitle("Continue".localize, for: .normal)
        
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
    
    
    @IBAction func btnSelectBank(_ sender: UIButton) {
        self.view.endEditing(true)
        print(self.strMakeSelection)
        self.vwBlur.isHidden = false
        self.lblTableHeader.text = "Select_bank".localize
        self.strMakeSelection = self.lblBank.text ?? ""
        self.tblBottom.reloadData()
    }
    
    @IBAction func btnIsCuba(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if sender.isSelected == false{
            sender.isSelected = true
            self.imgToggle.image = #imageLiteral(resourceName: "ON_TOGGLE_ICO")
            self.vwAddBank.isHidden = true
            self.vwBank.isHidden = false
            self.strIsCubanBank = 1
            
        }else{
            sender.isSelected = false
            self.imgToggle.image = #imageLiteral(resourceName: "OFF_TOGGLE_ICO")
            self.vwBank.isHidden = true
            self.vwAddBank.isHidden = false
            self.strIsCubanBank = 0
            self.txtAccountNo.text = ""
            self.strCubanBankId = ""
            self.lblBank.text = ""
            self.lblBankPalceHolder.isHidden = false
        }
    }
    
    @IBAction func btnAddBank(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if self.imgToggle.image == #imageLiteral(resourceName: "ON_TOGGLE_ICO") {
            self.validationForCubanBankInfo()
        }else{
            self.NavigateToAddBank()
        }
        
    }
    
    @IBAction func btnSkip(_ sender: UIButton) {
        self.view.endEditing(true)
        self.callWsForSkipButton()
    }
    @IBAction func btnCancle(_ sender: UIButton) {
        self.view.endEditing(true)
        self.vwBlur.isHidden = true
        self.strMakeSelection = ""
        self.tblBottom.reloadData()
        
    }
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if  self.strMakeSelection == ""  {
            objAlert.showAlert(message: "Please_select_bank".localize, title: kAlert.localize, controller: self)
            
        }else{
            self.strCubanBankId = self.objCommon!.strCubaBankID
            self.lblBank.text = self.objCommon!.strBankName
            self.lblBankPalceHolder.isHidden = true
            self.vwBlur.isHidden = true
            
        }
        
    }
    
}


extension AddBankDetailVC {
    // TODO: Webservice For Get Content
    func callWsForGetContent(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            //  objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        //objWebServiceManager.StartIndicator()
        
        objWebServiceManager.requestGet(strURL: WsUrl.content ,Queryparams: nil, body: nil, strCustomValidation: "", success: {response in
            print(response)
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                let dict  = response["data"] as? [String:Any]
                
                if let arrBankListData = dict?["cuba_bank_list"] as? [[String:Any]]{
                    
                    self.arrBankList.removeAll()
                    
                    for dictBankData in arrBankListData
                    {
                        let objBankList = CommonModel.init(dict: dictBankData)
                        
                        self.arrBankList.append(objBankList)
                    }
                }
                print("self.arrBankList.count is \(self.arrBankList.count)")
                
                self.tblBottom.reloadData()
            }else
            {
                objAlert.showAlert(message:message ?? "", title: "Alert".localize, controller: self)
            }
        }, failure: { (error) in
            print(error)
            // objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
        
    }
    
    // TODO: Webservice For Skip Button
    
    func callWsForSkipButton(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        
        param = [
            WsParam.skipStep: "5"
        ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.skipStep, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                let dic  = response["data"] as? [String:Any]
                
                let user_details  = dic!["user_detail"] as? [String:Any]
                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                objAppShareData.fetchUserInfoFromAppshareData()
                objAppShareData.saveUserDetailsOnFireBase()
                objAppDelegate.observeProductMessages()
                self.NavigateToGuideVC()
                
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
    
    
    // TODO: Webservice For set Cuba Bank Account
    
    func callWsForSetCubaBankAccount(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        
        objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        
        
        param = [
            WsParam.cubaBankId: self.strCubanBankId ,
            WsParam.cubaBankCard: self.txtAccountNo.text ?? ""
        ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.setCubBankAccount, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                let dic  = response["data"] as? [String:Any]
                
                let user_details  = dic!["user_detail"] as? [String:Any]
                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                objAppShareData.fetchUserInfoFromAppshareData()
                objAppShareData.saveUserDetailsOnFireBase()
                objAppDelegate.observeProductMessages()
                self.NavigateToGuideVC()
                
            }
            else
            {
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title:kAlert.localize, controller: self)
            
        })
    }
    
    func NavigateToGuideVC(){
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "GuideVC") as! GuideVC
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension AddBankDetailVC : UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // self.tblHeight.constant = CGFloat((self.arrBankList.count * 44))
        return self.arrBankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicInfoCell")as! BasicInfoCell
        
        let obj = self.arrBankList[indexPath.row]
        cell.lblTitle.text = obj.strBankName
        if self.strMakeSelection == obj.strBankName{
            cell.imgCheck.image = #imageLiteral(resourceName: "active_check_box_ico")
            
        }else{
            cell.imgCheck.image = #imageLiteral(resourceName: "inactive_tick_ico")
        }
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    @objc func buttonClicked(sender:UIButton) {
        
        if self.arrBankList.count > 0 {
            
            let obj = self.arrBankList[sender.tag]
            self.objCommon = obj
            self.strMakeSelection =  obj.strBankName
            print("self.strCubanBankId is \(self.strCubanBankId)")
            print("sender.tag in make \(sender.tag)")
            self.tblBottom.reloadData()
        }
    }
}


/*
 //
 //  AddBankDetailVC.swift
 //  Qvafy
 //
 //  Created by ios-deepak b on 15/06/20.
 //  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
 //
 
 import UIKit
 
 class AddBankDetailVC: UIViewController , UINavigationControllerDelegate , UITextFieldDelegate, UIGestureRecognizerDelegate{
 //MARK: - Outlets
 
 @IBOutlet weak var vwBack: UIView!
 @IBOutlet weak var viewNext: UIView!
 @IBOutlet weak var viewImgNext: UIView!
 @IBOutlet weak var vwProgress: UIView!
 @IBOutlet weak var vwRound: UIView!
 @IBOutlet weak var vwNumber: UIView!
 @IBOutlet weak var vwBank: UIView!
 @IBOutlet weak var vwBlur: UIView!
 @IBOutlet weak var vwTable: UIView!
 @IBOutlet weak var txtAccountNo: UITextField!
 @IBOutlet weak var lblBank: UILabel!
 @IBOutlet weak var lblHeaderText: UILabel!
 @IBOutlet weak var lblProgress: UILabel!
 
 @IBOutlet weak var btnAdd: UIButton!
 @IBOutlet weak var btnSkip: UIButton!
 @IBOutlet weak var btnContinue: UIButton!
 
 // bottom sheet
 @IBOutlet weak var lblTableHeader: UILabel!
 @IBOutlet weak var tblBottom: UITableView!
 @IBOutlet weak var tblHeight: NSLayoutConstraint!
 @IBOutlet weak var tblBottomConstraint: NSLayoutConstraint!
 @IBOutlet weak var vwTableBottomConstraint: NSLayoutConstraint!
 
 
 @IBOutlet weak var imgToggle: UIImageView!
 @IBOutlet weak var vwAddBank: UIView!
 @IBOutlet weak var vwIsCuba: UIView!
 @IBOutlet weak var vwSelectBank: UIView!
 
 @IBOutlet weak var viewSkip: UIView!
 @IBOutlet weak var viewImgSkip: UIView!
 
 @IBOutlet weak var viewContinue: UIView!
 @IBOutlet weak var viewImgContinue: UIView!
 
 // localisation outlets -
 @IBOutlet weak var lblYouAreStep: UILabel!
 @IBOutlet weak var lblLOHeaderBankAccount: UILabel!
 @IBOutlet weak var lblLOHeaderDesc: UILabel!
 @IBOutlet weak var lblLOAreYourFromCUba: UILabel!
 @IBOutlet weak var lblLOBank: UILabel!
 @IBOutlet weak var lblLOCubanBankCard: UILabel!
 @IBOutlet weak var lblBankPalceHolder: UILabel!
 @IBOutlet weak var lblLOPleaseBankAccontDetails: UILabel!
 
 
 var objCommon:CommonModel?
 
 //MARK: - Variables
 
 
 
 var arrBankList:[CommonModel] = []
 var strMakeSelection = ""
 
 var isFromLogin:Bool = false
 
 
 var strCubanBankId:String = ""
 var strIsCubanBank:Int = 0
 
 
 //MARK: - Life Cycle
 
 override func viewDidLoad() {
 super.viewDidLoad()
 self.setUI()
 let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
 self.view.addGestureRecognizer(tap)
 tap.delegate = self
 
 self.callWsForGetContent()
 self.tblBottom.reloadData()
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
 self.vwAddBank.isHidden = false
 self.vwBank.isHidden = true
 //   self.creatDashedLine()
 
 self.vwSelectBank.setCornerRadiusQwafy(vw: self.vwSelectBank)
 self.vwNumber.setCornerRadiusQwafy(vw: self.vwNumber)
 self.viewNext.setButtonView(vwOuter : self.viewNext , vwImage : self.viewImgNext, btn: self.btnAdd )
 self.viewSkip.setButtonView(vwOuter : self.viewSkip , vwImage : self.viewImgSkip, btn: self.btnSkip)
 self.viewContinue.setButtonView(vwOuter : self.viewContinue , vwImage : self.viewImgContinue, btn: self.btnContinue)
 self.vwProgress?.layer.cornerRadius = (vwProgress?.frame.size.height)!/2.0
 self.vwProgress?.layer.masksToBounds = true
 self.vwRound.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 70.0)
 self.vwTable.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
 
 self.txtAccountNo.attributedPlaceholder = NSAttributedString(string: "Enter your card number".localize, attributes: [
 .foregroundColor: #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.737254902, alpha: 1) ,
 .font: UIFont(name: "Poppins-Medium", size: 15)
 ])
 
 self.viewSkip.isHidden = true
 }
 
 @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
 self.vwBlur.isHidden = true
 }
 
 //MARK: Create Dash Line
 func creatDashedLine(){
 let topPoint = CGPoint(x: self.vwIsCuba.bounds.minX, y: self.vwIsCuba.bounds.maxY)
 let bottomPoint = CGPoint(x: self.vwIsCuba.bounds.maxX, y: self.vwIsCuba.bounds.maxY)
 self.vwIsCuba.createDashedLine(from: topPoint, to: bottomPoint, color: .lightGray, strokeLength: 8, gapLength: 4, width: 0.5)
 
 
 }
 
 
 func textFieldShouldReturn(_ textField: UITextField) -> Bool {
 if textField == self.txtAccountNo{
 self.self.txtAccountNo.text = "xxxx xxxx xxxx"
 self.txtAccountNo.resignFirstResponder()
 }
 return true
 }
 
 //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
 //
 //           let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
 //           if textField == txtAccountNo{
 //               return checkAccountNumberFormat(string: string, str: str)
 //           }else{
 //               return true
 //           }
 //       }
 //
 //       func checkAccountNumberFormat(string: String?, str: String?) -> Bool{
 //           if string == ""{ //BackSpace
 //               return true
 //           }
 //           else if str!.count > 12{
 //               return false
 //        }
 //           return true
 //       }
 
 
 func validationForCubanBankInfo(){
 
 self.txtAccountNo.text = self.txtAccountNo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
 //   let strNumber = self.txtAccountNo.text?.count ?? 0
 
 
 
 if self.lblBank.text?.isEmpty == true{
 objAlert.showAlert(message: BlankBank.localize, title: kAlert.localize, controller: self)
 }else
 
 if self.txtAccountNo.text?.isEmpty == true{
 objAlert.showAlert(message: BlankCubanBankCard.localize, title: kAlert.localize, controller: self)
 }
 
 //            else if strNumber < 12{
 //            objAlert.showAlert(message: BlankCubanCardValidation, title: kAlert, controller: self)
 //        }
 
 //            else if !objValidationManager.isValidBankAccountNUmber(testStr: self.txtAccountNo.text ?? ""){
 //            objAlert.showAlert(message: ValidCubanBankCard, title: kAlert, controller: self)
 //        }
 else{
 // objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
 self.callWsForSetCubaBankAccount()
 }
 }
 
 
 func NavigateToAddBank(){
 let sb = UIStoryboard(name: "Main", bundle: nil)
 let detailVC = sb.instantiateViewController(withIdentifier: "AddBankAccountVC") as! AddBankAccountVC
 self.navigationController?.pushViewController(detailVC, animated: true)
 }
 
 
 func localization(){
 self.lblYouAreStep.text = "You_are_in_step_4".localize
 self.lblLOHeaderBankAccount.text = "Add_Bank_Details".localize
 self.lblLOHeaderDesc.text = "There_are_many_variations_of_passages_of_Lorem_Ipsum_available".localize
 self.lblLOAreYourFromCUba.text = "Are_you_from_Cuba_?".localize
 self.lblLOBank.text = "Bank".localize
 self.lblBankPalceHolder.text = "Select_bank".localize
 self.lblLOCubanBankCard.text = "Cuban_Bank_Card".localize
 self.lblLOPleaseBankAccontDetails.text = "Please_add_your_bank_account_details_for_receiving_payment".localize
 
 self.txtAccountNo.placeholder = "Enter your card number".localize
 self.btnAdd.setTitle("Add".localize, for: .normal)
 self.btnSkip.setTitle("Skip".localize, for: .normal)
 self.btnContinue.setTitle("Continue".localize, for: .normal)
 
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
 
 
 @IBAction func btnSelectBank(_ sender: UIButton) {
 self.view.endEditing(true)
 self.vwBlur.isHidden = false
 self.lblTableHeader.text = "Select_bank".localize
 self.tblBottom.reloadData()
 
 }
 
 
 @IBAction func btnIsCuba(_ sender: UIButton) {
 self.view.endEditing(true)
 
 if sender.isSelected == false{
 sender.isSelected = true
 self.imgToggle.image = #imageLiteral(resourceName: "ON_TOGGLE_ICO")
 self.vwAddBank.isHidden = true
 self.vwBank.isHidden = false
 self.strIsCubanBank = 1
 
 }else{
 sender.isSelected = false
 self.imgToggle.image = #imageLiteral(resourceName: "OFF_TOGGLE_ICO")
 
 self.vwBank.isHidden = true
 self.vwAddBank.isHidden = false
 self.strIsCubanBank = 0
 }
 
 }
 
 @IBAction func btnAddBank(_ sender: UIButton) {
 self.view.endEditing(true)
 
 if self.imgToggle.image == #imageLiteral(resourceName: "ON_TOGGLE_ICO") {
 self.validationForCubanBankInfo()
 }else{
 self.NavigateToAddBank()
 }
 
 }
 
 @IBAction func btnSkip(_ sender: UIButton) {
 self.view.endEditing(true)
 self.callWsForSkipButton()
 }
 @IBAction func btnCancle(_ sender: UIButton) {
 self.view.endEditing(true)
 self.vwBlur.isHidden = true
 
 }
 
 @IBAction func btnContinueAction(_ sender: UIButton) {
 self.view.endEditing(true)
 
 if  self.strMakeSelection == ""  {
 objAlert.showAlert(message: "Please_select_bank".localize, title: kAlert.localize, controller: self)
 
 }else{
 self.strCubanBankId = self.objCommon!.strCubaBankID
 self.lblBank.text = self.objCommon!.strBankName
 self.lblBankPalceHolder.isHidden = true
 self.vwBlur.isHidden = true
 
 }
 
 }
 
 }
 
 
 extension AddBankDetailVC {
 // TODO: Webservice For Get Content
 func callWsForGetContent(){
 
 if !objWebServiceManager.isNetworkAvailable(){
 //  objWebServiceManager.StopIndicator()
 objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
 return
 }
 //objWebServiceManager.StartIndicator()
 
 objWebServiceManager.requestGet(strURL: WsUrl.content ,Queryparams: nil, body: nil, strCustomValidation: "", success: {response in
 print(response)
 
 let status =   (response["status"] as? String)
 let message =  (response["message"] as? String)
 
 if status == "success"
 {
 let dict  = response["data"] as? [String:Any]
 
 if let arrBankListData = dict?["cuba_bank_list"] as? [[String:Any]]{
 
 self.arrBankList.removeAll()
 
 for dictBankData in arrBankListData
 {
 let objBankList = CommonModel.init(dict: dictBankData)
 
 self.arrBankList.append(objBankList)
 }
 }
 print("self.arrBankList.count is \(self.arrBankList.count)")
 
 self.tblBottom.reloadData()
 }else
 {
 objAlert.showAlert(message:message ?? "", title: "Alert".localize, controller: self)
 }
 }, failure: { (error) in
 print(error)
 // objWebServiceManager.StopIndicator()
 objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
 
 })
 
 }
 
 // TODO: Webservice For Skip Button
 
 func callWsForSkipButton(){
 
 if !objWebServiceManager.isNetworkAvailable(){
 objWebServiceManager.StopIndicator()
 objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
 return
 }
 objWebServiceManager.StartIndicator()
 
 var param: [String: Any] = [:]
 
 param = [
 WsParam.skipStep: "5"
 ] as [String : Any]
 
 print(param)
 
 objWebServiceManager.requestPost(strURL: WsUrl.skipStep, params: param, strCustomValidation: "", showIndicator: false, success: {response in
 print(response)
 objWebServiceManager.StopIndicator()
 let status =   (response["status"] as? String)
 let message =  (response["message"] as? String)
 
 if status == "success"{
 let dic  = response["data"] as? [String:Any]
 
 let user_details  = dic!["user_detail"] as? [String:Any]
 objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
 objAppShareData.fetchUserInfoFromAppshareData()
 objAppShareData.saveUserDetailsOnFireBase()
 objAppDelegate.observeProductMessages()
 self.NavigateToGuideVC()
 
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
 
 
 // TODO: Webservice For set Cuba Bank Account
 
 func callWsForSetCubaBankAccount(){
 
 if !objWebServiceManager.isNetworkAvailable(){
 objWebServiceManager.StopIndicator()
 objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
 return
 }
 objWebServiceManager.StartIndicator()
 
 var param: [String: Any] = [:]
 
 
 param = [
 WsParam.cubaBankId: self.strCubanBankId ,
 WsParam.cubaBankCard: self.txtAccountNo.text ?? ""
 ] as [String : Any]
 
 print(param)
 
 objWebServiceManager.requestPost(strURL: WsUrl.setCubBankAccount, params: param, strCustomValidation: "", showIndicator: false, success: {response in
 print(response)
 objWebServiceManager.StopIndicator()
 let status =   (response["status"] as? String)
 let message =  (response["message"] as? String)
 
 if status == "success"{
 let dic  = response["data"] as? [String:Any]
 
 let user_details  = dic!["user_detail"] as? [String:Any]
 objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
 objAppShareData.fetchUserInfoFromAppshareData()
 objAppShareData.saveUserDetailsOnFireBase()
 objAppDelegate.observeProductMessages()
 self.NavigateToGuideVC()
 
 }
 else
 {
 objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
 }
 
 }, failure: { (error) in
 print(error)
 objWebServiceManager.StopIndicator()
 objAlert.showAlert(message:kErrorMessage.localize, title:kAlert.localize, controller: self)
 
 })
 }
 
 
 func NavigateToGuideVC(){
 
 let sb = UIStoryboard(name: "Main", bundle: nil)
 let detailVC = sb.instantiateViewController(withIdentifier: "GuideVC") as! GuideVC
 self.navigationController?.pushViewController(detailVC, animated: true)
 }
 
 }
 
 extension AddBankDetailVC : UITableViewDelegate ,UITableViewDataSource {
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
 // self.tblHeight.constant = CGFloat((self.arrBankList.count * 44))
 return self.arrBankList.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "BasicInfoCell")as! BasicInfoCell
 
 let obj = self.arrBankList[indexPath.row]
 cell.lblTitle.text = obj.strBankName
 if self.strMakeSelection == obj.strBankName{
 cell.imgCheck.image = #imageLiteral(resourceName: "active_check_box_ico")
 
 }else{
 cell.imgCheck.image = #imageLiteral(resourceName: "inactive_check_box_ico")
 }
 cell.btnCheck.tag = indexPath.row
 cell.btnCheck.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
 
 return cell
 }
 
 func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
 self.viewWillLayoutSubviews()
 }
 
 @objc func buttonClicked(sender:UIButton) {
 
 let obj = self.arrBankList[sender.tag]
 
 self.objCommon = obj
 self.strMakeSelection =  obj.strBankName
 print("self.strCubanBankId is \(self.strCubanBankId)")
 print("sender.tag in make \(sender.tag)")
 self.tblBottom.reloadData()
 }
 
 }
 //
 //  AddBankDetailVC.swift
 //  Qvafy
 //
 //  Created by ios-deepak b on 15/06/20.
 //  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
 //
 
 import UIKit
 
 class AddBankDetailVC: UIViewController , UINavigationControllerDelegate , UITextFieldDelegate, UIGestureRecognizerDelegate{
 //MARK: - Outlets
 
 @IBOutlet weak var vwBack: UIView!
 @IBOutlet weak var viewNext: UIView!
 @IBOutlet weak var viewImgNext: UIView!
 @IBOutlet weak var vwProgress: UIView!
 @IBOutlet weak var vwRound: UIView!
 @IBOutlet weak var vwNumber: UIView!
 @IBOutlet weak var vwBank: UIView!
 @IBOutlet weak var vwBlur: UIView!
 @IBOutlet weak var vwTable: UIView!
 @IBOutlet weak var txtAccountNo: UITextField!
 @IBOutlet weak var lblBank: UILabel!
 @IBOutlet weak var lblHeaderText: UILabel!
 @IBOutlet weak var lblProgress: UILabel!
 
 @IBOutlet weak var btnAdd: UIButton!
 @IBOutlet weak var btnSkip: UIButton!
 @IBOutlet weak var btnContinue: UIButton!
 
 // bottom sheet
 @IBOutlet weak var lblTableHeader: UILabel!
 @IBOutlet weak var tblBottom: UITableView!
 @IBOutlet weak var tblHeight: NSLayoutConstraint!
 @IBOutlet weak var tblBottomConstraint: NSLayoutConstraint!
 @IBOutlet weak var vwTableBottomConstraint: NSLayoutConstraint!
 
 
 @IBOutlet weak var imgToggle: UIImageView!
 @IBOutlet weak var vwAddBank: UIView!
 @IBOutlet weak var vwIsCuba: UIView!
 @IBOutlet weak var vwSelectBank: UIView!
 
 @IBOutlet weak var viewSkip: UIView!
 @IBOutlet weak var viewImgSkip: UIView!
 
 @IBOutlet weak var viewContinue: UIView!
 @IBOutlet weak var viewImgContinue: UIView!
 
 // localisation outlets -
 @IBOutlet weak var lblYouAreStep: UILabel!
 @IBOutlet weak var lblLOHeaderBankAccount: UILabel!
 @IBOutlet weak var lblLOHeaderDesc: UILabel!
 @IBOutlet weak var lblLOAreYourFromCUba: UILabel!
 @IBOutlet weak var lblLOBank: UILabel!
 @IBOutlet weak var lblLOCubanBankCard: UILabel!
 @IBOutlet weak var lblBankPalceHolder: UILabel!
 @IBOutlet weak var lblLOPleaseBankAccontDetails: UILabel!
 
 
 var objCommon:CommonModel?
 
 //MARK: - Variables
 
 
 
 var arrBankList:[CommonModel] = []
 var strMakeSelection = ""
 
 var isFromLogin:Bool = false
 
 
 var strCubanBankId:String = ""
 var strIsCubanBank:Int = 0
 
 
 //MARK: - Life Cycle
 
 override func viewDidLoad() {
 super.viewDidLoad()
 self.setUI()
 let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
 self.view.addGestureRecognizer(tap)
 tap.delegate = self
 
 self.callWsForGetContent()
 self.tblBottom.reloadData()
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
 self.vwAddBank.isHidden = false
 self.vwBank.isHidden = true
 //   self.creatDashedLine()
 
 self.vwSelectBank.setCornerRadiusQwafy(vw: self.vwSelectBank)
 self.vwNumber.setCornerRadiusQwafy(vw: self.vwNumber)
 self.viewNext.setButtonView(vwOuter : self.viewNext , vwImage : self.viewImgNext, btn: self.btnAdd )
 self.viewSkip.setButtonView(vwOuter : self.viewSkip , vwImage : self.viewImgSkip, btn: self.btnSkip)
 self.viewContinue.setButtonView(vwOuter : self.viewContinue , vwImage : self.viewImgContinue, btn: self.btnContinue)
 self.vwProgress?.layer.cornerRadius = (vwProgress?.frame.size.height)!/2.0
 self.vwProgress?.layer.masksToBounds = true
 self.vwRound.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 70.0)
 self.vwTable.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
 
 self.txtAccountNo.attributedPlaceholder = NSAttributedString(string: "Enter your card number".localize, attributes: [
 .foregroundColor: #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.737254902, alpha: 1) ,
 .font: UIFont(name: "Poppins-Medium", size: 15)
 ])
 
 self.viewSkip.isHidden = true
 }
 
 @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
 self.vwBlur.isHidden = true
 }
 
 //MARK: Create Dash Line
 func creatDashedLine(){
 let topPoint = CGPoint(x: self.vwIsCuba.bounds.minX, y: self.vwIsCuba.bounds.maxY)
 let bottomPoint = CGPoint(x: self.vwIsCuba.bounds.maxX, y: self.vwIsCuba.bounds.maxY)
 self.vwIsCuba.createDashedLine(from: topPoint, to: bottomPoint, color: .lightGray, strokeLength: 8, gapLength: 4, width: 0.5)
 
 
 }
 
 
 func textFieldShouldReturn(_ textField: UITextField) -> Bool {
 if textField == self.txtAccountNo{
 self.self.txtAccountNo.text = "xxxx xxxx xxxx"
 self.txtAccountNo.resignFirstResponder()
 }
 return true
 }
 
 //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
 //
 //           let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
 //           if textField == txtAccountNo{
 //               return checkAccountNumberFormat(string: string, str: str)
 //           }else{
 //               return true
 //           }
 //       }
 //
 //       func checkAccountNumberFormat(string: String?, str: String?) -> Bool{
 //           if string == ""{ //BackSpace
 //               return true
 //           }
 //           else if str!.count > 12{
 //               return false
 //        }
 //           return true
 //       }
 
 
 func validationForCubanBankInfo(){
 
 self.txtAccountNo.text = self.txtAccountNo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
 //   let strNumber = self.txtAccountNo.text?.count ?? 0
 
 
 
 if self.lblBank.text?.isEmpty == true{
 objAlert.showAlert(message: BlankBank.localize, title: kAlert.localize, controller: self)
 }else
 
 if self.txtAccountNo.text?.isEmpty == true{
 objAlert.showAlert(message: BlankCubanBankCard.localize, title: kAlert.localize, controller: self)
 }
 
 //            else if strNumber < 12{
 //            objAlert.showAlert(message: BlankCubanCardValidation, title: kAlert, controller: self)
 //        }
 
 //            else if !objValidationManager.isValidBankAccountNUmber(testStr: self.txtAccountNo.text ?? ""){
 //            objAlert.showAlert(message: ValidCubanBankCard, title: kAlert, controller: self)
 //        }
 else{
 // objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
 self.callWsForSetCubaBankAccount()
 }
 }
 
 
 func NavigateToAddBank(){
 let sb = UIStoryboard(name: "Main", bundle: nil)
 let detailVC = sb.instantiateViewController(withIdentifier: "AddBankAccountVC") as! AddBankAccountVC
 self.navigationController?.pushViewController(detailVC, animated: true)
 }
 
 
 func localization(){
 self.lblYouAreStep.text = "You_are_in_step_4".localize
 self.lblLOHeaderBankAccount.text = "Add_Bank_Details".localize
 self.lblLOHeaderDesc.text = "There_are_many_variations_of_passages_of_Lorem_Ipsum_available".localize
 self.lblLOAreYourFromCUba.text = "Are_you_from_Cuba_?".localize
 self.lblLOBank.text = "Bank".localize
 self.lblBankPalceHolder.text = "Select_bank".localize
 self.lblLOCubanBankCard.text = "Cuban_Bank_Card".localize
 self.lblLOPleaseBankAccontDetails.text = "Please_add_your_bank_account_details_for_receiving_payment".localize
 
 self.txtAccountNo.placeholder = "Enter your card number".localize
 self.btnAdd.setTitle("Add".localize, for: .normal)
 self.btnSkip.setTitle("Skip".localize, for: .normal)
 self.btnContinue.setTitle("Continue".localize, for: .normal)
 
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
 
 
 @IBAction func btnSelectBank(_ sender: UIButton) {
 self.view.endEditing(true)
 self.vwBlur.isHidden = false
 self.lblTableHeader.text = "Select_bank".localize
 self.tblBottom.reloadData()
 
 }
 
 
 @IBAction func btnIsCuba(_ sender: UIButton) {
 self.view.endEditing(true)
 
 if sender.isSelected == false{
 sender.isSelected = true
 self.imgToggle.image = #imageLiteral(resourceName: "ON_TOGGLE_ICO")
 self.vwAddBank.isHidden = true
 self.vwBank.isHidden = false
 self.strIsCubanBank = 1
 
 }else{
 sender.isSelected = false
 self.imgToggle.image = #imageLiteral(resourceName: "OFF_TOGGLE_ICO")
 
 self.vwBank.isHidden = true
 self.vwAddBank.isHidden = false
 self.strIsCubanBank = 0
 }
 
 }
 
 @IBAction func btnAddBank(_ sender: UIButton) {
 self.view.endEditing(true)
 
 if self.imgToggle.image == #imageLiteral(resourceName: "ON_TOGGLE_ICO") {
 self.validationForCubanBankInfo()
 }else{
 self.NavigateToAddBank()
 }
 
 }
 
 @IBAction func btnSkip(_ sender: UIButton) {
 self.view.endEditing(true)
 self.callWsForSkipButton()
 }
 @IBAction func btnCancle(_ sender: UIButton) {
 self.view.endEditing(true)
 self.vwBlur.isHidden = true
 
 }
 
 @IBAction func btnContinueAction(_ sender: UIButton) {
 self.view.endEditing(true)
 
 if  self.strMakeSelection == ""  {
 objAlert.showAlert(message: "Please_select_bank".localize, title: kAlert.localize, controller: self)
 
 }else{
 self.strCubanBankId = self.objCommon!.strCubaBankID
 self.lblBank.text = self.objCommon!.strBankName
 self.lblBankPalceHolder.isHidden = true
 self.vwBlur.isHidden = true
 
 }
 
 }
 
 }
 
 
 extension AddBankDetailVC {
 // TODO: Webservice For Get Content
 func callWsForGetContent(){
 
 if !objWebServiceManager.isNetworkAvailable(){
 //  objWebServiceManager.StopIndicator()
 objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
 return
 }
 //objWebServiceManager.StartIndicator()
 
 objWebServiceManager.requestGet(strURL: WsUrl.content ,Queryparams: nil, body: nil, strCustomValidation: "", success: {response in
 print(response)
 
 let status =   (response["status"] as? String)
 let message =  (response["message"] as? String)
 
 if status == "success"
 {
 let dict  = response["data"] as? [String:Any]
 
 if let arrBankListData = dict?["cuba_bank_list"] as? [[String:Any]]{
 
 self.arrBankList.removeAll()
 
 for dictBankData in arrBankListData
 {
 let objBankList = CommonModel.init(dict: dictBankData)
 
 self.arrBankList.append(objBankList)
 }
 }
 print("self.arrBankList.count is \(self.arrBankList.count)")
 
 self.tblBottom.reloadData()
 }else
 {
 objAlert.showAlert(message:message ?? "", title: "Alert".localize, controller: self)
 }
 }, failure: { (error) in
 print(error)
 // objWebServiceManager.StopIndicator()
 objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
 
 })
 
 }
 
 // TODO: Webservice For Skip Button
 
 func callWsForSkipButton(){
 
 if !objWebServiceManager.isNetworkAvailable(){
 objWebServiceManager.StopIndicator()
 objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
 return
 }
 objWebServiceManager.StartIndicator()
 
 var param: [String: Any] = [:]
 
 param = [
 WsParam.skipStep: "5"
 ] as [String : Any]
 
 print(param)
 
 objWebServiceManager.requestPost(strURL: WsUrl.skipStep, params: param, strCustomValidation: "", showIndicator: false, success: {response in
 print(response)
 objWebServiceManager.StopIndicator()
 let status =   (response["status"] as? String)
 let message =  (response["message"] as? String)
 
 if status == "success"{
 let dic  = response["data"] as? [String:Any]
 
 let user_details  = dic!["user_detail"] as? [String:Any]
 objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
 objAppShareData.fetchUserInfoFromAppshareData()
 objAppShareData.saveUserDetailsOnFireBase()
 objAppDelegate.observeProductMessages()
 self.NavigateToGuideVC()
 
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
 
 
 // TODO: Webservice For set Cuba Bank Account
 
 func callWsForSetCubaBankAccount(){
 
 if !objWebServiceManager.isNetworkAvailable(){
 objWebServiceManager.StopIndicator()
 objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
 return
 }
 objWebServiceManager.StartIndicator()
 
 var param: [String: Any] = [:]
 
 
 param = [
 WsParam.cubaBankId: self.strCubanBankId ,
 WsParam.cubaBankCard: self.txtAccountNo.text ?? ""
 ] as [String : Any]
 
 print(param)
 
 objWebServiceManager.requestPost(strURL: WsUrl.setCubBankAccount, params: param, strCustomValidation: "", showIndicator: false, success: {response in
 print(response)
 objWebServiceManager.StopIndicator()
 let status =   (response["status"] as? String)
 let message =  (response["message"] as? String)
 
 if status == "success"{
 let dic  = response["data"] as? [String:Any]
 
 let user_details  = dic!["user_detail"] as? [String:Any]
 objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
 objAppShareData.fetchUserInfoFromAppshareData()
 objAppShareData.saveUserDetailsOnFireBase()
 objAppDelegate.observeProductMessages()
 self.NavigateToGuideVC()
 
 }
 else
 {
 objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
 }
 
 }, failure: { (error) in
 print(error)
 objWebServiceManager.StopIndicator()
 objAlert.showAlert(message:kErrorMessage.localize, title:kAlert.localize, controller: self)
 
 })
 }
 
 
 func NavigateToGuideVC(){
 
 let sb = UIStoryboard(name: "Main", bundle: nil)
 let detailVC = sb.instantiateViewController(withIdentifier: "GuideVC") as! GuideVC
 self.navigationController?.pushViewController(detailVC, animated: true)
 }
 
 }
 
 extension AddBankDetailVC : UITableViewDelegate ,UITableViewDataSource {
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
 // self.tblHeight.constant = CGFloat((self.arrBankList.count * 44))
 return self.arrBankList.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "BasicInfoCell")as! BasicInfoCell
 
 let obj = self.arrBankList[indexPath.row]
 cell.lblTitle.text = obj.strBankName
 if self.strMakeSelection == obj.strBankName{
 cell.imgCheck.image = #imageLiteral(resourceName: "active_check_box_ico")
 
 }else{
 cell.imgCheck.image = #imageLiteral(resourceName: "inactive_check_box_ico")
 }
 cell.btnCheck.tag = indexPath.row
 cell.btnCheck.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
 
 return cell
 }
 
 func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
 self.viewWillLayoutSubviews()
 }
 
 @objc func buttonClicked(sender:UIButton) {
 
 let obj = self.arrBankList[sender.tag]
 
 self.objCommon = obj
 self.strMakeSelection =  obj.strBankName
 print("self.strCubanBankId is \(self.strCubanBankId)")
 print("sender.tag in make \(sender.tag)")
 self.tblBottom.reloadData()
 }
 
 }
 
 */
