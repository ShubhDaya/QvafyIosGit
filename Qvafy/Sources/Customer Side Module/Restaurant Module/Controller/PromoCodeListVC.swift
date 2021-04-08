//
//  PromoCodeListVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 14/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class PromoCodeListVC: UIViewController {
 
    //MARK: Outlets
       
       @IBOutlet weak var vwHeader: UIView!
       @IBOutlet weak var vwNoData: UIView!
       @IBOutlet weak var tblPromoList: UITableView!
    
    // Localisation outlets-
    
    @IBOutlet weak var lblLOheaderPromoCode: UILabel!
    @IBOutlet weak var lblLONoPromoCodeHere: UILabel!
    
    
    //MARK: - Variables

    
    var arrPromoCode:[PromoCodeModel] = []
    // Refresh
   var pullToRefreshCtrl:UIRefreshControl!
      var isRefreshing = false
    
    //MARK: LifeCycle
      
      
      override func viewDidLoad() {
          super.viewDidLoad()
        self.setPullToRefresh()

        
      }
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
        self.Localisation()
        self.vwNoData.isHidden = true

        self.vwHeader.setviewbottomShadow()
        self.callWsGetPromoCodeList()
        self.tblPromoList.reloadData()
    }
    
    func Localisation(){
        
     
        self.lblLOheaderPromoCode.text = "Promo_Code".localize
        self.lblLONoPromoCodeHere.text = "No_promo_code_here".localize

    }
    
    //MARK: - Button Action
      
      @IBAction func btnBack(_ sender: Any) {
          self.view.endEditing(true)
          self.navigationController?.popViewController(animated: true)
      }
      
    

}


//MARK: - Extension UITableViewDelegate and UITableViewDataSource


extension PromoCodeListVC : UITableViewDelegate ,UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return self.arrPromoCode.count
      //  return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tblPromoList.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as!CardListCell
        
        let obj = self.arrPromoCode[indexPath.row]
        
        cell.lblCardNumber.text = obj.strTitle
        

         cell.imgVwCardType.image = #imageLiteral(resourceName: "offer_ico")
        

                   if obj.strExpiryDate != ""{
                    let date = self.changeDateformat(strDate: obj.strExpiryDate )
                   // let date = objAppShareData.convertLocalTime(strDateTime: obj.strExpiryDate ?? "")
                    
                    cell.lblCardAddDate.text = "\("Expires".localize) : \(date)"
                   }
        
        
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self,action:#selector(buttonAddClicked), for: .touchUpInside)


        return cell
    }
    
    
    
    @objc func buttonAddClicked(sender:UIButton) {
        
        if arrPromoCode.count > 0{
               
               let obj = self.arrPromoCode[sender.tag]
        objAppShareData.strPromoCodeId = obj.strPromoCodeID
        objAppShareData.strOfferTitle = obj.strTitle

        print("objAppShareData.strPromoCodeId is \(objAppShareData.strPromoCodeId)")
             self.tblPromoList.reloadData()
        self.navigationController?.popViewController(animated: true)
              
           }
    }
    
    
        func tableView(_ tableView: UITableView,
                       heightForRowAt indexPath: IndexPath) -> CGFloat{
            return 90
        }
    
    func changeDateformat(strDate:String)-> String{
             let dateformatter = DateFormatter()
             dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
             dateformatter.dateFormat = "YYYY-MM-dd"
             dateformatter.timeZone = NSTimeZone(name: "UTC") as TimeZone? // new
             let date1 = dateformatter.date(from: strDate)
             dateformatter.timeZone = TimeZone.current // new
             let strDate = date1?.strrigWithFormat(format: "d MMM yyyy") ?? ""
             return strDate
         }
}


extension PromoCodeListVC {
// TODO: Webservice For getPromoCodeList
func callWsGetPromoCodeList(){
    
    if !objWebServiceManager.isNetworkAvailable(){
        //objWebServiceManager.StopIndicator()
        objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
        return
    }
    if isRefreshing{
        objWebServiceManager.StopIndicator()
    }
    objWebServiceManager.requestGet(strURL: WsUrl.getPromoCodeList  ,Queryparams: [:], body: [:], strCustomValidation: "", success: {response in
        print(response)
        //  objWebServiceManager.StopIndicator()
        
        let status =   (response["status"] as? String)
        let message =  (response["message"] as? String)
        if self.isRefreshing{
            self.arrPromoCode.removeAll()
        }
        self.isRefreshing = false
        self.pullToRefreshCtrl.endRefreshing()
        
        if status == "success"
        {
            let dict  = response["data"] as? [String:Any]
            
            
            if  let  dataFound = dict?["data_found"] as? Int  {
                if dataFound == 1 {
                    
                     self.vwNoData.isHidden = true
                    self.tblPromoList.isHidden = false
                    
                    if let arrPromoCodeData = dict?["booking_list"] as? [[String:Any]]{
                        self.arrPromoCode.removeAll()
                        
                        for dictPromoCodeData in arrPromoCodeData{
                            let objPromoCodeData = PromoCodeModel.init(dict: dictPromoCodeData)
                            self.arrPromoCode.append(objPromoCodeData)
                        }
                        print("arrPromoCode count is \(self.arrPromoCode.count)")
                        
                    }
                    
                    
                }else{
                    self.vwNoData.isHidden = false
                    self.tblPromoList.isHidden = true
                    
                }
                
            }
            
            
            
            
            self.tblPromoList.reloadData()
        }else
        {
            objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
        }
    }, failure: { (error) in
        print(error)
        //  objWebServiceManager.StopIndicator()
        objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
        
    })
    
}

}

//MARK: - Pull to refresh list
extension PromoCodeListVC{
    func setPullToRefresh(){
        pullToRefreshCtrl = UIRefreshControl()
        pullToRefreshCtrl.addTarget(self, action: #selector(self.pullToRefreshClick(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tblPromoList.refreshControl = pullToRefreshCtrl
        } else {
            self.tblPromoList.addSubview(pullToRefreshCtrl)
        }
    }
    
    @objc func pullToRefreshClick(sender:UIRefreshControl) {
        isRefreshing = true
//        limit = 10
//        offset = 0
        self.callWsGetPromoCodeList()
    }
}
