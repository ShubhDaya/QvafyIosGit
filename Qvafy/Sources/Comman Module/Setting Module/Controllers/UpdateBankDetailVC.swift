//
//  UpdateBankDetailVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 29/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

 import UIKit

class UpdateBankDetailVC: UIViewController , UINavigationControllerDelegate , UITextFieldDelegate, UIGestureRecognizerDelegate{
    //MARK: - Outlets
    
    @IBOutlet weak var viewNext: UIView!
    @IBOutlet weak var viewImgNext: UIView!
    @IBOutlet weak var vwNumber: UIView!
    @IBOutlet weak var vwBank: UIView!
    @IBOutlet weak var vwBlur: UIView!
    @IBOutlet weak var vwTable: UIView!
    @IBOutlet weak var txtAccountNo: UITextField!
    @IBOutlet weak var lblBank: UILabel!
    @IBOutlet weak var lblBankPalceHolder: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnContinue: UIButton!

    // bottom sheet
    @IBOutlet weak var lblTableHeader: UILabel!
    @IBOutlet weak var tblBottom: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var vwTableBottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var imgToggle: UIImageView!
    @IBOutlet weak var vwAddBank: UIView!
    @IBOutlet weak var vwIsCuba: UIView!
    @IBOutlet weak var vwSelectBank: UIView!
  
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var viewImgContinue: UIView!
  
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var vwHeader: UIView!
    
    // localisation Outlets -
    @IBOutlet weak var lblLoOHeaderAddBankDetails: UILabel!
    @IBOutlet weak var lblLOAreYouCuba: UILabel!
    @IBOutlet weak var lblLOBank: UILabel!
    @IBOutlet weak var lblLOCubanBankCard: UILabel!
    @IBOutlet weak var lblLOPleaseAddBankDesc: UILabel!
    //MARK: - Variables
    
    var strURL: String = ""
    var strHeaderText: String = ""
    var objCommon:CommonModel?
    var arrBankList:[CommonModel] = []
    var strMakeSelection = ""
    var isFromLogin:Bool = false
    var strCubanBankId:String = ""
    var strIsCubanBank:Int = 0
    
    
    var strHoldBankId:String = ""
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localization()
        self.vwHeader.setviewbottomShadow()
        self.vwAddBank.isHidden = true
        self.vwIsCuba.isHidden = true
        self.vwBank.isHidden = false
        self.callWsForGetContent()
        self.setData()
    }
    
    //MARK: - Functions
    func setUI(){
        self.vwBlur.isHidden = true
//      self.vwAddBank.isHidden = false
//      self.vwBank.isHidden = true
        self.vwSelectBank.setCornerRadiusQwafy(vw: self.vwSelectBank)
        self.vwNumber.setCornerRadiusQwafy(vw: self.vwNumber)
        self.viewNext.setButtonView(vwOuter : self.viewNext , vwImage : self.viewImgNext, btn: self.btnAdd )
        self.viewContinue.setButtonView(vwOuter : self.viewContinue , vwImage : self.viewImgContinue, btn: self.btnContinue)
        self.vwTable.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
                
        self.txtAccountNo.attributedPlaceholder = NSAttributedString(string: "Enter your card number".localize, attributes: [
               .foregroundColor: #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.737254902, alpha: 1) ,
            .font: UIFont(name: "Poppins-Medium", size: 13.3)
        ])
       
    }
//    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
//           self.vwBlur.isHidden = true
//       }
    
    func setData(){
        if objAppShareData.UserDetail.strIsUserCuba == "0"{
            self.lblHeader.text = "Add_Bank_Details".localize
            self.btnAdd.setTitle(
                "Add".localize, for: .normal)
            self.lblBankPalceHolder.isHidden = false
        }else {
            self.lblHeader.text = "Update_Bank_Details".localize
            self.btnAdd.setTitle("Update".localize, for: .normal)
            self.txtAccountNo.text = objAppShareData.UserDetail.strCubaBankCard
            self.lblBankPalceHolder.isHidden = true
            
            let id = objAppShareData.UserDetail.strCubaBankId
            for obj in self.arrBankList{
                if  obj.strCubaBankID == id {
                    self.lblBank.text = obj.strBankName
                    self.strMakeSelection = obj.strBankName
                    self.strCubanBankId = obj.strCubaBankID
                    print("obj.strBankName is \(obj.strBankName)")
                }
            }
        }
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
      //  let strNumber = self.txtAccountNo.text?.count ?? 0
        
        
        if self.lblBank.text?.isEmpty == true{
            objAlert.showAlert(message: BlankBank.localize, title: kAlert.localize, controller: self)
        }else
            
            if self.txtAccountNo.text?.isEmpty == true{
            objAlert.showAlert(message: BlankCubanBankCard.localize, title: kAlert.localize, controller: self)
        }
            
        else{
            // objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
             self.callWsForSetCubaBankAccount()
        }
        
    }
    
    
    func NavigateToAddBank(){
        let sb = UIStoryboard(name: "Setting", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "UpdateBankAccountVC") as! UpdateBankAccountVC
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func localization(){
        self.lblLoOHeaderAddBankDetails.text = "Add_Bank_Details".localize
        self.lblLOBank.text = "Bank".localize
        self.lblLOCubanBankCard.text = "Cuban_Bank_Card".localize
        self.lblBankPalceHolder.text = "Select_bank".localize
        self.lblLOAreYouCuba.text = "Are_you_from_Cuba_?".localize
        self.lblLOPleaseAddBankDesc.text = "Please_add_your_bank_account_details_for_receiving_payment".localize
        self.txtAccountNo.placeholder = "Enter_account_number".localize
       
        self.btnAdd.setTitle("Add".localize, for: .normal)
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
        var id = ""
        if self.strCubanBankId != "" {
             id = self.strCubanBankId
        }else{
             id = objAppShareData.UserDetail.strCubaBankId
        }
        
       
        for obj in self.arrBankList{
            if  obj.strCubaBankID == id {
                self.lblBank.text = obj.strBankName
                self.strMakeSelection = obj.strBankName
                self.strCubanBankId = obj.strCubaBankID
                print("obj.strBankName is \(obj.strBankName)")
            }
        }
        self.tblBottom.reloadData()
    }
    
    
    @IBAction func btnIsCuba(_ sender: UIButton) {
        self.view.endEditing(true)
        
    }
    
    @IBAction func btnAddBank(_ sender: UIButton) {
           self.view.endEditing(true)
              self.validationForCubanBankInfo()
       }
    
    @IBAction func btnCancle(_ sender: UIButton) {
        self.view.endEditing(true)
        self.strMakeSelection = ""
        self.objCommon = nil
        self.vwBlur.isHidden = true
        
//       let id = objAppShareData.UserDetail.strCubaBankId
//
//     for obj in self.arrBankList{
//       if  obj.strCubaBankID == id {
//           self.lblBank.text = obj.strBankName
//           self.strMakeSelection = obj.strBankName
//           self.strCubanBankId = obj.strCubaBankID
//           print("obj.strBankName is \(obj.strBankName)")
//       }
//   }
        
//        var id = ""
//        if self.strCubanBankId != "" {
//             id = self.strCubanBankId
//        }else{
//             id = objAppShareData.UserDetail.strCubaBankId
//        }
        
        let id = self.strCubanBankId
        for obj in self.arrBankList{
            if  obj.strCubaBankID == id {
                self.lblBank.text = obj.strBankName
                self.strMakeSelection = obj.strBankName
                self.strCubanBankId = obj.strCubaBankID
                print("obj.strBankName is \(obj.strBankName)")
            }
        }
        self.tblBottom.reloadData()
        
        
    }
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
       // self.vwBlur.isHidden = true
        print(self.strMakeSelection)
         if  self.strMakeSelection == ""  {
            objAlert.showAlert(message: "Please_select_bank".localize, title: kAlert.localize, controller: self)
             
         }else{

            print(self.strMakeSelection)

            self.lblBank.text = self.strMakeSelection
            self.strCubanBankId = self.strHoldBankId
            
            print(self.lblBank.text)
                    self.lblBankPalceHolder.isHidden = true
                    self.vwBlur.isHidden = true
       //     self.tblBottom.reloadData()
            }
    }
}


extension UpdateBankDetailVC {
    // TODO: Webservice For Get Content
    func callWsForGetContent(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        objWebServiceManager.requestGet(strURL: WsUrl.content ,Queryparams: nil, body: nil, strCustomValidation: "", success: {response in
            print(response)
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            objWebServiceManager.StopIndicator()

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
                    self.setData()
                }
               print("self.arrBankList.count is \(self.arrBankList.count)")

                self.tblBottom.reloadData()
          
            }else
            {
                objAlert.showAlert(message:message ?? "", title:kAlert.localize, controller: self)
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

                self.updateAlert(msg: "Update_bank_detail_successfully".localize)


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

extension UpdateBankDetailVC : UITableViewDelegate ,UITableViewDataSource {
    
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
        
        if self.arrBankList.count > 0 {
        
        let obj = self.arrBankList[sender.tag]
        self.objCommon = obj
       
        self.strMakeSelection =  obj.strBankName
//        self.strCubanBankId = obj.strCubaBankID
//        print("self.strCubanBankId is \(self.strCubanBankId)")
        
        self.strHoldBankId = obj.strCubaBankID
        print("self.strHoldBankId is \(self.strHoldBankId)")
        print("sender.tag in make \(sender.tag)")
        self.tblBottom.reloadData()
        }
    }
}



