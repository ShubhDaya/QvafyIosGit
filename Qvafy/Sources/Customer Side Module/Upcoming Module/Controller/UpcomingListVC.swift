//
//  UpcomingListVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 26/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//



import UIKit
import SlideMenuControllerSwift
var UpcomingListDateTime = ""
class UpcomingListVC: UIViewController  {
    
    //MARK: Outlets
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var vwTable: UIView!
    @IBOutlet weak var vwNoData: UIView!
    @IBOutlet weak var tblUpcoming: UITableView!
    @IBOutlet weak var vwBottom: UIView!
    
    // localisation Outlets -
    
    @IBOutlet weak var lblLOUpcomingHeader: UILabel!
    @IBOutlet weak var lblLONoOrderHere: UILabel!

    //MARK: - Variables
    
    var arrUpcomingList:[UpcomingModel] = []
    var strRestaurantId = ""
    var strOrderID = ""
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
        
        self.txtSearch.delegate = self
        if objAppShareData.isFromBannerNotification == true {
            let sb = UIStoryboard(name: "Upcoming", bundle: nil)
            let detailVC = sb.instantiateViewController(withIdentifier: "UpcomingDetailVC") as! UpcomingDetailVC
            detailVC.strOrderId = objAppShareData.strBannerReferenceID
            self.navigationController?.pushViewController(detailVC, animated: false)
        }
        self.setPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
        self.localisation()
        objAppShareData.isUpcomingList = true
        print("viewWillAppear is called")
        self.vwNoData.isHidden = true
        self.vwTable.isHidden = true
        //  self.vwHeader.setviewbottomShadow()
        self.vwSearch.setShadowWithCornerRadius()
        self.txtSearch.attributedPlaceholder = NSAttributedString(string: "Search_for_restaurant".localize, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 11.7)!])
        self.removeAllData()
        self.callWsGetUpcomingList()
        self.tabBarController?.tabBar.isHidden = false
        // deepak new testing
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "refreshUpcomingUI"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "updateUpcomingUI"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
        // deepak new testing
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
    }
    
    @objc func refrershUI(){
        print("objAppShareData.isFromBannerNotification is \(objAppShareData.isFromBannerNotification)")
        self.txtSearch.resignFirstResponder()
       // self.removeAllData()
        self.arrUpcomingList.removeAll()
        self.limit = 10
        self.offset = 0
        self.strSearchText = ""
        self.txtSearch.text = ""
        self.isFromForgroundNotification = true
        self.isRefreshing = true
       // self.callWsGetUpcomingList()
        self.callWsGetUpcomingListforNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        objAppShareData.isOnMapScreen = false
        objAppShareData.isUpcomingList = false
        NotificationCenter.default.removeObserver(self)
        self.isFromForgroundNotification = false
    }
    
 
    
    func localisation(){
        self.lblLOUpcomingHeader.text  = "Upcoming".localize
        self.lblLONoOrderHere.text  = "No_order_here".localize
        self.txtSearch.placeholder = "Search_for_restaurant".localize
    }
    
    func removeAllData(){
        self.arrUpcomingList.removeAll()
        self.limit = 10
        self.offset = 0
        self.strSearchText = ""
        self.txtSearch.text = ""
       // self.tblUpcoming.reloadData()
    }
    
    //MARK: - Button Action
    @IBAction func btnSideMenu(_ sender: Any) {
        self.view.endEditing(true)
        self.slideMenuController()?.toggleLeft()
    }
}

//MARK: - Extension UITableViewDelegate and UITableViewDataSource

extension UpcomingListVC : UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrUpcomingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblUpcoming.dequeueReusableCell(withIdentifier: "PastOrderCell")as! PastOrderCell
        if self.arrUpcomingList.count > 0 {
        let obj = self.arrUpcomingList[indexPath.row]
        cell.lblRestaurant.text = obj.strRestaurantName.capitalizingFirstLetter()
        cell.lblPrice.text = "$" + obj.strTotalAmount
        cell.vwDotted.creatDashedLine(view: cell.vwDotted)
        cell.showItemswithId(obj: obj)
        
        //        obj.strCurrentStatus = "4"
        
        let profilePic = obj.strAvatar
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgRestaurant.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "squre_placeholder_img"))
        }
        if obj.strCurrentStatus == "0"{
            cell.lblTime.isHidden = true
            cell.btnCancel.isHidden = false
        }else{
            cell.btnCancel.isHidden = true
            cell.lblTime.isHidden = false
        }
        cell.lblTime.text = obj.strRemainingTime
        if obj.strCurrentStatus == "0"{
            cell.lblStatus.text = " \("Pending".localize) "
            cell.lblStatus.textColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1) // fda500
            cell.vwStatus.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9098039216, blue: 0.8470588235, alpha: 1) //f1e8d8
        }else if obj.strCurrentStatus == "1" {
            cell.lblStatus.text = " \("Accepted".localize) "
            cell.lblStatus.textColor = #colorLiteral(red: 0, green: 0.6241818666, blue: 0.01543622091, alpha: 0.9134022887) // 009207
            cell.vwStatus.backgroundColor =  #colorLiteral(red: 0.8470588235, green: 0.9019607843, blue: 0.8509803922, alpha: 1)  //d8e6d9
        } else if obj.strCurrentStatus == "2"{
            cell.lblStatus.text = " \("Cooking".localize) "
            cell.lblStatus.textColor =  #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1) // fda500
            cell.vwStatus.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9098039216, blue: 0.8470588235, alpha: 1) //f1e8d8
        }else if obj.strCurrentStatus == "3" {
            cell.lblStatus.text = " \("Pickup".localize) "
            
            
            cell.lblStatus.textColor = #colorLiteral(red: 0.2784313725, green: 0.3254901961, blue: 0.9803921569, alpha: 1) // 4753fa
            cell.vwStatus.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.9490196078, blue: 0.9882352941, alpha: 1)  // #e9f2fc
            
            
        }else if obj.strCurrentStatus == "4" {
            // cell.lblStatus.text = " Recived "
            cell.lblStatus.text = " \("Picked_by_driver".localize) "
            cell.lblStatus.textColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1) // fda500
            cell.vwStatus.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9098039216, blue: 0.8470588235, alpha: 1) //f1e8d8
        } else if obj.strCurrentStatus == "5"{
            cell.lblStatus.text = " \("In_Route".localize) "
            cell.lblStatus.textColor = #colorLiteral(red: 0, green: 0.5725490196, blue: 0.02745098039, alpha: 1) // 009207
            cell.vwStatus.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.9019607843, blue: 0.8509803922, alpha: 1) //d8e6d9
        }else if obj.strCurrentStatus == "7" {
            cell.lblStatus.text = " \("Cancelled".localize) "
            cell.lblStatus.textColor = #colorLiteral(red: 1, green: 0.368627451, blue: 0, alpha: 1) // ff5e00
            cell.vwStatus.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.8823529412, blue: 0.8470588235, alpha: 1) // f1e1d8
        }
        
        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        if arrUpcomingList.count > 0 {

        let obj = arrUpcomingList[indexPath.row]
        print("obj.strUserID in didselect \(obj.strOrderID)")
        let sb = UIStoryboard(name: "Upcoming", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "UpcomingDetailVC") as! UpcomingDetailVC
        detailVC.strOrderId = obj.strOrderID
        self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @objc func buttonClicked(sender:UIButton) {
        if arrUpcomingList.count > 0 {
        let obj = self.arrUpcomingList[sender.tag]
        
        self.strOrderID = obj.strOrderID
        self.deleteData()
        // self.callWsForCancelOrder(strOrderId: obj.strOrderID)
        }
    }
    
    func deleteData(){
        let alert = UIAlertController(title: kAlert, message: "Are_you_sure_you_want_to_cancel_your_order?".localize, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No".localize, style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            self.callWsForCancelOrder(strOrderId: self.strOrderID)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UpcomingListVC {
    
    
    // TODO: Webservice For getUpcomingList
    func callWsGetUpcomingList(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        
        if isRefreshing{
            objWebServiceManager.StopIndicator()
        }else if self.isSearching{
            objWebServiceManager.StopIndicator()
        }else if self.isFromForgroundNotification{
            objWebServiceManager.StopIndicator()
        }else{
            objWebServiceManager.StartIndicator()
        }
        
        objWebServiceManager.requestGet(strURL:WsUrl.getUpcomingList+"limit="+String(self.limit)+"&offset="+String(self.offset)+"&search="+self.strSearchText+"&restaurant_id="+self.strRestaurantId,
                                        Queryparams: [:], body: nil, strCustomValidation: "", success: {response in
                                            
                                            print(response)
                                            objWebServiceManager.StopIndicator()
                                            
                                            let status =   (response["status"] as? String)
                                            let message =  (response["message"] as? String)
                                            
                                            if self.isRefreshing{
                                                self.arrUpcomingList.removeAll()
                                            }
                                            self.isRefreshing = false
                                            self.pullToRefreshCtrl.endRefreshing()
                                            if status == "success"{
                                                let dict  = response["data"] as? [String:Any]
                                                
                                                //  self.totalRecords = dict?["total_records"] as? Int ?? 0
                                                
                                                
                                                if  let  dataFound = dict?["data_found"] as? Int  {
                                                    if dataFound == 1 {
                                                        
                                                        // deepak new testing
                                                        if objAppShareData.isFromBannerNotification == true {
                                                            objAppShareData.resetBannarData()
                                                        }
                                                        // deepak new testing
                                                        
                                                        self.vwNoData.isHidden = true
                                                        self.vwTable.isHidden = false
                                                        
                                                        
                                                        self.totalRecords = dict?["total_records"] as? Int ?? 0
                                                        
                                                        if let currentDatetime  = dict?["current_time"] as? String {
                                                            print("self.currentDatetime in string is \(currentDatetime)")
                                                            UpcomingListDateTime = currentDatetime
                                                        }
                                                        
                                                        if let arrUpcomingData = dict?["upcoming_list"] as? [[String:Any]]{
                                                            for dictUpcomingData in arrUpcomingData{
                                                                let objUpcomingData = UpcomingModel.init(dict: dictUpcomingData)
                                                                self.arrUpcomingList.append(objUpcomingData)
                                                            }
                                                            
                                                            print("arrUpcomingList count is \(self.arrUpcomingList.count)")
                                                            
                                                            
                                                            
                                                        }
                                                        
                                                    }else{
                                                        self.vwNoData.isHidden = false
                                                        self.vwTable.isHidden = true
                                                        
                                                    }
                                                    
                                                }
                                                print("self.totalRecords count is \(self.totalRecords)")
                                                
                                                self.tblUpcoming.reloadData()
                                            }else
                                            {
                                                objAlert.showAlert(message:message ?? "", title: kAlert, controller: self)
                                            }
                                        }, failure: { (error) in
                                            print(error)
                                            objWebServiceManager.StopIndicator()
                                            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
                                            
                                        })
        
    }
    
    
    // TODO: Webservice For getUpcomingList when user in upcoming list and notification came
    func callWsGetUpcomingListforNotification(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        
        if isRefreshing{
            objWebServiceManager.StopIndicator()
        }else if self.isSearching{
            objWebServiceManager.StopIndicator()
        }else if self.isFromForgroundNotification{
            objWebServiceManager.StopIndicator()
        }else{
            objWebServiceManager.StartIndicator()
        }
        
        objWebServiceManager.requestGet(strURL:WsUrl.getUpcomingList+"limit="+String(self.limit)+"&offset="+String(self.offset)+"&search="+self.strSearchText+"&restaurant_id="+self.strRestaurantId,
                                        Queryparams: [:], body: nil, strCustomValidation: "", success: {response in
                                            
                                            
                                            print(response)
                                            objWebServiceManager.StopIndicator()
                                            
                                            
                                            let status =   (response["status"] as? String)
                                            let message =  (response["message"] as? String)
                                            
                                            if self.isRefreshing{
                                                self.arrUpcomingList.removeAll()
                                            }
                                            self.isRefreshing = false
                                            self.pullToRefreshCtrl.endRefreshing()
                                            if status == "success"{
                                                let dict  = response["data"] as? [String:Any]
                                                
                                                
                                                //  self.totalRecords = dict?["total_records"] as? Int ?? 0
                                                
                                                
                                                if  let  dataFound = dict?["data_found"] as? Int  {
                                                    if dataFound == 1 {
                                                        
                                                        // deepak new testing
                                                        if objAppShareData.isFromBannerNotification == true {
                                                            objAppShareData.resetBannarData()
                                                        }
                                                        // deepak new testing
                                                        
                                                        self.vwNoData.isHidden = true
                                                        self.vwTable.isHidden = false
                                                        
                                                        
                                                        self.totalRecords = dict?["total_records"] as? Int ?? 0
                                                        
                                                        if let currentDatetime  = dict?["current_time"] as? String {
                                                            print("self.currentDatetime in string is \(currentDatetime)")
                                                            UpcomingListDateTime = currentDatetime
                                                        }
                                                        
                                                        if let arrUpcomingData = dict?["upcoming_list"] as? [[String:Any]]{
                                                            
                                                            self.arrUpcomingList.removeAll()
                                                            for dictUpcomingData in arrUpcomingData{
                                                                let objUpcomingData = UpcomingModel.init(dict: dictUpcomingData)
                                                                self.arrUpcomingList.append(objUpcomingData)
                                                            }
                                                            
                                                            print("arrUpcomingList count is \(self.arrUpcomingList.count)")
                                                            
                                                            
                                                            
                                                        }
                                                        
                                                    }else{
                                                        self.vwNoData.isHidden = false
                                                        self.vwTable.isHidden = true
                                                        
                                                    }
                                                    
                                                }
                                                print("self.totalRecords count is \(self.totalRecords)")
                                                
                                                self.tblUpcoming.reloadData()
                                            }else
                                            {
                                                objAlert.showAlert(message:message ?? "", title: kAlert, controller: self)
                                            }
                                        }, failure: { (error) in
                                            print(error)
                                            objWebServiceManager.StopIndicator()
                                            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
                                            
                                        })
        
    }
    
    
    
    // TODO: Webservice For cancel Order
    func callWsForCancelOrder(strOrderId:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
         objWebServiceManager.StartIndicator()  // deepak new works
        
        var param: [String: Any] = [:]
        param = [
            WsParam.orderID: strOrderId
        ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.cancelOrder, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
        //   objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                self.removeAllData()
                self.callWsGetUpcomingList()
                
            } else {
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
            
        }, failure: { (error) in
            print(error)
            // objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
    }
    
}

//MARK:- Pagination
extension UpcomingListVC {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((self.tblUpcoming.contentOffset.y + self.tblUpcoming.frame.size.height) >= self.tblUpcoming.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if self.arrUpcomingList.count == self.totalRecords {
                        
                    }else {
                        print("api calling in pagination ")
                        self.callWsGetUpcomingList()
                    }
                }
            }
        }
    }
}

//MARK: - searching operation
extension UpcomingListVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let text = textField.text! as NSString
        
        if (text.length == 1) && (string == "") {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            strSearchText = ""
            self.arrUpcomingList.removeAll()
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
        self.arrUpcomingList.removeAll()
        self.limit = 10
        self.offset = 0
        print("api calling in searching")
        self.callWsGetUpcomingList()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
}

//MARK: - Pull to refresh list
extension UpcomingListVC{
    func setPullToRefresh(){
        pullToRefreshCtrl = UIRefreshControl()
        pullToRefreshCtrl.addTarget(self, action: #selector(self.pullToRefreshClick(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tblUpcoming.refreshControl = pullToRefreshCtrl
        } else {
            self.tblUpcoming.addSubview(pullToRefreshCtrl)
        }
    }
    
    @objc func pullToRefreshClick(sender:UIRefreshControl) {
        isRefreshing = true
        limit = 10
        offset = 0
        self.callWsGetUpcomingList()
    }
}


