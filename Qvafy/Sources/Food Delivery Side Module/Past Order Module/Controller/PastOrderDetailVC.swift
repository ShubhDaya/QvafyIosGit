
import UIKit
import SDWebImage
import HCSStarRatingView
class PastOrderDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    
    //MARK: - Outlets
    
       @IBOutlet weak var vwCustomerProfile: UIView!
       @IBOutlet weak var imgCustomerProfile: UIImageView!
       @IBOutlet weak var lblCustomerName: UILabel!
       @IBOutlet weak var lblPaymentType: UILabel!
       @IBOutlet weak var imgRestaurant: UIImageView!
       @IBOutlet weak var vwStatus: UIView!
       @IBOutlet weak var lblStatus: UILabel!
       @IBOutlet weak var lblRestaurantName: UILabel!
       @IBOutlet weak var lblRating: UILabel!
       @IBOutlet weak var lblTime: UILabel!
       @IBOutlet weak var lblDistance: UILabel!

       @IBOutlet weak var lblTotalItemPrice: UILabel!
       @IBOutlet weak var lblDeliveryFee: UILabel!
       @IBOutlet weak var lblOffer: UILabel!
       @IBOutlet weak var lblPay: UILabel!
       @IBOutlet weak var lblOfferTitle: UILabel!
       @IBOutlet weak var vwOffer: UIView!

       @IBOutlet weak var vwReviewRating: UIView!
       @IBOutlet weak var vwTxt: UIView!
       @IBOutlet weak var vwSubTxt: UIView!
       @IBOutlet weak var vwRating: HCSStarRatingView!
       
       @IBOutlet weak var lblRatingText: UILabel!
       
       @IBOutlet weak var imgDotted: UIImageView!



      @IBOutlet weak var viewForCornerRadius: UIView!
      @IBOutlet weak var tblhieghtconstraints: NSLayoutConstraint!
      @IBOutlet weak var tblRestraList: UITableView!
    
      //Localization outlets -
      
    @IBOutlet weak var lblLOCustomerInfo: UILabel!
    @IBOutlet weak var lblLOItemIndo: UILabel!
    @IBOutlet weak var lblBillDetails: UILabel!
    @IBOutlet weak var lblLOtotalItemPrice: UILabel!
    @IBOutlet weak var lblLODeliveryFees: UILabel!
    @IBOutlet weak var lblLOTotalPay: UILabel!
    
    //MARK: - Varibles
       var arrItemList:[ItemModel] = []
       var strOrderId = ""
       var strRestaurantImage = ""
       var strCurrentStatus = ""

    var deliveryId = ""
    
    var isFromForgroundNotification = false


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblRestraList.dataSource = self
        self.tblRestraList.delegate = self


        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localization()
            //    callWSForQouteDetails()
        //viewForCornerRadius.setViewAllRadius()
         self.tabBarController?.tabBar.isHidden = true
        self.setUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
    }
    
    @objc func updateUI(){
        self.isFromForgroundNotification = true
        self.callWsForOrderDetail()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        self.isFromForgroundNotification = false

        NotificationCenter.default.removeObserver(self)

        }
    
    
    func setUI(){
 
        self.vwCustomerProfile.setUserProfileView(vwOuter: self.vwCustomerProfile, img: self.imgCustomerProfile , radius : 4)

        self.callWsForOrderDetail()
//        self.tblRestraList.reloadData()
//        self.loadOrderDetail(dict: [:])
        DispatchQueue.main.async {
            self.viewForCornerRadius.roundCorners(corners: [.topLeft, .topRight], radius: 40.0)
             //self.vwSubTxt.setCornerRadBoarder(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cornerRadious: 8)
        }
    }
    
    func localization(){

        self.lblLOCustomerInfo.text = "Customer_Info".localize
        self.lblLOItemIndo.text = "Items_Info".localize
        self.lblBillDetails.text = "Bill_Details".localize
        self.lblLOtotalItemPrice.text = "Total_Items_Price".localize
        self.lblLODeliveryFees.text = "Delivery_Fee".localize
        self.lblLOTotalPay.text = "Total_Pay".localize
        
    }
    
    
    //MARK: - Button Action
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: tableView DataSource Delegate  -
      

    
    
   
    
      func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          self.viewWillLayoutSubviews()
      }

      override func viewWillLayoutSubviews() {
          super.updateViewConstraints()
          DispatchQueue.main.async {

        self.tblhieghtconstraints?.constant = self.tblRestraList.contentSize.height
        self.view.layoutIfNeeded()
          }
      }

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
          
          return arrItemList.count
         // return 10
          
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as!ItemCell

        let obj = self.arrItemList[indexPath.row]
               
               let quantity = obj.strQuantity
               cell.lblTitle.text = obj.strMenuName.capitalizingFirstLetter() + " (x" + quantity + ")"
               cell.lblPrice.text = "$" + obj.strMenuPrice

         return cell
    
      }
}



//MARK: - Api calling

extension PastOrderDetailVC {
    
    // TODO: Webservice For Order Detail
    
    func callWsForOrderDetail(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        
        if  self.isFromForgroundNotification != true{
               objWebServiceManager.StartIndicator()
        }
        
        var param: [String: Any] = [:]
        param = [
            WsParam.orderID: self.strOrderId
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.orderDetail, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                
                let dic  = response["data"] as? [String:Any]
                
                
                if  let  dataFound = dic?["data_found"] as? Int  {
                    if dataFound == 1 {
                        if objAppShareData.isFromBannerNotification == true {
                            objAppShareData.resetBannarData()
                        }
     
                        
                        self.arrItemList.removeAll()
                        
                        if let arrItemData = dic?["items_info"] as? [[String: Any]]{
                            for dictItemData in arrItemData
                            {
                                let objData = ItemModel.init(dict: dictItemData)
                                   self.arrItemList.append(objData)
                                  
                            }
                            print("self.arrItemList.count is \(self.arrItemList.count)")
                            
                        }
                         self.tblRestraList.reloadData()

                        
                        if let orderDetail = dic?["order_detail"] as? [String:Any]{
                            
                            self.loadOrderDetail(dict : orderDetail)
                            DispatchQueue.main.async {
                                self.viewForCornerRadius.roundCorners(corners: [.topLeft, .topRight], radius: 40.0)
                            }
                            
                        }
       
                    }else{
                        
                   ///     self.vwscroll.isHidden = true
                        // self.vwNoOrder.isHidden = false
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
    
    func loadOrderDetail(dict : [String:Any]){
        ///*
        if let currentStatus = dict["current_status"]as? String{
            //            print(  "currentStatus is \(currentStatus)")
            //              self.strCurrentStatus = currentStatus
            
            if currentStatus == "6"{
                self.lblStatus.text = " \("Completed".localize) "
                
                self.vwStatus.backgroundColor = #colorLiteral(red: 0, green: 0.5725490196, blue: 0.02745098039, alpha: 1)
            }else if currentStatus == "7" {
                self.lblStatus.text = " \("Cancelled".localize) "
                
                self.vwStatus.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.07450980392, blue: 0.07450980392, alpha: 1)
                
            }
        }
        
        if let avgRating = dict["restaurant_avg_rating"]as? String{
            let string = NSString(string: avgRating)
            self.lblRating.text = String(string.doubleValue)
        }
        
        
        if let createdAt = dict["created_at"]as? String{
          //  let date = objAppShareData.changeDateformatWithDate(strDate: createdAt)
            let date = objAppShareData.convertLocalTime(strDateTime: createdAt)
            self.lblTime.text = date
        }
                
        if let distance = dict["distance"]as? String {
            self.lblDistance.text =  distance + " \("Km".localize)"
        }
        
        if let name = dict["restaurant_name"]as? String {
            self.lblRestaurantName.text = name.capitalizingFirstLetter()
        }
        
        if let name = dict["customer_name"]as? String {
            self.lblCustomerName.text = name.capitalizingFirstLetter()
               }
        
        if let profilePic = dict["customer_image"]as? String{
            if profilePic != "" {
                let url = URL(string: profilePic)
                self.imgCustomerProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user_placeholder_img_new"))
            }else{
                self.imgCustomerProfile.image = UIImage.init(named: "user_placeholder_img_new")
            }
        }
        
        
        if let profile = dict["restaurant_image"]as? String{
            if profile != "" {
                let url = URL(string: profile)
                self.imgRestaurant.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "detail_upper_placeholder_img"))
            }else{
                self.imgRestaurant.image = UIImage.init(named: "detail_upper_placeholder_img")
            }
        }
        
        if let paymentMode = dict["payment_mode"]as? String{
            
            if paymentMode == "1" {
                self.lblPaymentType.text = "Cash_On_Delivery".localize
            }else if paymentMode == "2"{
                self.lblPaymentType.text = "Credit_Card".localize
                
            }
        }
     
        if let totalAmount = dict["total_item_price"]as? String{
            
            self.lblTotalItemPrice.text = "$" + totalAmount
        }
        
        if let shippingPrice = dict["delivery_charge"]as? String{
            self.lblDeliveryFee.text = "$" + shippingPrice
        }else  if let shippingPrice = dict["delivery_charge"]as? Int {
            self.lblDeliveryFee.text = "$" + String(shippingPrice)
        }
        
        if let total = dict["total_amount"]as? String{
            self.lblPay.text = "$" + total
        }
        
        if let discountAmount = dict["discount_amount"]as? String {
            var title = ""
            print(  "discountAmount is\(discountAmount)")
            
            if let discountTitle = dict["discount_title"]as? String{
                print(  "discountTitle is\(discountTitle)")
                
                title = discountTitle
            }
            
            if title == ""{
                 self.vwOffer.isHidden = true
            }else{
                 self.vwOffer.isHidden = false
                self.lblOffer.text = "-$" + discountAmount
                self.lblOfferTitle.text = title
                
            }
        }
        
        if let customerToDriver = dict["customer_review_to_driver"] as? [String:Any]{
            
            if let rating = customerToDriver["rating"]as? String {
                
                if let ratingData = Double(rating) {
                    self.vwRating.value  = CGFloat(ratingData)
                }
                  DispatchQueue.main.async {
                self.vwReviewRating.isHidden = false
                    self.vwTxt.isHidden = false
                      self.imgDotted.isHidden = false
                    
                }
                self.vwRating.isUserInteractionEnabled = false
             ///   self.vwDotted4.isHidden = false
                //  self.vwGiveReview.isHidden = true
            }else{
                self.vwReviewRating.isHidden = true
                self.vwTxt.isHidden = true
                 self.imgDotted.isHidden = true
              ///  self.vwDotted4.isHidden = true
                //                self.vwGiveReview.isHidden = false
            }
            
            
            if let review = customerToDriver["review"]as? String {
                self.lblRatingText.text =  review
                self.vwTxt.isUserInteractionEnabled = false
                
            }else{
                
            }
        }
  
    }
  
}
