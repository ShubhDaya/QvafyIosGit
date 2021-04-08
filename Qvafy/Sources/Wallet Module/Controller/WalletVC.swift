//
//  WalletVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 20/10/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.

import UIKit

class WalletVC: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var lblCardEarning: UILabel!
    @IBOutlet weak var lblCashEarning: UILabel!
    @IBOutlet weak var lblCardAdminFees: UILabel!
    @IBOutlet weak var lblCashAdminFees: UILabel!
    @IBOutlet weak var lblCashCommission: UILabel!
    @IBOutlet weak var lblCardCommission: UILabel!
    @IBOutlet weak var lblTotalSettlement: UILabel!
    @IBOutlet weak var lblWalletMoney: UILabel!
    @IBOutlet weak var lblChatCount: UILabel!
    @IBOutlet weak var btnWithdraw: UIButton!
    @IBOutlet weak var vwWithdraw: UIView!
    @IBOutlet weak var vwImgWithdraw: UIView!
    @IBOutlet weak var btnPayToCompany: UIButton!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var vwPay: UIView!
    @IBOutlet weak var vwImgPay: UIView!
    @IBOutlet weak var vwWithdrawRequest: UIView!
    @IBOutlet weak var vwPayToCompany: UIView!
    @IBOutlet weak var txtMoney: UITextField!
    @IBOutlet weak var imgCuba: UIImageView!
    @IBOutlet weak var vwBlur: UIView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var vwMoney: UIView!

    @IBOutlet weak var vwCalendarBlur: UIView!
    @IBOutlet weak var vwApply: UIView!
    @IBOutlet weak var vwImgApply: UIView!
    @IBOutlet weak var btnApply : UIButton!
    @IBOutlet weak var lblMonthYear: UILabel!

    @IBOutlet weak var lblJanuary: UILabel!
    @IBOutlet weak var lblFebruary: UILabel!
    @IBOutlet weak var lblMarch: UILabel!
    @IBOutlet weak var lblApril: UILabel!
    @IBOutlet weak var lblMay: UILabel!
    @IBOutlet weak var lblJun: UILabel!
    @IBOutlet weak var lblJuly: UILabel!
    @IBOutlet weak var lblAugust: UILabel!
    @IBOutlet weak var lblSeptember: UILabel!
    @IBOutlet weak var lblOctober: UILabel!
    @IBOutlet weak var lblNovember: UILabel!
    @IBOutlet weak var lblDecember: UILabel!
    
    @IBOutlet weak var imgForward: UIImageView!
    @IBOutlet weak var imgBackward: UIImageView!

    // Localization Outlets-
    
    @IBOutlet weak var lblHeaderWallet: UILabel!
    @IBOutlet weak var lblLOCard: UILabel!
    @IBOutlet weak var lblLOTotalEarning: UILabel!
    @IBOutlet weak var lblLOTotalAdminFees: UILabel!
    
    @IBOutlet weak var lblLOCase: UILabel!
    @IBOutlet weak var lblLOCaseTotalEaring: UILabel!
    @IBOutlet weak var lblLOCaseTotalAdminFees: UILabel!
    
    @IBOutlet weak var lblLOCompanySettlement: UILabel!
    
    @IBOutlet weak var lblLOCommisionVIaCase: UILabel!
    @IBOutlet weak var lblLOTotalEaringViaCard: UILabel!
    @IBOutlet weak var lblLOTotalSetlement: UILabel!
    
    @IBOutlet weak var lblLOPayToCompany: UILabel!

    @IBOutlet weak var lblLOApplyCallender: UILabel!
    @IBOutlet weak var lblLOPayToCompanyEnterViewHeader: UILabel!
    @IBOutlet weak var lblLOAreYouFromCuba: UILabel!
   
    @IBOutlet weak var btnLOReset: UIButton!
    @IBOutlet weak var lblLOMOney: UILabel!
    
    //MARK: - Variables
    let date = Date()
    let calendar = Calendar.current
    var strMonth = "01"
    var year = 0000
    var strDateYear = ""
    var strMonthTitle = ""
    var strInitialYear = 0000
    var strInitialMonth = "01"
    var strInitialMonthTitle = ""
    var strAmount = ""
    var strCardId = ""
    var strPaymentMode = ""
    var strTotalSettlement = ""
    var isFilterApply = false
    var strSaveMonth = ""
    var strSaveYear = ""
    var strSaveMonthTitle  = ""
    var isFromForgroundNotification = false

    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwHeader.setviewbottomShadow()
        self.vwBottom.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
        self.vwPay.setButtonView(vwOuter : self.vwPay , vwImage : self.vwImgPay, btn: self.btnPay )
        self.vwWithdraw.setButtonView(vwOuter : self.vwWithdraw , vwImage : self.vwImgWithdraw, btn: self.btnWithdraw )
        self.vwApply.setButtonVerifyView(vwOuter: self.vwApply, btn: self.btnApply , viewRadius: Int(22.5), btnRadius: 20)
        self.vwImgApply.setViewCircle(vwImage: vwImgApply)
        self.vwMoney.setCornerRadiusQwafy(vw: self.vwMoney)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //
        self.lblChatCount.layer.cornerRadius = self.lblChatCount.frame.height/2
              self.lblChatCount.clipsToBounds = true
               objAppShareData.showChatCountFromFirebase(lbl: self.lblChatCount)
        //
        self.Localization()
        
        self.vwBlur.isHidden = true
        self.vwCalendarBlur.isHidden = true
        self.vwWithdrawRequest.isHidden = true
        self.vwPayToCompany.isHidden = true
        self.roundedLabel()
        self.selectCurrentMonth()
        self.callWsForWallet()

      //  self.vwCalendarBlur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
    }
    
    @objc func refrershUI(){
        self.isFromForgroundNotification = true
        self.callWsForWallet()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.isFromForgroundNotification = false
        }
    
    
    
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        self.vwCalendarBlur.isHidden = true
        //
        print("In Tap \(self.isFilterApply)")
        if  self.isFilterApply != true {
        self.year = self.strInitialYear
        self.strMonth = self.strInitialMonth
        self.strMonthTitle  = self.strInitialMonthTitle
        self.checkMonth(month:Int(self.strInitialMonth)!)
        self.lblMonthYear.text = self.strInitialMonthTitle.localize + " " + "\(self.strInitialYear)"
            
            print(self.lblMonthYear.text ?? "")
        }else{
            self.year = Int(self.strSaveYear) ?? 0000
            self.strMonth = self.strSaveMonth
            self.strMonthTitle  = self.strSaveMonthTitle
            self.checkMonth(month:Int(self.strSaveMonth)!)
            self.lblMonthYear.text = self.strSaveMonthTitle.localize + " " + "\(self.strSaveYear)"
            print("label value - \(String(describing: self.lblMonthYear.text))")
            print("year on tap \(self.year)  month \(self.strMonth)")
           // print("after apply year is on tap \(self.year)  str month \(self.strMonth)")
        }
        //
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    func msgForToast (){
    let alertDisapperTimeInSeconds = 2.0
        let alert = UIAlertController(title: nil, message: "Withdraw_request_send_successfully.".localize, preferredStyle: .actionSheet)
    self.present(alert, animated: true)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
      alert.dismiss(animated: true)
    }
    }
    
    //MARK: - Custom Methods
    
    func selectCurrentMonth(){
              let dateFormatter = DateFormatter()
             dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
             dateFormatter.dateFormat = "yyyy-MM"
             let Currentyear = dateFormatter.string(from: date)
             print("Currentyear \(Currentyear)")
             let myStringArr = Currentyear.components(separatedBy: "-")
             self.year = Int(myStringArr[0])!
             self.strMonth = myStringArr[1]
        print("self.strMonth\(self.strMonth)")
        
        self.strInitialYear = self.year
             self.strInitialMonth = self.strMonth
             self.checkMonth(month:Int(self.strMonth)!)
        
        let dateFormatter1 = DateFormatter()
       dateFormatter1.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
       dateFormatter1.dateFormat = "yyyy-MMM"
        let Currentyear1 = dateFormatter1.string(from: date)
        let monthArry = Currentyear1.components(separatedBy: "-")
        self.strMonthTitle = monthArry[1]
        self.strInitialMonthTitle = monthArry[1]
        print(" current month is --- \(monthArry[1])")
        self.lblMonthYear.text = "\(monthArry[1])".localize + " " + "\(self.year)"

      ///  self.imgBackward.isHidden = true
    }
    
    func checkMonth(month:Int){
        if month == 01 {
            self.setSelectedMonthBG(selectedLbl: self.lblJanuary)
        }else if month == 02{
            self.setSelectedMonthBG(selectedLbl: self.lblFebruary)
        }else if month == 03{
            self.setSelectedMonthBG(selectedLbl: self.lblMarch)
        }else if month == 04{
            self.setSelectedMonthBG(selectedLbl: self.lblApril)
        }else if month == 05{
            self.setSelectedMonthBG(selectedLbl: self.lblMay)
        }else if month == 06{
            self.setSelectedMonthBG(selectedLbl: self.lblJun)
        }else if month == 07{
            self.setSelectedMonthBG(selectedLbl: self.lblJuly)
        }else if month == 08{
            self.setSelectedMonthBG(selectedLbl: self.lblAugust)
        }else if month == 09{
            self.setSelectedMonthBG(selectedLbl: self.lblSeptember)
        }else if month == 10{
            self.setSelectedMonthBG(selectedLbl: self.lblOctober)
        }else if month == 11{
            self.setSelectedMonthBG(selectedLbl: self.lblNovember)
        }else{
            self.setSelectedMonthBG(selectedLbl: self.lblDecember)
        }
    }
    
    func roundedLabel(){
         self.lblJanuary.setCornerRadiusWithBoarder(color : .clear,cornerRadious : 3)
        self.lblFebruary.setCornerRadiusWithBoarder(color : .clear,cornerRadious : 3)
        self.lblMarch.setCornerRadiusWithBoarder(color : .clear,cornerRadious : 3)
        self.lblApril.setCornerRadiusWithBoarder(color : .clear,cornerRadious : 3)
        self.lblMay.setCornerRadiusWithBoarder(color : .clear,cornerRadious : 3)
        self.lblJun.setCornerRadiusWithBoarder(color : .clear,cornerRadious : 3)
        self.lblJuly.setCornerRadiusWithBoarder(color : .clear,cornerRadious : 3)
        self.lblAugust.setCornerRadiusWithBoarder(color : .clear,cornerRadious : 3)
        self.lblSeptember.setCornerRadiusWithBoarder(color : .clear,cornerRadious : 3)
        self.lblOctober.setCornerRadiusWithBoarder(color : .clear,cornerRadious : 3)
        self.lblNovember.setCornerRadiusWithBoarder(color : .clear,cornerRadious : 3)
        self.lblDecember.setCornerRadiusWithBoarder(color : .clear,cornerRadious : 3)
    }
    func setSelectedMonthBG(selectedLbl:UILabel){
        self.lblJanuary.backgroundColor = .clear
        self.lblFebruary.backgroundColor = .clear
        self.lblMarch.backgroundColor = .clear
        self.lblApril.backgroundColor = .clear
        self.lblMay.backgroundColor = .clear
        self.lblJun.backgroundColor = .clear
        self.lblJuly.backgroundColor = .clear
        self.lblAugust.backgroundColor = .clear
        self.lblSeptember.backgroundColor = .clear
        self.lblOctober.backgroundColor = .clear
        self.lblNovember.backgroundColor = .clear
        self.lblDecember.backgroundColor = .clear

        self.lblJanuary.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        self.lblFebruary.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        self.lblMarch.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        self.lblApril.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        self.lblMay.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        self.lblJun.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        self.lblJuly.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        self.lblAugust.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        self.lblSeptember.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        self.lblOctober.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        self.lblNovember.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        self.lblDecember.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        
        self.lblJanuary.font = UIFont(name: "Poppins-Medium", size: 13.3)
        self.lblFebruary.font = UIFont(name: "Poppins-Medium", size: 13.3)
        self.lblMarch.font = UIFont(name: "Poppins-Medium", size: 13.3)
        self.lblApril.font = UIFont(name: "Poppins-Medium", size: 13.3)
        self.lblMay.font = UIFont(name: "Poppins-Medium", size: 13.3)
        self.lblJun.font = UIFont(name: "Poppins-Medium", size: 13.3)
        self.lblJuly.font = UIFont(name: "Poppins-Medium", size: 13.3)
        self.lblAugust.font = UIFont(name: "Poppins-Medium", size: 13.3)
        self.lblSeptember.font = UIFont(name: "Poppins-Medium", size: 13.3)
        self.lblOctober.font = UIFont(name: "Poppins-Medium", size: 13.3)
        self.lblNovember.font = UIFont(name: "Poppins-Medium", size: 13.3)
        self.lblDecember.font = UIFont(name: "Poppins-Medium", size: 13.3)
        
        selectedLbl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        selectedLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    //MARK: Localization Method -
    func Localization(){
        self.lblHeaderWallet.text = "Wallet".localize
        self.lblLOCard.text = "Card".localize
        self.lblLOTotalEarning.text = "Total_Earning".localize
        self.lblLOTotalAdminFees.text = "Total_Admin_Fees".localize
        
        self.lblLOCase.text = "Cash".localize
        self.lblLOCaseTotalEaring.text = "Total_Earning".localize
        self.lblLOCaseTotalAdminFees.text = "Total_Admin_Fees".localize
        
        self.lblLOCompanySettlement.text = "Company_Settlement".localize
        
        self.lblLOCommisionVIaCase.text = "Total_Commission_Via_Cash".localize
        self.lblLOTotalEaringViaCard.text = "Total_Earning_Via_Card".localize
        self.lblLOTotalSetlement.text = "Total_Settlement".localize
        
        
        
        self.lblLOPayToCompany.text = "Pay_To_Company".localize
        
        self.lblJanuary.text = "Jan".localize
        
        self.lblFebruary.text = "Feb".localize

        self.lblMarch.text = "Mar".localize

        self.lblApril.text = "Apr".localize

        self.lblMay.text = "May".localize

        self.lblJun.text = "Jun".localize

        self.lblJuly.text = "Jul".localize

        self.lblAugust.text = "Aug".localize

        self.lblSeptember.text = "Sep".localize

        self.lblOctober.text = "Oct".localize

        self.lblNovember.text = "Nov".localize

        self.lblDecember.text = "Dec".localize
        
        self.lblLOApplyCallender.text = "Apply".localize

        self.lblLOPayToCompanyEnterViewHeader.text = "Pay_To_Company".localize
        self.lblLOAreYouFromCuba.text = "Are_you_from_Cuba_?".localize
        self.lblLOMOney.text = "Money".localize
        
        self.txtMoney.placeholder = "Enter_Money".localize
      
        self.btnPay.setTitle("Pay".localize, for: .normal)
      
        self.btnWithdraw.setTitle("Withdraw_Request".localize, for: .normal)
        
        self.btnLOReset.setTitle("Reset".localize, for: .normal)

    }
    
    //MARK: - Buttons Action

    @IBAction func btnChatAction(_ sender: Any) {
           self.view.endEditing(true)
          let sb = UIStoryboard(name: "Chat", bundle: nil)
                 let detailVC = sb.instantiateViewController(withIdentifier: "ChatHistoryVC") as! ChatHistoryVC
                 self.navigationController?.pushViewController(detailVC, animated: true)

       }

    @IBAction func btnCloseCalender(_ sender: Any) {
        self.view.endEditing(true)
        self.vwCalendarBlur.isHidden = true
        //
        print("In Tap \(self.isFilterApply)")
        if  self.isFilterApply != true {
        self.year = self.strInitialYear
        self.strMonth = self.strInitialMonth
        self.strMonthTitle  = self.strInitialMonthTitle
        self.checkMonth(month:Int(self.strInitialMonth)!)
        self.lblMonthYear.text = self.strInitialMonthTitle.localize + " " + "\(self.strInitialYear)"
            
            print(self.lblMonthYear.text ?? "")
        }else{
            self.year = Int(self.strSaveYear) ?? 0000
            self.strMonth = self.strSaveMonth
            self.strMonthTitle  = self.strSaveMonthTitle
            self.checkMonth(month:Int(self.strSaveMonth)!)
            self.lblMonthYear.text = self.strSaveMonthTitle.localize + " " + "\(self.strSaveYear)"
            print("label value - \(String(describing: self.lblMonthYear.text))")
            print("year on tap \(self.year)  month \(self.strMonth)")
           // print("after apply year is on tap \(self.year)  str month \(self.strMonth)")
        }
    }

    @IBAction func btnPayToCompany(_ sender: Any) {
        self.view.endEditing(true)

        if objAppShareData.UserDetail.strIsUserCuba == "1"{
            self.imgCuba.image = #imageLiteral(resourceName: "ON_TOGGLE_ICO")
            self.tabBarController?.tabBar.isHidden = true
            self.vwBlur.isHidden = false
            self.txtMoney.text = ""
        }else{
            let sb = UIStoryboard(name: "Map", bundle: nil)
            let detailVC = sb.instantiateViewController(withIdentifier: "PaymentMethodVC") as! PaymentMethodVC
            objAppShareData.isFromCartList = true
            objAppShareData.isFromWallet = true
            ////
            detailVC.closerGetCardId = {
                isClearListData in
                if isClearListData{
                    print("objAppShareData.strCardId is \(objAppShareData.strCardId)")

                    self.strAmount = self.strTotalSettlement
                    self.strCardId = objAppShareData.strCardId
                    self.strPaymentMode = "2"
                    self.callWsForPayToCompany()
                    self.tabBarController?.tabBar.isHidden = false
                    
                }
            }
            ////
            
            self.navigationController?.pushViewController(detailVC, animated: true)

        }
        
    }
    
    @IBAction func btnWithdrawRequest(_ sender: Any) {
        self.view.endEditing(true)
      
        let strAccountNumber = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.kAccountNo) as? String

        print("objAppShareData.UserDetail.strIsUserCuba is \(objAppShareData.UserDetail.strIsUserCuba)")
        print("objAppShareData.UserDetail.strStripeConnectAccountVerified is \(objAppShareData.UserDetail.strStripeConnectAccountVerified)")
        print("objAppShareData.UserDetail.strAccountNumber is \(objAppShareData.UserDetail.strAccountNumber)")

  //  print("strAccountNumber is \(strAccountNumber)")
    //    print(strAccountNumber)
        if objAppShareData.UserDetail.strIsUserCuba == "0" &&  strAccountNumber != nil && strAccountNumber != "" {
            
            if objAppShareData.UserDetail.strStripeConnectAccountVerified == "1"{
                self.callWsForWithdrawRequest()
                //objAlert.showAlert(message: "Api call here", title: kAlert, controller: self)
            }else{
                objAlert.showAlert(message: "Your_bank_account_is_not_verified_please_verify_your_information".localize, title: kAlert.localize, controller: self)
            }
        } else if objAppShareData.UserDetail.strIsUserCuba == "1"{
            self.callWsForWithdrawRequest()
        } else{
            objAlert.showAlert(message: "Please_add_your_bank_details".localize, title: kAlert.localize, controller: self)
        }
    }
    @IBAction func btnCancel(_ sender: Any) {
        self.view.endEditing(true)
        self.tabBarController?.tabBar.isHidden = false
        self.vwBlur.isHidden = true

    }
    @IBAction func btnPay(_ sender: Any) {
        self.view.endEditing(true)
        self.txtMoney.text = self.txtMoney.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        if self.txtMoney.text == ""{
            objAlert.showAlert(message: "Please_enter_money.".localize, title: kAlert.localize, controller: self)
        }else{
            self.strAmount = self.txtMoney.text!
            self.strCardId = ""
            self.strPaymentMode = "1"
            self.callWsForPayToCompany()
            self.tabBarController?.tabBar.isHidden = false
            self.vwBlur.isHidden = true
        }
    }
    
    @IBAction func btnForwardAction(_ sender: Any){
        self.view.endEditing(true)
      //  let year = calendar.component(.year, from: date) + 10
//       let strCurrentyear = calendar.component(.year, from: date)
//
//        print("self.year is on forword \(self.year) ")
//        print("strCurrentyear is on forword \(strCurrentyear) ")
//
//        let year = strCurrentyear //2070
//        if self.year != strCurrentyear {
//            let finalYear = self.year + 1
//            self.year = finalYear
//            print("finalYear is on forword \(finalYear) ")
//
//         //   if self.year == 2070{
//                if self.year == strCurrentyear{
//            ///   self.imgForward.isHidden = true
//            }else{
//            ///    self.imgForward.isHidden = false
//            }
//        ///    self.imgBackward.isHidden = false
//            self.lblMonthYear.text = self.strMonthTitle + " " + "\(self.year)"
//
//
//        }else{
//            self.lblMonthYear.text = self.strMonthTitle + " " + "\(self.year)"
//         ///   self.imgForward.isHidden = true
//        }
     ////////////////////////////////////////
//        let strCurrentyear = calendar.component(.year, from: date)
//
//        if strCurrentyear == self.strInitialYear{
//            self.imgBackward.isHidden = false
//            self.imgForward.isHidden = true
//        }else{
////            self.imgBackward.isHidden = true
////            self.imgForward.isHidden = false
//
//            if self.year != strCurrentyear {
//                let finalYear = self.year + 1
//                self.year = finalYear
//                print("finalYear is on forword \(finalYear) ")
//
//                    if self.year == strCurrentyear{
//                   self.imgForward.isHidden = true
//                }else{
//                   self.imgForward.isHidden = false
//                }
//                self.imgBackward.isHidden = false
//                self.lblMonthYear.text = self.strMonthTitle + " " + "\(self.year)"
//
//
//            }
//
//        }
        
        
        let strCurrentyear = calendar.component(.year, from: date)
        print("self.year is on forward \(self.year) ")
        print("strCurrentyear is on forward \(strCurrentyear) ")
        if self.year  == strCurrentyear{
            self.imgBackward.isHidden = false
            self.imgForward.isHidden = true
            self.lblMonthYear.text = self.strMonthTitle + " " + "\(self.year)"
        }else{
            let finalYear = self.year + 1
            self.year = finalYear
            
            if finalYear == strCurrentyear {
                self.imgBackward.isHidden = false
                self.imgForward.isHidden = true
            }else{
                self.imgBackward.isHidden = false
                self.imgForward.isHidden = false
            }
            
            self.lblMonthYear.text = self.strMonthTitle + " " + "\(self.year)"
         
        }
        
        
        
    }
    @IBAction func btnBackwardAction(_ sender: Any){
        self.view.endEditing(true)

        let strCurrentyear = calendar.component(.year, from: date)
        print("self.year is on backword \(self.year) ")
        print("strCurrentyear is on backword \(strCurrentyear) ")
        if self.year  == 2020{
            self.imgBackward.isHidden = true
            self.imgForward.isHidden = false
            self.lblMonthYear.text = self.strMonthTitle + " " + "\(self.year)"
        }else{
            let finalYear = self.year - 1
            self.year = finalYear
            
            if finalYear == strCurrentyear || finalYear == 2020 {
                self.imgBackward.isHidden = true
                self.imgForward.isHidden = false
            }else{
                self.imgBackward.isHidden = false
                self.imgForward.isHidden = false
            }
            
            self.lblMonthYear.text = self.strMonthTitle + " " + "\(self.year)"
         
        }
        
        
    }
    
    // deepak new testing check karna h
    func checkIcons(){
        let strCurrentyear = calendar.component(.year, from: date)
        
        if strCurrentyear == 2020{
            self.imgBackward.isHidden = true
            self.imgForward.isHidden = false
        }else if self.strInitialYear == strCurrentyear {
            self.imgBackward.isHidden = false
            self.imgForward.isHidden = true
        }
        
    }
    // deepak new testing check karna h
    
    @IBAction func btnApply(_ sender: Any){
        self.view.endEditing(true)
        self.isFilterApply = true
        self.vwCalendarBlur.isHidden = true
        self.callWsForWallet()

    }
    @IBAction func btnReset(_ sender: Any){
        self.view.endEditing(true)
        self.vwCalendarBlur.isHidden = true
        self.isFilterApply = false
        self.year = self.strInitialYear
        self.strMonth = self.strInitialMonth
        self.checkMonth(month:Int(self.strInitialMonth)!)
        self.lblMonthYear.text = self.strInitialMonthTitle.localize + " " + "\(self.strInitialYear)"
        print(self.lblMonthYear.text ?? "")
      
        self.callWsForWallet()
      ///  self.imgBackward.isHidden = true
      ///  self.imgForward.isHidden = false

        // deepak new testing check karna h
        self.checkIcons()
        // deepak new testing check karna h

    }
    
    @IBAction func btnCalendar(_ sender: Any) {
        self.view.endEditing(true)
        self.vwCalendarBlur.isHidden = false
        //
        print("In btnCalendar \(self.isFilterApply)")
        if  self.isFilterApply != true {

        self.year = self.strInitialYear
        self.strMonth = self.strInitialMonth
        self.checkMonth(month:Int(self.strInitialMonth)!)
        self.lblMonthYear.text = self.strInitialMonthTitle.localize + " " + "\(self.strInitialYear)"
            
            print(self.lblMonthYear.text  ?? "")
        }else{
            self.year = Int(self.strSaveYear) ?? 0000
            self.strMonth = self.strSaveMonth
            self.strMonthTitle = self.strSaveMonthTitle
            self.checkMonth(month:Int(self.strSaveMonth)!)
            self.lblMonthYear.text = self.strSaveMonthTitle.localize + " " + "\(self.strSaveYear)"
        }
        //
        print("self.strInitialYear btnCalendar \(self.strInitialYear)")
        print("self.strInitialMonth btnCalendar \(self.strInitialMonth)")
        
        // deepak new testing check karna h
        self.checkIcons()
        // deepak new testing check karna h

    }
    
    @IBAction func btnActionSelectMonth(_ sender:UIButton){
             
        print("self.strInitialYear btnActionSelectMonth \(self.strInitialYear)")
        print("self.strInitialMonth btnActionSelectMonth \(self.strInitialMonth)")
        let strCurrentyear = calendar.component(.year, from: date)
        print("self.year is on btnActionSelectMonth \(self.year) ")
        print("strCurrentyear is on btnActionSelectMonth \(strCurrentyear) ")
        
        switch sender.tag {
        case 1:
           // if self.year <= strCurrentyear && Int(self.strInitialMonth) ?? 00 < 01 {
            self.setSelectedMonthBG(selectedLbl: self.lblJanuary)
            self.strMonth = "01"
            self.strMonthTitle = "Jan"
            self.lblMonthYear.text = "Jan".localize + " " + "\(self.year)"
//            }else{
//                print("not updated")
//            }
        case 2:
            self.setSelectedMonthBG(selectedLbl: self.lblFebruary)
            self.strMonth = "02"
            self.strMonthTitle = "Feb"
            self.lblMonthYear.text = "Feb".localize + " " + "\(self.year)"
        case 3:
            self.setSelectedMonthBG(selectedLbl: self.lblMarch)
            self.strMonth = "03"
            self.strMonthTitle = "Mar"
            self.lblMonthYear.text = "Mar".localize + " " + "\(self.year)"
        case 4:
           // if self.year <= strCurrentyear && Int(self.strInitialMonth) ?? 00 < 04 {

            self.setSelectedMonthBG(selectedLbl: self.lblApril)
            self.strMonth = "04"
            self.strMonthTitle = "Apr"
            self.lblMonthYear.text = "Apr".localize + " " + "\(self.year)"
//            }else{
//                print("not updated")
//            }
        case 5:
            self.setSelectedMonthBG(selectedLbl: self.lblMay)
            self.strMonth = "05"
            self.strMonthTitle = "May"
            self.lblMonthYear.text = "May".localize + " " + "\(self.year)"
        case 6:
            self.setSelectedMonthBG(selectedLbl: self.lblJun)
            self.strMonth = "06"
            self.strMonthTitle = "Jun"
            self.lblMonthYear.text = "Jun".localize + " " + "\(self.year)"
        case 7:
            self.setSelectedMonthBG(selectedLbl: self.lblJuly)
            self.strMonth = "07"
            self.strMonthTitle = "Jul"
            self.lblMonthYear.text = "Jul".localize + " " + "\(self.year)"
        case 8:
            self.setSelectedMonthBG(selectedLbl: self.lblAugust)
            self.strMonth = "08"
            self.strMonthTitle = "Aug"
            self.lblMonthYear.text = "Aug".localize + " " + "\(self.year)"
        case 9:
            self.setSelectedMonthBG(selectedLbl: self.lblSeptember)
            self.strMonth = "09"
            self.strMonthTitle = "Sep"
            self.lblMonthYear.text = "Sep".localize + " " + "\(self.year)"
        case 10:
            self.setSelectedMonthBG(selectedLbl: self.lblOctober)
            self.strMonth = "10"
            self.strMonthTitle = "Oct"
            self.lblMonthYear.text = "Oct".localize + " " + "\(self.year)"
        case 11:
            self.setSelectedMonthBG(selectedLbl: self.lblNovember)
            self.strMonth = "11"
            self.strMonthTitle = "Nov"
            self.lblMonthYear.text = "Nov".localize + " " + "\(self.year)"
        case 12:
            self.setSelectedMonthBG(selectedLbl: self.lblDecember)
            self.strMonth = "12"
            self.strMonthTitle = "Dec"
            self.lblMonthYear.text = "Dec".localize + " " + "\(self.year)"
        default:
            print("")
        }
        
        // print("self.strMonth is \(self.strMonth)")
        //self.callWs_GetInvoiceDetails()
    }

}

extension WalletVC {
    // TODO: Webservice For Wallet Detail

    func callWsForWallet(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize, title: kAlert.localize,  controller: self)
            return
        }
        
        if self.isFromForgroundNotification != true {
            objWebServiceManager.StartIndicator()
        }
        
         let strUserType = objAppShareData.UserDetail.strRole
        print("strUserType is \(strUserType)")
        self.strDateYear = "\(self.year)" + "-" + self.strMonth + "-" + "01"
        print("self.strDateYear in api \(self.strDateYear)")
        
        print("Final api date year is \(self.year) and month is \(self.strMonth)")

        var param: [String: Any] = [:]
        param = [
            WsParam.userType: strUserType ,
            WsParam.date : self.strDateYear
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.getWallet, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                if objAppShareData.isFromBannerNotification == true {
                    objAppShareData.resetBannarData()
                }
                self.strSaveMonth = self.strMonth
                self.strSaveYear = String(self.year)
                self.strSaveMonthTitle = self.strMonthTitle
                let dic  = response["data"] as? [String:Any]
                
             
                
                if  dic?.isEmpty == true {
                    
                    self.lblCardEarning.text = "$0.00"
                    self.lblCashEarning.text = "$0.00"
                    self.lblCardAdminFees.text = "$0.00"
                    self.lblCashAdminFees.text = "$0.00"
                    self.lblCashCommission.text = "-$0.00"
                    self.lblCardCommission.text = "$0.00"
                    self.lblTotalSettlement.text = "$0.00"
                    self.lblWalletMoney.text = "$0.00"
                    self.lblTotalSettlement.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
                    self.vwWithdrawRequest.isHidden = true
                    self.vwPayToCompany.isHidden = true
                    
                }else{
                                        
                    if let walletDetail = dic?["wallet_detail"] as? [String:Any]{
                        if let totalIncome = walletDetail["total_income"]as? String {
                          //  self.lblWalletMoney.text =  "$" + totalIncome
                        }
                        
                        if let cardAmount = walletDetail["card_amount"]as? String {
                            self.lblCardEarning.text = "$" + cardAmount
                            self.lblCardCommission.text =  "$" + cardAmount
                        }
                        
                        if let commissionCard = walletDetail["commission_amount_card"]as? String {
                            self.lblCardAdminFees.text =  "$" + commissionCard
                        }
                        
                        if let cashAmount = walletDetail["cash_amount"]as? String {
                            self.lblCashEarning.text =  "$" + cashAmount
                        }
                        
                        if let commissionCash = walletDetail["commission_amount_cash"]as? String {
                            self.lblCashCommission.text =  "-$" + commissionCash
                            self.lblCashAdminFees.text =  "$" + commissionCash
                        }
                        
                        if let totalSettlement = walletDetail["total_settlement_amount"]as? String {
                            
                            if totalSettlement.contains("-"){
                                let myStringArr = totalSettlement.components(separatedBy: "-")
                                self.lblTotalSettlement.text =  "-$" + myStringArr[1]
                                self.strTotalSettlement = myStringArr[1]
                                self.lblTotalSettlement.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                                self.vwWithdrawRequest.isHidden = true
                                self.vwPayToCompany.isHidden = false
                                self.lblWalletMoney.text =  "-$" + myStringArr[1]

//                                self.btnWithdraw.isUserInteractionEnabled = false
//                                self.btnPayToCompany.isUserInteractionEnabled = true
                            

                            }else if totalSettlement.contains("0.00"){
                                self.vwWithdrawRequest.isHidden = true
                                self.vwPayToCompany.isHidden = true
                                self.lblTotalSettlement.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
                                self.lblTotalSettlement.text =  "$0.00"
                                self.lblWalletMoney.text =  "$0.00"

                            }else{
                                self.lblTotalSettlement.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
                                self.strTotalSettlement = totalSettlement
                                self.lblTotalSettlement.text =  "$" + totalSettlement
                                self.lblWalletMoney.text =  "$" + totalSettlement

                                self.vwWithdrawRequest.isHidden = false
                                self.vwPayToCompany.isHidden = true
//                                self.btnWithdraw.isUserInteractionEnabled = true
//                                self.btnPayToCompany.isUserInteractionEnabled = false
                                
                            }
                        }
                        
                    }
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
    
    
    // TODO: Webservice For Pay To Company

    func callWsForPayToCompany(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        
        objWebServiceManager.StartIndicator()
         let strUserType = objAppShareData.UserDetail.strRole
        self.strDateYear = "\(self.year)" + "-" + self.strMonth + "-" + "01"

        var param: [String: Any] = [:]
        param = [
            WsParam.userType: strUserType ,
            WsParam.date : self.strDateYear,
            WsParam.amount : self.strAmount,
            WsParam.cardId : self.strCardId,
            WsParam.paymentMode : self.strPaymentMode
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.payToCompany, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                objAppShareData.strCardId = ""
                
                objAlert.showAlertCallOneBtnAction(btnHandler: "Ok", title: kAlert.localize, message: message ?? "", controller: self) {
                    self.callWsForWallet()
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
    
    
    // TODO: Webservice For WithdrawRequest

    func callWsForWithdrawRequest(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        
        objWebServiceManager.StartIndicator()
         let strUserType = objAppShareData.UserDetail.strRole
        self.strDateYear = "\(self.year)" + "-" + self.strMonth + "-" + "01"

        var param: [String: Any] = [:]
        param = [
            WsParam.userType: strUserType ,
            WsParam.date : self.strDateYear,
            WsParam.amount : self.strTotalSettlement,
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.withdrawRequest, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)

                self.callWsForWallet()
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



