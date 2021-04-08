
//
//  CustomerPastOrder.swift
//  Qvafy
//
//  Created by ios-deepak b on 26/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class CustomerPastOrder: UIViewController  {
    
    //MARK: Outlets
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var vwTable: UIView!
    @IBOutlet weak var vwNoData: UIView!
    @IBOutlet weak var tblPastOrder: UITableView!
    @IBOutlet weak var vwBottom: UIView!
    
    // localisation Outlets -
    @IBOutlet weak var lblLOPastOrder: UILabel!
    @IBOutlet weak var lblLoNOPastOrderHere: UILabel!
    
    //MARK: - Variables
    
    var arrPastOrderList:[PastOrderModel] = []
    var strRestaurantId = ""
    
    //Searching & pagination
    var strSearchText = ""
    var isDataLoading:Bool=false
    var isSearching:Bool=false
    var limit:Int=10
    var offset:Int=0
    var totalRecords = Int()
    // Refresh
   var pullToRefreshCtrl:UIRefreshControl!
      var isRefreshing = false
    
   var isFromForgroundNotification = false
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if objAppShareData.isFromBannerNotification == true {
            
            let sb = UIStoryboard(name: "CustomerProfile", bundle: nil)
            let detailVC = sb.instantiateViewController(withIdentifier: "CustomerPastOrderDetailVC") as! CustomerPastOrderDetailVC
            detailVC.strOrderId = objAppShareData.strBannerReferenceID
            self.navigationController?.pushViewController(detailVC, animated: false)
            
        }
        self.setPullToRefresh()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txtSearch.resignFirstResponder()

        self.localisation()
        print("viewWillAppear is called")
        self.vwNoData.isHidden = true
        self.vwTable.isHidden = true
        //  self.vwHeader.setviewbottomShadow()
        
        self.vwSearch.setShadowWithCornerRadius()
        self.txtSearch.attributedPlaceholder = NSAttributedString(string: "Search_for_restaurant".localize, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 11.7)!])
        
        self.removeAllData()
        self.callWsGetPastOrderList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
    }
    
    @objc func refrershUI(){
        self.txtSearch.resignFirstResponder()

        self.isFromForgroundNotification = true
        self.removeAllData()
        self.callWsGetPastOrderList()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.isFromForgroundNotification = false

        }
    
    
    func localisation(){
        
        self.lblLOPastOrder.text = "Past_Order".localize
        self.lblLoNOPastOrderHere.text = "No_past_order_here".localize
        self.txtSearch.placeholder = "Search_for_restaurant".localize
        
    }
    
    func removeAllData(){
        self.arrPastOrderList.removeAll()
        self.limit = 10
        self.offset = 0
        self.strSearchText = ""
        self.txtSearch.text = ""
        self.uiDesign()
    }
    
    func uiDesign(){
        self.txtSearch.delegate = self
        self.tblPastOrder.reloadData()
    }
    
    //MARK: - Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Extension UITableViewDelegate and UITableViewDataSource

extension CustomerPastOrder : UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrPastOrderList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblPastOrder.dequeueReusableCell(withIdentifier: "PastOrderCell")as! PastOrderCell
        
        let obj = self.arrPastOrderList[indexPath.row]
        cell.lblRestaurant.text = obj.strRestaurantName.capitalizingFirstLetter()
      
        cell.lblPrice.text = "$" + obj.strTotalAmount
        cell.vwDotted.creatDashedLine(view: cell.vwDotted)
        
        
        //cell.lblItems.text = obj.strTotalItems + " items"
        if obj.strTotalItems == "1"{
            cell.lblItems.text = obj.strTotalItems + " \("item".localize)"
            
        }else{
            cell.lblItems.text = obj.strTotalItems + " \("items".localize)"
        }
        
        if obj.strCurrentStatus == "6"{
            cell.lblStatus.text = " \("Delivered".localize) "
            cell.lblStatus.textColor = #colorLiteral(red: 0, green: 0.5725490196, blue: 0.02745098039, alpha: 1)
            // cell.lblStatus.sizeToFit()
            
            cell.vwStatus.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.9019607843, blue: 0.8509803922, alpha: 1)
        }else if obj.strCurrentStatus == "7" {
            cell.lblStatus.text = " \("Cancelled".localize) "
            cell.lblStatus.textColor = #colorLiteral(red: 1, green: 0.368627451, blue: 0, alpha: 1)
            cell.vwStatus.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.8823529412, blue: 0.8470588235, alpha: 1)
            
        }
        
        let string = NSString(string: obj.strRestAvgRating)
        cell.lblRating.text = String(string.doubleValue)
        
        let profilePic = obj.strRestaurantImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgRestaurant.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "squre_placeholder_img"))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if self.arrPastOrderList.count > 0 {
        self.txtSearch.resignFirstResponder()
            let obj = self.arrPastOrderList[indexPath.row]
        print("obj.strUserID in didselect \(obj.strOrderID)")
        let sb = UIStoryboard(name: "CustomerProfile", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "CustomerPastOrderDetailVC") as! CustomerPastOrderDetailVC
        detailVC.strOrderId = obj.strOrderID
        self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
}



extension CustomerPastOrder {
    
    
    // TODO: Webservice For getPastOrder
    func callWsGetPastOrderList(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }

        if isRefreshing{
            objWebServiceManager.StopIndicator()
        }else if self.isSearching{
            objWebServiceManager.StopIndicator()
        }else if self.isFromForgroundNotification != true{
            objWebServiceManager.StartIndicator()
        }else if self.isFromForgroundNotification{
            objWebServiceManager.StopIndicator()
        }else{
            objWebServiceManager.StartIndicator()

        }
        
        
        objWebServiceManager.requestGet(strURL:WsUrl.getPastOrder+"limit="+String(self.limit)+"&offset="+String(self.offset)+"&search="+self.strSearchText,
                                        Queryparams: [:], body: nil, strCustomValidation: "", success: {response in
                                            
                                            
                                            print(response)
                                            objWebServiceManager.StopIndicator()
                                            
                                            
                                            let status =   (response["status"] as? String)
                                            let message =  (response["message"] as? String)
                                            
                                            if self.isRefreshing{
                                                self.arrPastOrderList.removeAll()
                                            }
                                            self.isRefreshing = false
                                            self.pullToRefreshCtrl.endRefreshing()
                                            
                                            if status == "success"
                                            {
                                                let dict  = response["data"] as? [String:Any]
                                                //  self.totalRecords = dict?["total_records"] as? Int ?? 0
                                                if  let  dataFound = dict?["data_found"] as? Int  {
                                                    if dataFound == 1 {
                                                        
                                                        self.vwNoData.isHidden = true
                                                        self.vwTable.isHidden = false
                                 
                                                        self.totalRecords = dict?["total_records"] as? Int ?? 0
                                                        
                                                        
                                                        if let arrPastOrderData = dict?["past_order_list"] as? [[String:Any]]{
                                                            for dictPastOrderData in arrPastOrderData{
                                                                let objPastOrderData = PastOrderModel.init(dict: dictPastOrderData)
                                                                self.arrPastOrderList.append(objPastOrderData)
                                                            }
                                                            print("arrPastOrderList count is \(self.arrPastOrderList.count)")
                                                        }
                                                    }else{
                                                        self.vwNoData.isHidden = false
                                                        self.vwTable.isHidden = true
                                                        
                                                    }
                                                    
                                                }
                                                print("self.totalRecords count is \(self.totalRecords)")
                                                
                                                self.tblPastOrder.reloadData()
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

//MARK:- Pagination
extension CustomerPastOrder {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((self.tblPastOrder.contentOffset.y + self.tblPastOrder.frame.size.height) >= self.tblPastOrder.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if self.arrPastOrderList.count == self.totalRecords {
                        
                    }else {
                        print("api calling in pagination ")
                        self.callWsGetPastOrderList()
                    }
                }
            }
        }
    }
}

//MARK: - searching operation
extension CustomerPastOrder : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let text = textField.text! as NSString
        
        if (text.length == 1) && (string == "") {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            strSearchText = ""
            self.arrPastOrderList.removeAll()
            self.limit = 10
            self.offset = 0
            //self.reload()
            self.isSearching = true
            self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
            
        }else{
            var substring: String = textField.text!
            substring = (substring as NSString).replacingCharacters(in: range, with: string)
            substring = substring.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            self.isSearching = true
            searchAutocompleteEntries(withSubstring: substring)
        }
        return true
    }
    
    func searchAutocompleteEntries(withSubstring substring: String) {
        if substring != "" {
            strSearchText = substring
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
        }
    }
    
    @objc func reload() {
        self.arrPastOrderList.removeAll()
        self.limit = 10
        self.offset = 0
        print("api calling in searching")
        self.callWsGetPastOrderList()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

//MARK: - Pull to refresh list
extension CustomerPastOrder{
    func setPullToRefresh(){
        pullToRefreshCtrl = UIRefreshControl()
        pullToRefreshCtrl.addTarget(self, action: #selector(self.pullToRefreshClick(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tblPastOrder.refreshControl = pullToRefreshCtrl
        } else {
            self.tblPastOrder.addSubview(pullToRefreshCtrl)
        }
    }
    
    @objc func pullToRefreshClick(sender:UIRefreshControl) {
        isRefreshing = true
        limit = 10
        offset = 0
        self.callWsGetPastOrderList()
    }
}
