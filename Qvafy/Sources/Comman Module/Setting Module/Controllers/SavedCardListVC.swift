//
//  SavedCardListVC.swift
//  Qvafy
//
//  Created by IOS-Shubham-40 on 25/03/21.
//  Copyright © 2021 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import UIKit
import Stripe
class SavedCardListVC: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var vwImgDone: UIView!
    @IBOutlet weak var vwAddCard: UIView!
    @IBOutlet weak var vwImgAddCard: UIView!
    @IBOutlet weak var tblCardList: UITableView!
    @IBOutlet weak var tblHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnAddCard: UIButton!
    @IBOutlet weak var lblNoCard: UILabel!
    
    @IBOutlet weak var vwTable: UITableView!
    @IBOutlet weak var vwNoData: UIView!

    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwBlur: UIView!
    @IBOutlet weak var viewCardDetail: UIView!
    @IBOutlet weak var txtCardHolderName: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtExpiryDate: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var vwCardHolderName: UIView!
    @IBOutlet weak var vwCardNumber: UIView!
    @IBOutlet weak var vwExpiryDate: UIView!
    @IBOutlet weak var vwCVV: UIView!
    @IBOutlet weak var viewDatePicker: UIView!
    @IBOutlet weak var picker_monthYear: UIPickerView!
    @IBOutlet var btnBackOnHeader: UIButton!
    // localisation outlets-
    
    @IBOutlet weak var imgAddnewCardLocalize: UIImageView!
    @IBOutlet weak var lblLOPaymentMethod: UILabel!
    @IBOutlet weak var lblLONOCardHere: UILabel!
    @IBOutlet weak var lblLOAddNewCard: UILabel!
    @IBOutlet weak var lblLOCardHolderName: UILabel!
    @IBOutlet weak var lblLOCardNumber: UILabel!
    @IBOutlet weak var lblLOCVV: UILabel!
    @IBOutlet weak var lblLOExpiry: UILabel!
    @IBOutlet weak var lblLOExpirydate: UILabel!
    //MARK: - Variables

    var arrCardList:[CardListModel] = []
    
     var MONTH = 0
     var YEAR = 1
     var selectedMonthName = ""
     var selectedyearName = ""
     var months = [Any]()
     var years = [Any]()
     var minYear: Int = 0
     var maxYear: Int = 0
     var rowHeight: Int = 0
     
     var strMonth = ""
     var strYear = ""
     var stripeToken:String = ""
     
     var strCardId = ""
     var strCardBrand = ""
     var strLastDigit = ""
      var strId = ""
    
    var strPaymentMethod = ""
    var closerGetCardId:((_ isClearList:Bool)   ->())?

    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwBlur.isHidden = true
        self.loadDefaultsParameters()
        self.viewDatePicker.isHidden = true
        self.lblNoCard.isHidden = true
        self.vwCardHolderName.setCornerRadiusQwafy(vw: self.vwCardHolderName)
        self.vwCardNumber.setCornerRadiusQwafy(vw: self.vwCardNumber)
        self.vwExpiryDate.setCornerRadiusQwafy(vw: self.vwExpiryDate)
        self.vwCVV.setCornerRadiusQwafy(vw: self.vwCVV)
        self.vwAddCard.setButtonView(vwOuter : self.vwAddCard , vwImage : self.vwImgAddCard, btn: self.btnAddCard )
        self.viewCardDetail.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localisation()
        self.vwHeader.setviewbottomShadow()
        
//        if  objAppShareData.isFromCartList == true {
//            print(" is From CartListVC ")
//            self.strId = objAppShareData.strCardId
//        }else{
//            print(" is From mapVC ")
//        }
       // self.strId = objAppShareData.strCardId

        
        if self.arrCardList.count == 0 {
            self.tblCardList.isHidden = true
            self.lblNoCard.isHidden = false
        }else{
            self.lblNoCard.isHidden = true
            self.tblCardList.isHidden = false
        }
        self.callWsForCardList()
        self.tblCardList.reloadData()
    }
    
    func localisation(){
        self.imgAddnewCardLocalize.image = UIImage(named: "Add_new_card_img".localize)
        self.lblLOPaymentMethod.text = "Saved Card".localize
        self.lblLONOCardHere.text = "No_card_available.".localize
        self.lblLOAddNewCard.text = "Add_New_Card".localize
        self.lblLOCardHolderName.text = "Card_Holder_Name".localize
        self.lblLOCardNumber.text = "Card_Number".localize
        self.lblLOCVV.text = "CVV".localize
        self.lblLOExpiry.text = "Expiry".localize
        self.lblLOExpirydate.text = "Expiry_Date".localize

        self.txtCardNumber.placeholder =  "Enter_card_number".localize
        self.txtExpiryDate.placeholder =  "MM/YY".localize
        self.txtCardHolderName.placeholder =  "Enter_card_holder_name".localize

        self.btnAddCard.setTitle("Add_Card".localize, for: .normal)
    
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
           self.view.endEditing(true)
           self.navigationController?.popViewController(animated: true)
       }

    @IBAction func btnAddNewCard(_ sender: UIButton) {
        self.view.endEditing(true)
        self.loadDefaultsParameters()
        self.vwBlur.isHidden = false
    }
    
    @IBAction func btnAddCard(_ sender: UIButton) {
        self.view.endEditing(true)
        self.validationForCardDetail()

    }
    @IBAction func btnDone(_ sender: UIButton) {
        self.view.endEditing(true)

//        if  objAppShareData.isFromCartList == true {
//
//
//            if self.strId != ""{
//                         objAppShareData.strPaymentMethod = "2"
//                        objAppShareData.strCardId = self.strId
//                        print(" from card list")
//                if objAppShareData.isFromWallet == true {
//                    self.closerGetCardId?(true)
//                    objAppShareData.isFromWallet = false
//                }
//                objAppShareData.isFromCartList = false // new
//                self.navigationController?.popViewController(animated: false)
//
//                    } else {
//                        objAlert.showAlert(message: "\("Please_select_any_card".localize) ", title: kAlert.localize,controller: self)
//                    }
//
//        } else {
//
//
//        if self.strId != ""{
//            self.strPaymentMethod = "2"
//
//            print(" from card list")
//             self.callWsForBookRide()
//
//        }else{
//
//            objAlert.showAlert(message: "Please_select_atleast_one_option".localize, title: kAlert.localize, controller: self)
//
//
//        }
//        }
        
        
//                if self.strId != ""{
//                    self.strPaymentMethod = "2"
//
//                    print(" from card list")
//                   //  self.callWsForBookRide()
//
//                }else{
//
//                    objAlert.showAlert(message: "Please_select_atleast_one_option".localize, title: kAlert.localize, controller: self)
//
//
//                }
        
        
    }
    
    @IBAction func btnCancle(_ sender: UIButton) {
        self.view.endEditing(true)
        self.txtCardHolderName.text = ""
        self.txtCardNumber.text = ""
        self.txtCVV.text = ""
        self.txtExpiryDate.text = ""
        self.vwBlur.isHidden = true

    }
   
    
    func changeDateformat(strDate:String)-> String{
           let dateformatter = DateFormatter()
        dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
           dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
           dateformatter.timeZone = NSTimeZone(name: "UTC") as TimeZone? // new
           let date1 = dateformatter.date(from: strDate)
            dateformatter.timeZone = TimeZone.current // new
           let strDate = date1?.strrigWithFormat(format: "d MMM yyyy") ?? ""
           return strDate
       }
}



extension SavedCardListVC : UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
         self.tblHeightConstraint.constant = CGFloat((self.arrCardList.count * 100))
        return self.arrCardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCardListCell")as! SavedCardListCell
        
        let obj = self.arrCardList[indexPath.row]
        
        cell.lblCardNumber.text = "xxxx " + "xxxx " + "xxxx " + (obj.strCardLast4 )
            
            
            if obj.strCreatedAt != ""{
                let date = self.changeDateformat(strDate: obj.strCreatedAt )
              //  let date = objAppShareData.convertLocalTime(strDateTime: obj.strCreatedAt ?? "")
                cell.lblCardAddDate.text = "\("Added_on".localize) \(date)"
            }
            
//        if self.strId == obj.strStripeCardId {
//            cell.imgCheck.image = #imageLiteral(resourceName: <#T##String#>)
//            //self.imgCod.image = #imageLiteral(resourceName: "deselect_ico")
//
//        }else{
//
//            cell.imgCheck.image = #imageLiteral(resourceName: "deselect_ico")
//        }
            switch obj.strBrand {
            case "Visa":
                cell.imgVwCardType.image = #imageLiteral(resourceName: "visa_ico")
            case "MasterCard":
                cell.imgVwCardType.image = #imageLiteral(resourceName: "mastercard_ico")
            case "AmericanExpress":
                cell.imgVwCardType.image = #imageLiteral(resourceName: "americam_ico")
            default: break
               // cell.imgVwCardType.image = #imageLiteral(resourceName: "americam_ico")
            }
            
        cell.btnDeleteCard.tag = indexPath.row
        cell.btnDeleteCard.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
                
        return cell
    }
    
    @objc func buttonClicked(sender:UIButton) {
        
        if self.arrCardList.count > 0 {
          
        let obj = self.arrCardList[sender.tag]
               //self.strId = obj.strCardID
        let cardId = obj.strCardID
        objAlert.showAlertCallBack(alertLeftBtn: "Cancel".localize, alertRightBtn: "OK", title: kAlert.localize, message: "Are_you_sure_you_want_to_delete_this_card?".localize, controller: self) {
            self.callWebForDeleteCard(CardID: cardId)

        }
             // self.tblCardList.reloadData()
        }
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        let obj = arrCardList[indexPath.row]
//        self.strId = obj.strUserID
//
//        self.tblCardList.reloadData()
    }
}



//MARK: - Extension Picker View

extension SavedCardListVC : UIPickerViewDelegate,UIPickerViewDataSource {
    
        //MARK: - Functions
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == self.txtCardHolderName{
                self.viewDatePicker.isHidden = true
               // self.txtCardHolderName.resignFirstResponder()
                self.txtCardNumber.becomeFirstResponder()
            }else if textField == self.txtCardNumber{
              //  self.txtCardNumber.resignFirstResponder()
                self.viewDatePicker.isHidden = false
            }else if textField == self.txtExpiryDate{
             //   self.txtExpiryDate.resignFirstResponder()
                self.txtCVV.becomeFirstResponder()
                self.viewDatePicker.isHidden = false
            }
            else if textField == self.txtCVV{
                self.viewDatePicker.isHidden = true
                self.txtCVV.resignFirstResponder()
            }
            return true
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            // YOU SHOULD FIRST CHECK FOR THE BACKSPACE. IF BACKSPACE IS PRESSED ALLOW IT
            
            if string == "" {
                return true
            }
            
            if textField == txtCardHolderName{
               let maxLength = 30
               let currentString: NSString = textField.text! as NSString
               let newString: NSString =
                   currentString.replacingCharacters(in: range, with: string) as NSString
               if newString.length == 31{
                //txtCardHolderName.resignFirstResponder()
               }
               return newString.length <= maxLength
           }else
            if textField == self.txtCardNumber{
                if self.txtCardNumber.text?.count ?? 0 >= 16{
                    // RESIGN FIRST RERSPONDER TO HIDE KEYBOARD
                   // self.txtCardNumber.resignFirstResponder()
                    return false
                }
            }
            else if textField == self.txtCVV{
                if self.txtCVV.text?.count ?? 0 >= 3 {
                    self.txtCVV.resignFirstResponder()
                   // return false
                }
            }
            return true
        }
        
        func showPicker() {
            view.endEditing(true)
            picker_monthYear.reloadAllComponents()
        }
        
        func validationForCardDetail(){
            if self.txtCardHolderName.text?.isEmpty == true{
                objAlert.showAlert(message: CardHolderName.localize, title: kAlert.localize, controller: self)

            }
            else if self.txtCardHolderName.text?.count ?? 0 < 3{
                objAlert.showAlert(message: CardValidationHolderName.localize, title: kAlert.localize, controller: self)

            }
            else if  !objValidationManager.isNameString(nameStr: self.txtCardHolderName.text!)
            {
                objAlert.showAlert(message: "Only_alphabeticals_allowed_in_holder_name".localize, title: kAlert.localize, controller: self)

                
            }
            else if self.txtCardNumber.text?.isEmpty == true{
                objAlert.showAlert(message: CardNumber.localize, title: kAlert.localize, controller: self)

                
            }
            else if (txtCardNumber.text?.count)! < 16 || (txtCardNumber.text?.count)! > 18{
               objAlert.showAlert(message: CardValidationNumber.localize, title: kAlert.localize, controller: self)

                
            }
           else if self.txtExpiryDate.text?.isEmpty == true{
               objAlert.showAlert(message: CardExpiryDate.localize, title: kAlert.localize, controller: self)

                
            }else if self.txtCVV.text?.isEmpty == true{
             objAlert.showAlert(message: CardCVV.localize, title: kAlert.localize, controller: self)

                
            }
            else if (txtCVV.text?.count)! < 3 || (txtCVV.text?.count)! > 4
                   {
                    
                    objAlert.showAlert(message: CardValidationCVV.localize, title: kAlert.localize, controller: self)

                   }
            else{
                    self.getStripeToken()
            }
        }
    
    
    @IBAction func btnPickerDoneAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.viewDatePicker.isHidden = true
        
        if selectedMonthName.count > 0 && selectedyearName.count > 0
        {
            let str = "\(selectedMonthName)/\(selectedyearName)"
            txtExpiryDate.text = str
            print(str)
            self.strMonth = "\(selectedMonthName)"
            self.strYear = "\(selectedyearName)"
        }
        self.txtCVV.becomeFirstResponder()
    }
    
    @IBAction func btnPickerCancelAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.viewDatePicker.isHidden = true
    }
    
    @IBAction func btnOpenDatePicker(_ sender: Any) {
        self.view.endEditing(true)
        self.viewDatePicker.isHidden = false
        self.txtCardHolderName.resignFirstResponder()
        self.txtCardNumber.resignFirstResponder()
        self.txtCVV.resignFirstResponder()
        self.loadDefaultsParameters()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.view.endEditing(true)
        
        
        if component == MONTH {
            return months.count
        }
        else {
            return years.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if component == MONTH {
            let monthName: String = months[row] as! String
            return monthName
        }
        else {
            let yearName: String = years[row] as! String
            let str = "\(yearName)"
            return str
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.view.endEditing(true)
        if component == self.MONTH {
            selectedMonthName = months[row] as! String
        }
        else {
            let str = "\(years[row])"
            if (str.count ) > 2 {
                let strLastTwoDigits: String! = (str as? NSString)?.substring(from: (str.count ) - 2)
                selectedyearName = strLastTwoDigits!
            }
        }
    }
    
    
//    func loadDefaultsParameters() {
//        let components: DateComponents? = Calendar.current.dateComponents([.day, .month, .year], from: Date())
//        let year: Int? = components?.year
//        minYear = year!
//        maxYear = year! + 30
//        rowHeight = 44
//        months = nameOfMonths()
//        years = nameOfYears()
//        picker_monthYear.delegate = self
//        picker_monthYear.dataSource = self
//        let str = "\(Int(year!))"
//        if (str.count ) > 2 {
//            let strLastTwoDigits: String = ((str as? NSString)?.substring(from: (str.count ) - 2))!
//            selectedyearName = strLastTwoDigits
//        }
//        selectedMonthName = "01"
//    }
    
    
    func loadDefaultsParameters() {
            let components: DateComponents? = Calendar.current.dateComponents([.day, .month, .year], from: Date())
            let year: Int? = components?.year
            minYear = year!
            maxYear = year! + 30
            rowHeight = 44
            months = nameOfMonths()
            years = nameOfYears()
            picker_monthYear.delegate = self
            picker_monthYear.dataSource = self
            let str = "\(Int(year!))"
            if (str.count ) > 2 {
                let strLastTwoDigits: String = ((str as? NSString)?.substring(from: (str.count ) - 2))!
                selectedyearName = strLastTwoDigits
            }
            
            var month = String(components?.month ?? 0)
            
            if month.count == 1{
                month = "0" + month
            }
            //selectedMonthName = month
            
        if let arrDate = self.txtExpiryDate.text?.components(separatedBy: "/") {


            let index = months.firstIndex(where: { (item) -> Bool in

                item as! String == arrDate[0] ?? month // test if this is the item you're looking for
            })
            let intMonth = Int(month) ?? 0
            let newMonthInt = intMonth - 1
            selectedMonthName = String(intMonth)
            self.picker_monthYear.selectRow((index ?? newMonthInt), inComponent: 0, animated: false)
            
        }
        
        let indexY = years.firstIndex(where: { (item) -> Bool in
            item as! String == strYear// test if this is the item you're looking for
        })
        self.picker_monthYear.selectRow(indexY ?? 0, inComponent: 1, animated: false)
        
        
            
            if self.txtExpiryDate.text != ""   {

                if let arrDate = self.txtExpiryDate.text?.components(separatedBy: "/") {

                let index = months.firstIndex(where: { (item) -> Bool in

                    item as! String == arrDate[0] ?? month // test if this is the item you're looking for
                })
                selectedMonthName = arrDate[0] ?? month
                let intMonth = Int(month) ?? 0
                let newMonthInt = intMonth - 1

                self.picker_monthYear.selectRow((index ?? newMonthInt), inComponent: 0, animated: false)

                selectedyearName = arrDate[1]
                    
                print("year",arrDate[1])

                var strYear = ""

                if arrDate[1] != "" {
                    strYear = "20" + arrDate[1]
                }else {
                    strYear = "20" + selectedyearName
                }
             

                let indexY = years.firstIndex(where: { (item) -> Bool in
                    item as! String == strYear// test if this is the item you're looking for
                })
                self.picker_monthYear.selectRow(indexY ?? 0, inComponent: 1, animated: false)
            }
       }
        
    }
        
    
    func nameOfMonths() -> [Any] {
        return ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    }
    
    func nameOfYears() -> [Any] {
        var years = [AnyHashable]()
        for year in minYear...maxYear {
            let yearStr = "\(Int(year))"
            years.append(yearStr)
        }
        return years
    }
    
    // deepak new work
    func resetPicker(){
    let components: DateComponents? = Calendar.current.dateComponents([.day, .month, .year], from: Date())
    let year: Int? = components?.year
       self.minYear = year!
//        selectedMonthName = "01"
        
//        var selectedMonthName = ""
//        var selectedyearName = ""
//
//        self.picker_monthYear.y = year!
//        self.picker_monthYear.maximumDate = "01"
//
        
//        var months = [Any]()
//        var years = [Any]()
        
//        return months = year!
//        return years = "01"
//        picker_monthYear.reloadAllComponents()
}
// deepak new work
}

//MARK: - Api for Stripe Card
extension SavedCardListVC{
    
    func getStripeToken(){

         if !objWebServiceManager.isNetworkAvailable(){
                     objWebServiceManager.StopIndicator()
                   objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
                   return
               }
        objWebServiceManager.StartIndicator()
        let stripCard = STPCardParams()

        let expM = self.strMonth
        let expY = self.strYear

        let expMonth = UInt(expM)
        let expYear = UInt(expY)

        // Send the card info to Strip to get the token
        stripCard.number = self.txtCardNumber.text!
        stripCard.cvc = self.txtCVV.text!
        stripCard.expMonth = expMonth!
        stripCard.expYear = expYear!
        stripCard.name = self.txtCardHolderName.text ?? ""

        STPAPIClient.shared().createToken(withCard: stripCard) { (token: STPToken?, error: Error?) in
            
            print(error)
            guard let token = token, error == nil else {
                // Present error to user...
                // objAppShareData.showAlert(title: "Alert", message: "Your card details are not valid", view: self)
                objAlert.showAlert(message: "Your_card_details_are_not_valid".localize, title: kAlert.localize, controller: self)

                 objWebServiceManager.StopIndicator()
                return
            }
            print(token.tokenId)
            // self.dictPayData["stripe_token"] = token.tokenId
            self.stripeToken = token.tokenId
            print("self.stripeToken is \(self.stripeToken)")
            self.callWebServiceFor_CreateCard()
        }
    }
    
        func callWebServiceFor_CreateCard(){
        
            self.view.endEditing(true)
            let param = ["source":self.stripeToken] as [String : AnyObject]
            
//            let strStripe_Id = UserDefaults.standard.string(forKey: UserDefaults.Keys.customerStripeID)
            let strStripe_Id = objAppShareData.UserDetail.strStripeCustomerId

            
            let url = "https://api.stripe.com/v1/customers" + "/" + strStripe_Id + "/sources"
            
            objWebServiceManager.requestAddCardOnStripe(strURL: url, params: param, success: { (response) in
                print(response)
                self.strCardBrand = response["brand"] as? String ?? ""
                self.strCardId = response["id"] as? String ?? ""
                self.strLastDigit = response["last4"] as? String ?? ""
                
                self.Call_For_WebService_AddCard()
                
                if (response["error"] as? [String:Any]) != nil {
                     objWebServiceManager.StopIndicator()
                    objAlert.showAlert(message: "Your_card_details_are_not_valid".localize, title: kAlert.localize, controller: self)
                    
                        return
                }
                
                
                
            //    self.navigationController?.popViewController(animated: true)
                objWebServiceManager.StopIndicator()
            }) { (error) in
                print(error)
               objWebServiceManager.StopIndicator()
                let alertView = UIAlertController(title:"Message".localize , message: "Message".localize, preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "Ok".localize, style: .default, handler: nil))
                self.present(alertView, animated:true, completion:nil)
            }
        
    }
    
    
    
    
    
    
    
    
    // TODO: Webservice For delete Cart
    
    func callWebForDeleteCard(CardID : String ){
    
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var strWsUrl = ""
        strWsUrl  =   WsUrl.deleteSavedCard  +  CardID
       //  strWsUrl  =   WsUrl.deleteSavedCard

        print("strWsUrl is \(strWsUrl)")
        
        
        var param: [String: Any] = [:]
        param = [
            WsParam.id:CardID
        ] as [String : Any]
        print(param)
        
        objWebServiceManager.requestDELETE(strURL: strWsUrl, Queryparams: nil , body: nil , strCustomValidation: "", success: { response in
            
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
              //  self.strCategoryId = ""
                self.arrCardList.removeAll()
                self.callWsForCardList()
                
            }else{
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
        })
    }
    
    
}
//MARK: - Api Calling
extension SavedCardListVC{

    
    func Call_For_WebService_AddCard(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        

        let expM = self.strMonth
               let expY = self.strYear
               var param = [String:Any]()

               param = ["stripe_card_id" :self.strCardId ,
                        "card_holder_name" : self.txtCardHolderName.text ?? "",
                        "card_last_4_digits" :String(self.strLastDigit),
                        "card_expiry_month" : expM,
                        "card_expiry_year": expY,
                        "card_brand_type":self.strCardBrand
               ]
         print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.addCard, params: param, strCustomValidation: "", showIndicator: false, success: {response in
                   print(response)
                   objWebServiceManager.StopIndicator()
                   let status =   (response["status"] as? String)
                   let message =  (response["message"] as? String)
                   
                   if status == "success"{
                    // deepak new work
                  //  self.resetPicker()
                    // deepak new work
                    self.txtCardHolderName.text = ""
                    self.txtCardNumber.text = ""
                    self.txtCVV.text = ""
                    self.txtExpiryDate.text = ""
                    
                    
                   self.vwBlur.isHidden = true
                        self.callWsForCardList()
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
    
    func callWsForCardList(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
                
        objWebServiceManager.requestGet(strURL: WsUrl.cardList  ,Queryparams: [:], body: [:], strCustomValidation: "", success: {response in
                   print(response)
                   
                   let status =   (response["status"] as? String)
                   let message =  (response["message"] as? String)
                   
            
                   if status == "success"
                   {
        
                    if message == "No record found".localize{
                        self.lblNoCard.isHidden = false
                        self.tblCardList.isHidden = true
                    }else{
                        self.lblNoCard.isHidden = true
                        self.tblCardList.isHidden = false
                    }
                    
                    let dic  = response["data"] as? [String:Any]

                    
                  //  if let arrCardData = dic?["card_list"] as? [String:Any]{
                        
                        if let arrCardData = dic?["card_list"] as? [[String: Any]]{

                        
                                      self.arrCardList.removeAll()

                        
                        for dictGetData in arrCardData
                        {
                            let objNewData = CardListModel.init(dict: dictGetData)
                            self.arrCardList.append(objNewData)
                        }
                        
                        print("self.arrCardList.count is \(self.arrCardList.count)")
                                                
                    }
                    
                    
                    if  objAppShareData.isFromCartList == true {
                    print(" is From CartListVC ")
                    
                    
                    if self.arrCardList.count == 0 {
                    }else{
                        //  self.vwDone.isHidden = false
                    }
                    }else{
                   // self.vwDone.isHidden = false
                    }
            
                       self.tblCardList.reloadData()
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
    
    // TODO: Webservice For Book Ride
//    
//    func callWsForBookRide(){
//        
//        if !objWebServiceManager.isNetworkAvailable(){
//            // objWebServiceManager.StopIndicator()
//            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
//            return
//        }
//        objWebServiceManager.StartIndicator()
//        
//        
//        var cardId = ""
//        var paymentMethod = ""
//        var source = ""
//        var destination = ""
//        var sourceLat = ""
//        var sourceLong = ""
//        var destinationLat = ""
//        var destinationLong = ""
//        
//        
//        
//        if let source1 = objAppShareData.dictRideLoction["source"]as? String{
//            source = source1
//        }
//        if let destina = objAppShareData.dictRideLoction["destination"]as? String{
//            destination = destina
//        }
//        if let sourcelat = objAppShareData.dictRideLoction["source_lat"]as? String{
//            sourceLat = sourcelat
//        }
//        if let sourcelong = objAppShareData.dictRideLoction["source_long"]as? String{
//            sourceLong = sourcelong
//        }
//        if let destinationlat = objAppShareData.dictRideLoction["destination_lat"]as? String{
//            destinationLat = destinationlat
//        }
//        if let destinationlong = objAppShareData.dictRideLoction["destination_long"]as? String{
//            destinationLong = destinationlong
//        }
//        
//
//        
//        if  self.strPaymentMethod == "1" {
//            paymentMethod = "1"
//            cardId = ""
//
//        }else if  self.strPaymentMethod == "2" {
//               paymentMethod = "2"
//               cardId = self.strId
//
//        }
//        
//        
//        
//        var param: [String: Any] = [:]
//        param = [
//            WsParam.source: source ,
//            WsParam.destination: destination,
//            WsParam.sourceLat: sourceLat,
//            WsParam.sourceLong: sourceLong,
//            WsParam.destinationLat: destinationLat ,
//            WsParam.destinationLong: destinationLong ,
//            WsParam.vehicleMetaId: strvehicleMetaID,
//            WsParam.paymentMethod: paymentMethod ,
//            WsParam.cardId: cardId
//            
//            ] as [String : Any]
//        
//        
//        print(param)
//       
//        objWebServiceManager.requestPost(strURL: WsUrl.bookingRide , params: param, strCustomValidation: "", showIndicator: false, success: {response in
//            print(response)
//            //   objWebServiceManager.StopIndicator()
//            let status =   (response["status"] as? String)
//            let message =  (response["message"] as? String)
//            
//            if status == "success"{
//                
//                print(" sucess in api ")
//                
//
//                
//                
//                 self.navigationController?.popViewController(animated: false)
//            }
//            else
//            {
//                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
//                // self.CheckInput()
//            }
//            
//            
//        }, failure: { (error) in
//            print(error)
//            // objWebServiceManager.StopIndicator()
//            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
//            //  self.CheckInput()
//            
//        })
//    }
}





