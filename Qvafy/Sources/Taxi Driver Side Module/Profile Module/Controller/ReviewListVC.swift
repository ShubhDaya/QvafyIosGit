//
//  ReviewListVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 22/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
var currentDateForReview = ""
class ReviewListVC: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var vwNoRecord: UIView!
    @IBOutlet weak var tblReviewList: UITableView!
    @IBOutlet weak var vwHeader: UIView!
    
    
    // Localization outlet -
    
    @IBOutlet weak var lblReview: UILabel!
    
    @IBOutlet weak var lblLoNoReview: UILabel!
    //MARK: Varibles
    
    var strUserType = "1"
    var arrReviewList:[ReviewListModal] = []
    var isFromCustomer = false
    
    // pagination
    var isDataLoading:Bool=false
    var limit:Int=10
    var offset:Int=0
    var totalRecords = Int()
    
    var strNextPageUrl = ""
    // Refresh
   var pullToRefreshCtrl:UIRefreshControl!
      var isRefreshing = false
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPullToRefresh()

        self.vwNoRecord.isHidden = true
        tblReviewList.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        
        self.tblReviewList.estimatedRowHeight = 60
        self.tblReviewList.rowHeight = UITableView.automaticDimension
        self.tblReviewList.dataSource = self
        self.tblReviewList.delegate = self
   
    }
    

    override func viewWillAppear(_ animated: Bool) {
     
        self.lblReview.text = "Reviews".localize
        self.lblLoNoReview.text = "No_review_here".localize

        self.vwHeader.setviewbottomShadow()
        
        self.strNextPageUrl = ""
        self.isDataLoading = false
        self.limit = 10
        self.offset = 0
        
        self.callWsForGetReviewList()
   
        
       // self.tblReviewList.reloadData()
        
    }
    
    //MARK: Button Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
//MARK: UITableViewDelegate & UITableViewDataSource

extension ReviewListVC : UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrReviewList.count
        //  return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblReviewList.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as!ReviewCell

                let obj = self.arrReviewList[indexPath.row]
                cell.reviewListCell(obj: obj )
   
        return cell
    }
}


extension ReviewListVC {
    // TODO: Webservice For get Review List
    
    func callWsForGetReviewList(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        
        if isRefreshing{
            objWebServiceManager.StopIndicator()
        }else{
            objWebServiceManager.StartIndicator()

        }
        var param =  [:] as [String : Any]
        
        
        var strWsUrl = ""
        
        if strNextPageUrl == ""
        {
            strWsUrl  = WsUrl.getReviewList
            
            param = [
                WsParam.limit: self.limit,
                WsParam.offset: self.offset,
                ] as [String : Any]
        }
        else
        {
            strWsUrl = strNextPageUrl
        }
        
        
        print(param)
        
        
        objWebServiceManager.requestGet(strURL: strWsUrl  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
            print(response)
            
            
            
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            if self.isRefreshing{
                self.arrReviewList.removeAll()
            }
            self.isRefreshing = false
            self.pullToRefreshCtrl.endRefreshing()
            if status == "success"{
                
                let dic  = response["data"] as? [String:Any]
                
                if  let  dataFound = dic?["data_found"] as? Int  {
                    if dataFound == 1 {
                        self.vwNoRecord.isHidden = true
                        self.tblReviewList.isHidden = false
                        
                    }else{
                        self.vwNoRecord.isHidden = false
                        self.tblReviewList.isHidden = true
                    }
                }
                
                self.totalRecords = Int(dic!["total_records"] as? String ?? "") ?? 0
                
                if let currentDatetime  = dic?["current_date"] as? String {
                    print("self.currentDatetime in string is \(currentDatetime)")
                    currentDateForReview = currentDatetime
                }
                
                if   let paging  = dic?["paging"] as? [String:Any]
                {
                    if let strNext  = paging["next"] as? String
                    {
                        self.strNextPageUrl = strNext
                    }
                    
                }
                
                if let arrReviewData = dic?["review_list"] as? [[String: Any]]{
                    
                    for dictListData in arrReviewData
                    {
                        let objListData = ReviewListModal.init(dict: dictListData)
                        self.arrReviewList.append(objListData)
                    }
                    print("self.arrReviewList.count is \(self.arrReviewList.count)")
                    
                }
                
               self.tblReviewList.reloadData()
                
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



//MARK:- Pagination
extension ReviewListVC {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tblReviewList.contentOffset.y + tblReviewList.frame.size.height) >= tblReviewList.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true

                    self.offset = self.offset+self.limit

                    if arrReviewList.count != totalRecords {

                            self.callWsForGetReviewList()
                    }else {
                        print("All records fetched")
                    }
                }
            }
        }
    }

}
//MARK: - Pull to refresh list
extension ReviewListVC{
    func setPullToRefresh(){
        pullToRefreshCtrl = UIRefreshControl()
        pullToRefreshCtrl.addTarget(self, action: #selector(self.pullToRefreshClick(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tblReviewList.refreshControl = pullToRefreshCtrl
        } else {
            self.tblReviewList.addSubview(pullToRefreshCtrl)
        }
    }
    
    @objc func pullToRefreshClick(sender:UIRefreshControl) {
        isRefreshing = true
        limit = 10
        offset = 0
        self.strNextPageUrl = ""
        self.callWsForGetReviewList()
    }
}
