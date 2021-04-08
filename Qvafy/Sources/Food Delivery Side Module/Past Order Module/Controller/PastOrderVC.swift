////
////  PastOrderVC.swift
////  Qvafy
////
////  Created by ios-deepak b on 25/08/20.
////  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
////

import UIKit

class PastOrderVC: UIViewController  {

    //MARK: Outlets

    //@IBOutlet weak var vwHeader: UIView!
   // @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var vwTable: UIView!
    @IBOutlet weak var vwNoData: UIView!
    @IBOutlet weak var tblPastOrder: UITableView!
    @IBOutlet weak var lblChatCount: UILabel!
    
    // Localisation Outlets -
    @IBOutlet weak var lblPastorderHeaders: UILabel!
    @IBOutlet weak var lblLONoPastOrderHere: UILabel!
    
  //  @IBOutlet weak var vwBottom: UIView!

    //MARK: - Variables

    var arrPastOrderList:[PastOrderModel] = []
    var strRestaurantId = ""

    //Searching & pagination
  ///  var strSearchText = ""
    var isDataLoading:Bool=false
    var isSearching:Bool=false
    var limit:Int=10
    var offset:Int=0
    var totalRecords = Int()

    // Refresh
   var pullToRefreshCtrl:UIRefreshControl!
      var isRefreshing = false

    
    
    //MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPullToRefresh()
        if objAppShareData.isFromBannerNotification == true {
            
            let sb = UIStoryboard(name: "PastOrder", bundle: nil)
                   let detailVC = sb.instantiateViewController(withIdentifier: "PastOrderDetailVC") as! PastOrderDetailVC
                   detailVC.strOrderId = objAppShareData.strBannerReferenceID
                   self.navigationController?.pushViewController(detailVC, animated: false)
    
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.localization()
        print("viewWillAppear is called")
        self.lblChatCount.layer.cornerRadius = self.lblChatCount.frame.height/2
        self.lblChatCount.clipsToBounds = true
         objAppShareData.showChatCountFromFirebase(lbl: self.lblChatCount)
 self.tabBarController?.tabBar.isHidden = false
        self.vwNoData.isHidden = true
        self.vwTable.isHidden = true
    
        self.removeAllData()
        self.callWsGetPastOrderList()
  
      
    }


    func removeAllData(){
        self.arrPastOrderList.removeAll()
        self.limit = 10
        self.offset = 0
      //  self.strSearchText = ""
      //  self.txtSearch.text = ""
        self.tblPastOrder.reloadData()
    }
    
    
    
    
    func localization(){
        
        self.lblLONoPastOrderHere.text = "No_past_order_here".localize
        self.lblPastorderHeaders.text = "Past_Order".localize
    }



    //MARK: - Button Action
//
//    @IBAction func btnBack(_ sender: Any) {
//        self.view.endEditing(true)
//        self.navigationController?.popViewController(animated: true)
//    }

    @IBAction func btnChatAction(_ sender: Any) {
        self.view.endEditing(true)
       let sb = UIStoryboard(name: "Chat", bundle: nil)
              let detailVC = sb.instantiateViewController(withIdentifier: "ChatHistoryVC") as! ChatHistoryVC
              self.navigationController?.pushViewController(detailVC, animated: true)

    }
}

//MARK: - Extension UITableViewDelegate and UITableViewDataSource

extension PastOrderVC : UITableViewDelegate ,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.arrPastOrderList.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblPastOrder.dequeueReusableCell(withIdentifier: "PastOrderCell")as! PastOrderCell
        
        if arrPastOrderList.count > 0 {

        let obj = self.arrPastOrderList[indexPath.row]
      // cell.vwContainer.setShadowWithCornerRadius()//
        cell.lblRestaurant.text = obj.strRestaurantName.capitalizingFirstLetter()
        cell.lblPrice.text = "$" + obj.strTotalAmount
        cell.lblCoustomer.text = obj.strCustomerName.capitalizingFirstLetter()
        cell.setCorners()
        if obj.strCurrentStatus == "6"{
            cell.lblStatus.text = " \("Completed".localize) "

            cell.vwStatus.backgroundColor = #colorLiteral(red: 0, green: 0.5725490196, blue: 0.02745098039, alpha: 1)
        }else if obj.strCurrentStatus == "7" {
            cell.lblStatus.text = " \("Cancelled".localize) "

            cell.vwStatus.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.07450980392, blue: 0.07450980392, alpha: 1)

        }

        //cell.vwProfile.setProfileVerifyView(vwOuter: cell.vwProfile, img: cell.imgCustomer)

        cell.vwProfile.setUserProfileView(vwOuter: cell.vwProfile, img: cell.imgCustomer , radius : 4)

        let profilePic = obj.strRestaurantImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgRestaurant.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "detail_upper_placeholder_img"))
        }

        let Pic = obj.strCustomerImage
        if Pic != "" {
            let url = URL(string: Pic)
            cell.imgCustomer.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user_placeholder_img_new"))
        }

      //  let date = objAppShareData.changeDateformatWithDate(strDate: obj.strCreatedAt )
        let date = objAppShareData.convertLocalTime(strDateTime: obj.strCreatedAt)
        print("date is is \(date)")

        if obj.strCreatedAt.isEmpty == false {
//            let fullNameArr = date.characters.split{$0 == ", "}.map(String.init)
          //  let fullNameArr = date.split(separator: ",")
            let fullNameArr = date.components(separatedBy: ", ")
            cell.lblDate.text = fullNameArr[0]
            cell.lblTime.text = fullNameArr[1]
        }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if arrPastOrderList.count > 0 {
            
            let obj = arrPastOrderList[indexPath.row]

            print("obj.strUserID in didselect \(obj.strOrderID)")

            let sb = UIStoryboard(name: "PastOrder", bundle: nil)
            let detailVC = sb.instantiateViewController(withIdentifier: "PastOrderDetailVC") as! PastOrderDetailVC
            detailVC.strOrderId = obj.strOrderID

            self.navigationController?.pushViewController(detailVC, animated: true)
        }
 
    }

}



extension PastOrderVC {


    // TODO: Webservice For getPastOrder
    func callWsGetPastOrderList(){

        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
               objWebServiceManager.StartIndicator()
        
        if isRefreshing{
            objWebServiceManager.StopIndicator()
        }
objWebServiceManager.requestGet(strURL:WsUrl.getPastOrder+"limit="+String(self.limit)+"&offset="+String(self.offset),
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

                     //   self.totalRecords = Int(dict?["total_records"] as? String ?? "") ?? 0

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
            }else
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

//MARK:- Pagination
extension PastOrderVC {

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




//MARK: - Pull to refresh list
extension PastOrderVC{
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
