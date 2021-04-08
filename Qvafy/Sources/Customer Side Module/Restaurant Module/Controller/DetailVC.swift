

//
//  DetailVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 27/10/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import SwiftyJSON

class DetailVC: UIViewController,GMSMapViewDelegate {
    
    //MARK: Outlets
    
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var vwSubSearch: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnClearCart: UIButton!

    @IBOutlet weak var imgRestaurant: UIImageView!
    
    @IBOutlet weak var vwNoData: UIView!
    @IBOutlet weak var vwNoReview: UIView!
    @IBOutlet weak var vwNoCategory: UIView!
    
    @IBOutlet weak var vwStack: UIStackView!
    @IBOutlet weak var vwCollection: UICollectionView!
    @IBOutlet weak var tblMenu: UITableView!
   
    
    @IBOutlet weak var vwDirection: UIView!
    @IBOutlet weak var vwReviews: UIView!
    @IBOutlet weak var vwMenu: UIView!
    @IBOutlet weak var btnDirection: UIButton!
    @IBOutlet weak var btnReviews: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var lblReviews: UILabel!
    @IBOutlet weak var lblDirection: UILabel!
    
    
    @IBOutlet weak var viewShowHide: UIView!

    @IBOutlet weak var vwTopDirection: UIView!
    @IBOutlet weak var vwTopReviews: UIView!
    @IBOutlet weak var vwTopMenu: UIView!

    @IBOutlet weak var lblTopMenu: UILabel!
    @IBOutlet weak var lblTopReviews: UILabel!
    @IBOutlet weak var lblTopDirection: UILabel!
    

    @IBOutlet weak var vwRound: UIView!
    
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var vwSubBottom: UIView!
    
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    
    var typeView = 1
   // @IBOutlet weak var lblNoData: UILabel!
   //  @IBOutlet weak var lblMake: UILabel!
    
    
    @IBOutlet weak var vwDirection1: UIView!
    @IBOutlet weak var vwReviews1: UIView!
    @IBOutlet weak var vwMenu1: UIView!
    @IBOutlet weak var vwDirection1Height: NSLayoutConstraint!
    @IBOutlet weak var vwReviews1Height: NSLayoutConstraint!
    @IBOutlet weak var vwMenu1Height: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!

    
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblOpen: UILabel!
    @IBOutlet weak var lblBusiness_type: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
 
    @IBOutlet weak var vwDotted1: UIView!
    @IBOutlet weak var vwDotted2: UIView!
    @IBOutlet weak var vwRoundTop: NSLayoutConstraint!
    @IBOutlet weak var tblReviewList: UITableView!
    @IBOutlet weak var scrollviewww: UIScrollView!

    @IBOutlet weak var vwRoundHeight: NSLayoutConstraint!
    @IBOutlet weak var vwRoundBottom: NSLayoutConstraint!
    @IBOutlet weak var tblMenuHeight: NSLayoutConstraint!
    @IBOutlet weak var tblReviewListHeight: NSLayoutConstraint!
    
    // Localization outlets -
    
    @IBOutlet weak var lblLONoCategoryHere: UILabel!
    @IBOutlet weak var lblNoMenuHere: UILabel!
    @IBOutlet weak var lblLONoReviewHere: UILabel!
    @IBOutlet weak var lblLOIncTaxes: UILabel!
    @IBOutlet weak var lblLOViewCart: UILabel!
    
    
    
    //MARK: - Variables
    var lastContentOffset : CGFloat = 0
    var arrMenuList:[MenuModel] = []
    var arrHoldMenuList:[MenuModel] = []
    
    var arrList:[MenuModel] = []
    
    
    // var objArrList = MenuModel(dict: [:])
    
    
    var arrCategory:[CategoryModel] = []
    var strUserId :Int = 0
    
    var strlatitude = ""
    var strlongitude = ""
    var strRestaurantId = ""
    var strCategoryId: String = ""
    var strQuantity:Int = 0
    var strMenuId: String = ""
    
    //    var strTotalItems:Int = 0
    //       var strTotalAmount: String = ""
    
    var fromTime = ""
    var toTime = ""
    var strCloseingTime = ""
    var strOpeningTime = ""
    var isOpen = "1"
    var strRestaurantLat = ""
    var strRestaurantLong = ""
    
    
    
    //Searching & pagination
    var strSearchText = ""
    var isDataLoading:Bool=false
    var isSearching:Bool=false
    var limit:Int=100
    var offset:Int=0
    var totalRecords = Int()
    
    
    // for review list
    var arrReviewList:[ReviewListModal] = []
    var strNextPageUrl = ""
    
    var limitForReview:Int=100
    var offsetForReview:Int=0
    
    var isFirstAppear = false
    
    var strDataFound :Int = 0
    
    var strCartResturentId = ""
    
    var isFromForgroundNotification = false

    
    //MARK: LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isFirstAppear = true
        self.scrollviewww.delegate = self
        self.strCategoryId = ""
        self.viewShowHide.isHidden = true
        self.didLoadStupOfViews()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.Localization()
        self.setUI()
        //setNeedsStatusBarAppearanceUpdate()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//    .lightContent
//    }
    //MARK: - Custom Functions
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.isFromForgroundNotification = false
    }
    
    
    @objc func refrershUI(){
        self.isFromForgroundNotification = true
        self.clearSearch()

    }
    
    func setUI(){
        // self.tblMenu.isHidden = false
        
        self.designButtonUI(Type: 1)
        self.vwReviews.setCornerRadius(radius: Int(17.5))
        self.vwMenu.setCornerRadius(radius: Int(17.5))
        self.vwDirection.setCornerRadius(radius: Int(17.5))
        self.vwTopReviews.setCornerRadius(radius: Int(17.5))
        self.vwTopMenu.setCornerRadius(radius: Int(17.5))
        self.vwTopDirection.setCornerRadius(radius: Int(17.5))
        self.vwSubBottom.setCornerRadiusBoarder(color:  #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), cornerRadious: 8)
        
        self.vwSearch.isHidden = true
        
        self.vwNoData.isHidden = true
        self.vwNoReview.isHidden = true
        self.vwNoCategory.isHidden = true
        self.mapView.isHidden = true
        self.mapView.clear()
       // self.vwDotted1.creatDashedLine(view: vwDotted1)
       // self.vwDotted2.creatDashedLine(view: vwDotted2)
        self.vwSubSearch.setShadowWithCornerRadius()
        self.vwRound.roundCorners(corners: [.topLeft, .topRight], radius: 40.0)
        
        self.txtSearch.attributedPlaceholder = NSAttributedString(string: "Search_Item".localize, attributes: [NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 11.7)!])
        
        
        self.tblMenu.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        self.tblReviewList.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        
        //  self.loadData()
        
    }
    
    func designButtonUI(Type: Int){
        self.typeView = Type
        
        if Type == 1 {
            self.lblReviews.textColor =  #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
            self.lblDirection.textColor =  #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
            self.lblMenu.textColor =  #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
            self.vwMenu.backgroundColor =  #colorLiteral(red: 0.9960784314, green: 0.9176470588, blue: 0.7647058824, alpha: 1)
            self.vwReviews.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.vwDirection.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.lblTopReviews.textColor =  #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
            self.lblTopDirection.textColor =  #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
            self.lblTopMenu.textColor =  #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
            self.vwTopMenu.backgroundColor =  #colorLiteral(red: 0.9960784314, green: 0.9176470588, blue: 0.7647058824, alpha: 1)
            self.vwTopReviews.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.vwTopDirection.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.vwNoData.isHidden = true
            self.vwNoReview.isHidden = true
            self.vwNoCategory.isHidden = true
            self.vwStack.isHidden = true
            self.vwDotted2.isHidden = true
            self.mapView.isHidden = true
            self.vwBottom.isHidden = true
            self.tblReviewList.isHidden = true
            self.vwMenu1.isHidden = false
            self.vwDirection1.isHidden = true
            self.vwReviews1.isHidden = true
     
           // self.strCategoryId = ""
            self.callWsGetRestaurantDetail()
            //  self.callWsGetRestaurantMenuList()
            self.mapView.clear()
        }else if Type == 2 {
            self.lblMenu.textColor =  #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
            self.lblDirection.textColor =  #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
            self.lblReviews.textColor =  #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
            self.vwReviews.backgroundColor =  #colorLiteral(red: 0.9960784314, green: 0.9176470588, blue: 0.7647058824, alpha: 1)
            self.vwMenu.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.vwDirection.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.lblTopMenu.textColor =  #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
            self.lblTopDirection.textColor =  #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
            self.lblTopReviews.textColor =  #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
            self.vwTopReviews.backgroundColor =  #colorLiteral(red: 0.9960784314, green: 0.9176470588, blue: 0.7647058824, alpha: 1)
            self.vwTopMenu.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.vwTopDirection.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.vwNoData.isHidden = true
            self.vwNoReview.isHidden = true
            self.vwNoCategory.isHidden = true
            self.vwSearch.isHidden = true
            self.vwStack.isHidden = true
            self.vwDotted2.isHidden = true
            self.mapView.isHidden = true
            self.vwBottom.isHidden = true
            self.tblMenu.isHidden = true
            self.tblReviewList.isHidden = false
            self.mapView.clear()
            self.vwReviews1.isHidden = false
            self.vwMenu1.isHidden = true
            self.vwDirection1.isHidden = true
            self.limitForReview = 100
            self.offsetForReview = 0
            self.strNextPageUrl = ""
            self.arrReviewList.removeAll()
            //a
            
            self.callWsForGetReviewList()
        }else if Type == 3 {
            self.lblMenu.textColor =  #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
            self.lblReviews.textColor =  #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
            self.lblDirection.textColor =  #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
            self.vwDirection.backgroundColor =  #colorLiteral(red: 0.9960784314, green: 0.9176470588, blue: 0.7647058824, alpha: 1)
            self.vwMenu.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.vwReviews.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.lblTopMenu.textColor =  #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
            self.lblTopReviews.textColor =  #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
            self.lblTopDirection.textColor =  #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
            self.vwTopDirection.backgroundColor =  #colorLiteral(red: 0.9960784314, green: 0.9176470588, blue: 0.7647058824, alpha: 1)
            self.vwTopMenu.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.vwTopReviews.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            
            self.vwNoData.isHidden = true
            self.vwNoReview.isHidden = true
            self.vwNoCategory.isHidden = true
            self.vwSearch.isHidden = true
            self.vwStack.isHidden = true
            self.vwDotted2.isHidden = true
            self.tblMenu.isHidden = true
            self.tblReviewList.isHidden = true
            self.vwBottom.isHidden = true
            
            self.mapView.isHidden = false
            self.vwDirection1.isHidden = false
            self.vwMenu1.isHidden = true
            self.vwReviews1.isHidden = true
            
            
            if !objWebServiceManager.isNetworkAvailable(){
                objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
                
                return
            }else{
                self.drawPath()
            }
        }
        self.isFirstAppear = true
    }
    
    func Localization(){
       
        self.lblLONoCategoryHere.text = "No category here".localize
        self.lblNoMenuHere.text = "No_menu_here".localize
        self.lblLONoReviewHere.text = "No_review_here".localize
        self.lblLOIncTaxes.text = "(Incl_taxes)".localize
        self.lblLOViewCart.text = "View_Cart".localize
       
        self.lblTopMenu.text = "Menu".localize
        self.lblTopReviews.text = "Reviews".localize
        self.lblTopDirection.text = "Directions".localize

        self.lblMenu.text = "Menu".localize
        self.lblReviews.text = "Reviews".localize
        self.lblDirection.text = "Directions".localize
        self.txtSearch.placeholder = "Search_Item".localize
    }
    
    
    //MARK: - Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        self.view.endEditing(true)
        self.designButtonUI(Type: 1)
    }
    
    @IBAction func btnReviewAction(_ sender: Any) {
        self.view.endEditing(true)
        self.designButtonUI(Type: 2)
        //   objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
        //    let sb = UIStoryboard(name: "Restaurant", bundle: nil)
        //    let detailVC = sb.instantiateViewController(withIdentifier: "CartListVC") as! CartListVC
        //    self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @IBAction func btnDirectionAction(_ sender: Any) {
        self.view.endEditing(true)
        self.designButtonUI(Type: 3)
        
        
        // objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
    }
    
    @IBAction func btnSearch(_ sender: UIButton) {
        self.view.endEditing(true)
        self.scrollviewww.contentOffset = .zero
        
        if sender.tag == 0 {
            self.vwSearch.isHidden = false
            sender.tag = 1
            self.vwRoundTop.constant = -345  //-355 //  -365
            self.viewShowHide.isHidden = false
            
            if self.strDataFound == 1{
                
                self.tblMenu.reloadData()
            }
            
            DispatchQueue.main.async {
            self.tblMenu.contentSize = CGSize(width: 0.0 , height: self.tblMenu.contentSize.height + 200)
            self.view.layoutIfNeeded()
            }

            self.txtSearch.becomeFirstResponder()
            
        }else if sender.tag == 1 {
            sender.tag = 0
            self.vwRoundTop.constant = 0
            self.vwSearch.isHidden = true
            self.btnSearch.tag = 0
            self.viewShowHide.isHidden = true
            self.strSearchText = ""
            self.txtSearch.text = ""
            self.isSearching = false
            self.limit = 100
            self.offset = 0
            self.callWsGetRestaurantMenuList()
            self.txtSearch.resignFirstResponder()
            
        }
    }
    @IBAction func btnCancleSearch(_ sender: Any) {
        self.view.endEditing(true)
        self.vwSearch.isHidden = true
        self.btnSearch.tag = 0
        self.strSearchText = ""
        self.txtSearch.text = ""
        self.isSearching = false
        self.limit = 100
        self.offset = 0
        self.callWsGetRestaurantMenuList()
        self.txtSearch.resignFirstResponder()
        // deepak new testing
        self.clearSearch()
        // deepak new testing
    }
    
    
    // deepak new testing
    func clearSearch(){
    self.vwSearch.isHidden = true
    self.btnSearch.tag = 0
    self.strSearchText = ""
    self.txtSearch.text = ""
    self.isSearching = false
    self.limit = 100
    self.offset = 0
    self.callWsGetRestaurantMenuList()
    self.txtSearch.resignFirstResponder()

    }
    // deepak new testing
    
    
    
    @IBAction func btnViewCart(_ sender: Any) {
        self.view.endEditing(true)
        let sb = UIStoryboard(name: "Restaurant", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "CartListVC") as! CartListVC
        detailVC.strRestaurantId = self.strRestaurantId
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    @IBAction func btnClearCartItem(_ sender: Any) {
        self.view.endEditing(true)
        
        objAlert.showAlertCallBack(alertLeftBtn: "No".localize, alertRightBtn: "Yes".localize, title: kAlert.localize, message: "Are you sure you want to clear cart?".localize, controller: self) {
            self.callWsForDeleteCart(restaurantId : self.strCartResturentId )
        }
    }
}

//MARK: - Extension UICollectionViewDelegate & UICollectionViewDataSource and UICollectionViewDelegateFlowLayout

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCategory.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = vwCollection.dequeueReusableCell(withReuseIdentifier: "CetagoryCell", for: indexPath) as! CetagoryCell
        
        
        
        let obj = self.arrCategory[indexPath.row]
        cell.lblCetagory.text = obj.strCategoryName.capitalizingFirstLetter()
        
        if self.strCategoryId == obj.strCategoryId {
            
            cell.selectedHighletedView()
            
        }else{
            cell.selectedGrayView()
            
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let cell = vwCollection.dequeueReusableCell(withReuseIdentifier: "CetagoryCell", for: indexPath) as! CetagoryCell
        
        let obj = arrCategory[indexPath.row]
        
        self.strCategoryId = obj.strCategoryId
        
        print("obj.strCategoryId in didselect \(obj.strCategoryId)")
        self.vwCollection.reloadData()
        self.callWsGetRestaurantMenuList()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = self.arrCategory[indexPath.item].strCategoryName
        label.sizeToFit()
        return CGSize(width: label.frame.width + 10, height: 32)
    }
    
}

//MARK: - Extension UITableViewDelegate and UITableViewDataSource


extension DetailVC : UITableViewDelegate ,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var count = 0
        
        if tableView == self.tblReviewList {
            //  count =  arrReviewList.count
            count =  1
        }else if tableView == self.tblMenu {
            count =  self.arrMenuList.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if tableView == self.tblReviewList {
            title = ""
        }else if tableView == self.tblMenu{
            title = self.arrMenuList[section].strSubCategory
        }
        
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        if tableView == self.tblMenu {
            print("self.arrMenuList.count is \(self.arrMenuList.count)")
            let items = self.arrMenuList[section].arrList.count
            count = items
        }else if tableView == self.tblReviewList  {
            print("self.arrReviewList.count in table is \(self.arrReviewList.count)")
            count = arrReviewList.count
        }
        DispatchQueue.main.async {
            if tableView == self.tblMenu{
                
//                self.tblMenu.rowHeight = UITableView.automaticDimension
//                self.tblMenu.estimatedRowHeight = 100.0
                self.tblMenuHeight.constant = self.tblMenu.contentSize.height + 150
                //self.scrollviewww.contentSize.height = self.tblMenuHeight.constant + 470
                
                print("self.tblMenuHeight.constant is \(self.tblMenuHeight.constant)")
            }else {
                self.tblReviewListHeight.constant = self.tblReviewList.contentSize.height
                //self.scrollviewww.contentSize.height = self.tblReviewListHeight.constant + 470
                
                print("self.tblReviewListHeight.constant is \(self.tblReviewListHeight.constant)")
               
            }
            self.view.layoutIfNeeded()
        }
        return count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tblMenu {
            
            let cell = tblMenu.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as!MenuCell
            if self.arrMenuList.count > 0 {
            
            let obj = self.arrMenuList[indexPath.section].arrList[indexPath.row]
            
            cell.isOpen = self.isOpen
            cell.checkUI()
            
            cell.lblTitle.text = obj.strName.capitalizingFirstLetter()
            cell.lblPrice.text = "$" + obj.strPriceWithCommision
            cell.lblQuantity.text = obj.strQuantity
      
            if obj.strQuantity == "" {
                cell.viewSubstract.isHidden = true
                cell.viewCount.isHidden = true
                cell.btnSubstract.isUserInteractionEnabled = false
                cell.lblQuantity.isHidden = true
                cell.imgSubstract.isHidden = true
            }else{
                cell.viewSubstract.isHidden = false
                cell.viewCount.isHidden = false
                cell.btnSubstract.isUserInteractionEnabled = true
                cell.lblQuantity.isHidden = false
                cell.imgSubstract.isHidden = false
            }

            if self.isOpen == "1"{
                if obj.strAvatar != "" {
                    let url = URL(string: obj.strAvatar)
                    cell.imgMenu.sd_setImage(with: url, placeholderImage:  #imageLiteral(resourceName: "circle_placeholder_img"))
                }else{
                    cell.imgMenu.image = UIImage.init(named: "circle_placeholder_img")
                }
                
            } else if self.isOpen == "0"{
                cell.imgMenu.image = nil
                cell.imgMenu.backgroundColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                
            }
            ///  cell.menuListCell(obj:obj , isOpen : self.isOpen)
            
            cell.btnAdd.tag = indexPath.row
            cell.btnAdd.superview!.tag = indexPath.section
            cell.btnAdd.addTarget(self,action:#selector(buttonAddClicked), for: .touchUpInside)
            cell.btnSubstract.tag = indexPath.row
            cell.btnSubstract.superview!.tag = indexPath.section
            cell.btnSubstract.addTarget(self,action:#selector(buttonSubstractClicked), for: .touchUpInside)
            cell.checkUI()
            }
      
            return cell
            
        }else  {
            //}else if tableView == self.tblReviewList {
            let cell = tblReviewList.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as!ReviewCell
            
            let obj = self.arrReviewList[indexPath.row]
            cell.reviewListCell(obj: obj )
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tblReviewList {
            return nil
            
        }else{
            
            let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
            if arrMenuList.count > 0 {
            sectionView.backgroundColor = UIColor.white
            
            let sectionName = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
            sectionName.text = self.arrMenuList[section].strSubCategory.capitalizingFirstLetter()
            
            if self.isOpen == "1"{
                
                sectionName.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                
            }else if self.isOpen == "0" {
                sectionName.textColor =  #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 1)
            }
            sectionName.font = UIFont(name: "Poppins-Medium", size: 16.7)!
            
            sectionName.textAlignment = .left
            
            sectionView.addSubview(sectionName)
            }
            return sectionView
        }
    }
    
    
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                DispatchQueue.main.async {
                    if tableView == self.tblMenu{
//                        self.tblMenu.rowHeight = UITableView.automaticDimension
//                        self.tblMenu.estimatedRowHeight = 100.0
                        self.tblMenuHeight.constant = self.tblMenu.contentSize.height + 150
                        //self.scrollviewww.contentSize.height = self.tblMenuHeight.constant + 470
                    }else {
                        self.tblReviewListHeight.constant = self.tblReviewList.contentSize.height
                        //self.scrollviewww.contentSize.height = self.tblReviewListHeight.constant + 470
                    }
                    self.view.layoutIfNeeded()
                }
            }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func buttonAddClicked(sender:UIButton) {
        
        if self.arrMenuList.count == 0{
            
        }else{
            
            let objSection = self.arrMenuList[sender.superview!.tag]
            let objRow = objSection.arrList[sender.tag]
            let obj = objRow
            self.strQuantity = (Int(obj.strQuantity) ?? 0) + 1
            self.strMenuId = obj.strMenuID
            print("obj.strQuantity is \(obj.strQuantity)")
            print("obj.strMenuID is \(obj.strMenuID)")
            // self.arrMenuList.removeAll()
            self.callWsForAddUpdateCart()
        }
    }
    
    @objc func buttonSubstractClicked(sender:UIButton) {
        if self.arrMenuList.count == 0{
            
        }else{
            let objSection = self.arrMenuList[sender.superview!.tag]
            let objRow = objSection.arrList[sender.tag]
            
            let obj = objRow
            print("obj.strQuantity is \(obj.strQuantity)")
            print("obj.strMenuID is \(obj.strMenuID)")
            
            
            
            if obj.strQuantity == "1" || obj.strQuantity > "1"{
                print("obj.strQuantity is i or more then 1 -> \(obj.strQuantity)")
                self.strQuantity = (Int(obj.strQuantity) ?? 0) - 1
                self.strMenuId = obj.strMenuID
                
                //self.arrMenuList.removeAll()
                self.callWsForAddUpdateCart()
                
            }else{
                print("obj.strQuantity is less then 1 -> \(obj.strQuantity)")
            }
        }
    }
}

//MARK: - Api Calling

extension DetailVC {
    // TODO: Webservice For getRestaurantDetail
    func callWsGetRestaurantDetail(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        
        if self.isFromForgroundNotification{
            objWebServiceManager.StopIndicator()
        }else{
            objWebServiceManager.StartIndicator()
        }
        
        var param: [String: Any] = [:]
        
        param = [
            WsParam.restaurantId: self.strRestaurantId,
            WsParam.latitude: self.strlatitude,
            WsParam.longitude: self.strlongitude
        ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.getRestaurantDetail  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
            
            print(response)
            objWebServiceManager.StopIndicator()
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                let dict  = response["data"] as? [String:Any]
                
                
                if let restaurantDetail = dict?["restaurant_detail"] as? [String:Any]{
                    
                    self.loadRestaurantListDetail(dict : restaurantDetail)
                }
                
                if let arrCategoryListData = dict?["category_list"] as? [[String:Any]]{
                    
                    if arrCategoryListData.isEmpty{
                        print("No category_list found")
                        //                        self.vwNoCategory.isHidden = false
                        //                        self.vwCollection.isHidden = true
                        self.vwStack.isHidden = true
                        self.vwDotted2.isHidden = true
                        
                    }else{
                        print("category_list found")
                        //                        self.vwNoCategory.isHidden = true
                        //                        self.vwCollection.isHidden = false
                        
                        self.vwStack.isHidden = false
                        self.vwDotted2.isHidden = false
                        self.arrCategory.removeAll()
                        
                        for dictCategoryListData in arrCategoryListData{
                            let objCategoryListData = CategoryModel.init(dict: dictCategoryListData)
                            self.arrCategory.append(objCategoryListData)
                        }
                        
                        let objCategory:[String:Any] = ["categoryID": "", "category_name": "All"]
                        let objAllobjCategory:CategoryModel = CategoryModel(dict: objCategory)
                        
                        self.arrCategory = [objAllobjCategory] +  self.arrCategory
                        
        
                        print("arrCategory count is \(self.arrCategory.count)")
                        
                    }
                    
                    
                }
                
                self.vwCollection.reloadData()
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
    
    func loadRestaurantListDetail(dict : [String:Any]){
        
        if let fullName = dict["full_name"]as? String{

            print("fullName is \(fullName)")
            self.lblRestaurantName.text = fullName.capitalizingFirstLetter()
        }
        if let businessType = dict["business_type"]as? String{
            self.lblBusiness_type.text = businessType
        }
        if let distance = dict["distance"]as? String{
            self.lblDistance.text = distance + " km " + "Away".localize
        }
        
        if let avgRating = dict["avg_rating"]as? String{
            let string = NSString(string: avgRating)
            self.lblRating.text = String(string.doubleValue)
        }
        
        
        if let userID = dict["userID"]as? Int{
            self.strUserId = userID
        }
        
        if let profilePic = dict["avatar"]as? String{
            if profilePic != "" {
                let url = URL(string: profilePic)
                self.imgRestaurant.sd_setImage(with: url, placeholderImage:  #imageLiteral(resourceName: "detail_upper_placeholder_img"))
            }else{
                self.imgRestaurant.image = UIImage.init(named: "detail_upper_placeholder_img")
            }
        }
        
        
        
        if let latitude = dict["latitude"]as? String{
            self.strRestaurantLat = latitude
            
            
        }
        
        if let longitude = dict["longitude"]as? String{
            self.strRestaurantLong = longitude
        }
        
        if let fromTime = dict["from_time"]as? String{
            // self.fromTime = fromTime

            self.fromTime = timeConversion12(time24: fromTime)
            self.strOpeningTime = fromTime
        }
        
        if let toTime = dict["to_time"]as? String{
            //  self.toTime = toTime
            self.toTime = timeConversion12(time24: toTime)
            self.strCloseingTime = toTime
        }

        self.lblTime.text = self.fromTime + " - " + self.toTime


        if let isOpen = dict["is_open"]as? String{

            if isOpen == "1" {
                self.lblOpen.text = "Open_Now".localize
                self.isOpen = "1"
                // self.isOpen = "0"

                let currentDate = Date()
                //  print(currentDate) //this will return current date and time

                let dateFormatter = DateFormatter()
                // dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss" //give the formate according to your need
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
                dateFormatter.dateFormat = "HH:mm:ss" //give the formate according to your need
                //  dateFormatter.dateFormat = "hh mm a" //give the formate according to your need
                let dateStr =  dateFormatter.string(from: currentDate)

                print("currentDate of device is \(dateStr)")
                print("closing time convert self.toTime is \(self.toTime)")
                print("closing time self.toTime is \(self.strCloseingTime)")

                if dateStr > self.strCloseingTime || dateStr < self.strOpeningTime{
                    // if dateStr > self.toTime {
                    self.isOpen = "0"
                    self.lblOpen.text = "Closed".localize
                }else{
                    self.isOpen = "1"
                    self.lblOpen.text = "Open_Now".localize
                }

            }else{
                self.lblOpen.text = "Closed".localize
                self.isOpen = "0"
            }


        }
        // self.callWsGetRestaurantMenuList()

        
        // deepak new testing
        self.clearSearch()
        // deepak new testing
        
        
    }
    
    
    
    func timeConversion12(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        
        let date = df.date(from: dateAsString)
        df.timeStyle = .short
        df.dateStyle = .none
        
        df.dateFormat = "hh:mm a"
        let time12 = df.string(from: date!)
        // print(time12)
        return time12
    }
    
    func drawPath(){
        let StrPicklat = ( objAppShareData.UserDetail.strLatitude as NSString).doubleValue
        let StrPickLong = ( objAppShareData.UserDetail.strLongitude as NSString).doubleValue
        
//        let StrPicklat = ( objAppShareData.strSourceLat as NSString).doubleValue
//        let StrPickLong = ( objAppShareData.strSourceLong as NSString).doubleValue
        let StrDellat = (self.strRestaurantLat as NSString).doubleValue
        let strDellong = (self.strRestaurantLong as NSString).doubleValue
        
        print("StrPicklat is \(StrPicklat)")
        print("StrPickLong is \(StrPickLong)")
        print("objAppShareData.strSourceLat is \(objAppShareData.strSourceLat)")
        print("objAppShareData.strSourceLong is \(objAppShareData.strSourceLong)")
        
        //        let StrDellat = self.strlatitude
        //        let strDellong = self.strlongitude
        //
        _ = CLLocation(latitude: StrPicklat, longitude: StrPickLong)
        
        //My buddy's location
        _ = CLLocation(latitude: StrDellat, longitude: strDellong)
        
        let source = objAppShareData.strSourceLat + "," + objAppShareData.strSourceLong
        let destination = self.strRestaurantLat + "," + self.strRestaurantLong
        
        let camera = GMSCameraPosition.camera(withLatitude: StrPicklat, longitude: StrPickLong, zoom: 14)
        self.mapView.camera = camera
        let position = CLLocationCoordinate2D(latitude: StrDellat, longitude: strDellong)
        let marker = GMSMarker(position: position)
        marker.icon =  #imageLiteral(resourceName: "red_map_ico")
        
        let position1 = CLLocationCoordinate2D(latitude: StrPicklat, longitude: StrPickLong)
        let marker1 = GMSMarker(position: position1)
        marker1.icon =  #imageLiteral(resourceName: "yellow_user_ico")
        
        
        
//        var UserLat:Double = 0
//        var UserLong:Double = 0
//        UserLat = StrPicklat
//        UserLong = StrPickLong
//        let position_1 = CLLocationCoordinate2D(latitude: UserLat, longitude: UserLong)
//        let marker_1 = GMSMarker(position: position_1)
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source)&destination=\(destination)&mode=driving&key=AIzaSyBNzeXhR3Hv6U1TgPB1-x27Ic_tiazlTGc"
        Alamofire.request(url).responseJSON { response in
            
            let json = try! JSON(data: response.data!)
            print(json)
            
            
            //let json = JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            if routes.count == 0{
            }
            
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
             
              // dispatch queue code added by shubham for map view route will center in view
                DispatchQueue.main.async
                {
                 if self.mapView != nil
                 {
                  let bounds = GMSCoordinateBounds(path: path!)
                  self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                 }
                }
                
                polyline.map = self.mapView
                //  marker_1.map = self.mapView
                polyline.strokeWidth = 5
                polyline.strokeColor =  #colorLiteral(red: 0.2235294118, green: 0.2235294118, blue: 0.2235294118, alpha: 1)
                // marker_1.icon = #imageLiteral(resourceName: "car_left_ico")
            }
        }
        marker.map = self.mapView
        marker1.map = self.mapView
        
        //        self.runTimer()
    }
    
    //  TODO: Webservice For callWsGetRestaurantMenuList
    func callWsGetRestaurantMenuList(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        
//        if self.isFromForgroundNotification{
//            objWebServiceManager.StopIndicator()
//        }else{
//            objWebServiceManager.StartIndicator()
//        }
        objWebServiceManager.StartIndicator()

        
        objWebServiceManager.requestGet(strURL:WsUrl.getRestaurantMenuList+"limit="+String(self.limit)+"&offset="+String(self.offset)+"&search="+self.strSearchText+"&category_id="+self.strCategoryId+"&restaurant_id="+self.strRestaurantId,Queryparams: [:], body: nil, strCustomValidation: "", success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                
                self.callWsForGetCartList()

                
                let dict  = response["data"] as? [String:Any]
                if  let  dataFound = dict?["data_found"] as? Int  {
                    self.strDataFound = dataFound
                    print("self.strDataFound is \(self.strDataFound)")
                    
                    if dataFound == 1 {
                        self.vwNoData.isHidden = true
                        self.tblMenu.isHidden = false
                        self.totalRecords = dict?["total_records"] as? Int ?? 0
                        
                        if let arrRestaurantData = dict?["menu_list"] as? [[String:Any]]{
                            
                            self.arrMenuList.removeAll()
                            
                            for dictRestaurantData in arrRestaurantData{
                                let objRestaurantData = MenuModel.init(dict: dictRestaurantData)
                                self.arrMenuList.append(objRestaurantData)
                                
                            }
                            if  self.isFirstAppear == true{
                                self.arrHoldMenuList = self.arrMenuList
                            }
                            
                            print("arrMenuList count is \(self.arrMenuList.count)")
                        }
                        
                        /////////////////////////////
                        /*
                        if let pricingDetail = dict?["pricing_detail"] as? [String:Any]{
                           
                            self.lblPrice.text = ""

                            if let totalAmount = pricingDetail["total_amount"]as? String{
                                self.lblPrice.text = "$" + totalAmount

                            }
                            if let totalItems = pricingDetail["total_items"]as? String{
                                print("totalItems count is \(totalItems)")

                                if totalItems == "1"{
                                    self.lblItemCount.text = totalItems + " \("item".localize)"

                                }else{
                                    self.lblItemCount.text = totalItems + " \("items".localize)"
                                }
                            }
                            
                            
                               print("self.lblPrice.text is \(self.lblPrice.text)")
                            
                            if self.isOpen == "1"{
                                
                                if self.lblPrice.text?.isEmpty == true {
                                    
                                   self.vwBottom.isHidden = true
                                }else{
                                   self.vwBottom.isHidden = false
                                }
                            }else{
                                self.vwBottom.isHidden = true
                            }
                        }
                        */
                        print("self.totalRecords count is \(self.totalRecords)")
                        self.tblMenu.reloadData()
                        
                    }else{
                        self.vwNoData.isHidden = false
                        
                       // self.lblNoData.text = "No menu here"
                        self.tblMenu.isHidden = true
                        self.tblReviewListHeight.constant = 415.0
                        self.tblMenuHeight.constant = 379.0
                    }
                }
            }else {
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
        })
    }
    
    // TODO: Webservice For Add Update Cart
    
    func callWsForAddUpdateCart(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        let quantity = String(self.strQuantity)
        param = [
            WsParam.restaurantId: self.strRestaurantId,
            WsParam.menuId: self.strMenuId,
            WsParam.quantity: quantity
        ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.cartAddUpdate, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            let errorType = (response["error_type"] as? String)
            
            if status == "success"{
                self.callWsGetRestaurantMenuList()
            }
            else
            {
                if errorType == "item_discard"{
                    self.deleteCart(msg : message ?? "")
                }else if message != "You don't have this item in cart to delete".localize{
                    self.deleteCart(msg : message ?? "")
                }else{
                    objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
                }
            }
            
        }, failure: { (error) in
            print(error)
            // objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
        })
    }
    
    func deleteCart(msg : String){
        let alert = UIAlertController(title: kAlert.localize, message: msg , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No".localize, style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            self.callWsForDeleteCart(restaurantId : self.strRestaurantId )
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // TODO: Webservice For delete Cart
    
    func callWsForDeleteCart(restaurantId : String ){
    
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var strWsUrl = ""
        strWsUrl  =   WsUrl.deleteCart  +  restaurantId
        print("strWsUrl is \(strWsUrl)")
        
        objWebServiceManager.requestDELETE(strURL: strWsUrl, Queryparams: nil , body: nil , strCustomValidation: "", success: { response in
            
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                self.strCategoryId = ""
                self.arrMenuList.removeAll()
                self.callWsGetRestaurantMenuList()
                
            }else{
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
        })
    }
    
    // TODO: Webservice For get Cart List
    func callWsForGetCartList(){

        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        // objWebServiceManager.StartIndicator()
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.cartList ,Queryparams: [:], body: [:], strCustomValidation: "", success: {response in
            print(response)
            
            objWebServiceManager.StopIndicator()
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            
            if status == "success"{
                
                let dic = response["data"] as? [String:Any]
                
                if let dataFound = dic?["data_found"] as? Int {
                    if dataFound == 1 {
                        self.vwBottom.isHidden = false
                        
                        if let arrCartList = dic?["cart_list"] as? [[String:Any]]{
                            for dictRestaurantData in arrCartList{
                                let RestuarentId = dictRestaurantData["restaurant_id"]
                                print(RestuarentId ?? 0)
                                
                                self.strCartResturentId = RestuarentId as! String
                             //   self.strRestaurantId = RestuarentId as! String
                            }
                            //  print("arrRestaurant count is \(self.arrRestaurant.count)")
                        }
                        
                        if let pricingDetail = dic?["pricing_detail"] as? [String:Any]{
                            self.lblPrice.text = ""
                            
                            if let totalAmount = pricingDetail["total_amount"]as? String{
                                self.lblPrice.text = "$" + totalAmount
                                
                            }
                            if let totalItems = pricingDetail["total_items"]as? String{
                                print("totalItems count is \(totalItems)")
                                
                                if totalItems == "1"{
                                    self.lblItemCount.text = totalItems + " \("item".localize)"
                                    
                                }else{
                                    self.lblItemCount.text = totalItems + " \("items".localize)"
                                }
                            }
                            
                            
                            if let restaurantOpen = pricingDetail["restaurant_open"]as? String{
                                self.isOpen = restaurantOpen
                                
                            }
                            
                             if self.isOpen == "1"{
                                self.vwBottom.isHidden = false
                             }else{
                                self.vwBottom.isHidden = true
                             }
                            
                        }
                        
                    }else{
                        self.vwBottom.isHidden = true
                        
                    }
                }
                
                
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
extension DetailVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if self.btnSearch.tag == 1{
          //  return // deepak
            print("scrollViewDidScroll in search \(scrollView.contentOffset.y)")
        }
        
        print("scrollViewDidScroll \(scrollView.contentOffset.y)")
//        if self.btnSearch.tag == 1{
//            if scrollView.contentOffset.y >= 0{
//                self.viewShowHide.isHidden = false
//            }
//        }
//
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            print("up scroll")
            //self.viewShadow.isHidden = false
            if self.lastContentOffset <= 339.5{
                //self.table.isScrollEnabled = false
                self.viewShowHide.isHidden = true
                self.vwRoundTop.constant = 0 // deepak
            }
            else if self.lastContentOffset >= 450.0 {
              self.viewShowHide.isHidden = false // deepak new
              }
            
            else{
                //self.table.isScrollEnabled = true
            }
        }else if (self.lastContentOffset < scrollView.contentOffset.y) {
            print("down scroll")
            if self.lastContentOffset >= 339.5{
                //self.table.isScrollEnabled = true
                self.viewShowHide.isHidden = false
            }

            else{
                
            }
       }
        self.lastContentOffset = scrollView.contentOffset.y
       }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            
            print("scrollViewWillEndDragging \(scrollView.contentOffset.y)")
            print("up new ")
            
            self.vwRoundTop.constant = 0 // deepak
        //    self.viewShowHide.isHidden = true // deepak
            
            if self.btnSearch.tag == 1{
                if self.lastContentOffset <= 350.0 {
               self.viewShowHide.isHidden = true // deepak new
                }
            }else{
                self.viewShowHide.isHidden = true // deepak
            }
            
            
        }else{
            if ((self.tblMenu.contentOffset.y + self.tblMenu.frame.size.height) >= self.tblMenu.contentSize.height){
                print("scroll on menu table")
                if self.btnSearch.tag == 1{
                 //   self.viewShowHide.isHidden = false // deepak
                }
               
                if ((self.vwCollection.contentOffset.y + self.vwCollection.frame.size.height) >= self.vwCollection.contentSize.height) {
                    return
                }
                
                
                if !isDataLoading{
                    isDataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if self.arrMenuList.count == self.totalRecords {
                        
                    }else {
                        print("api calling in pagination ")
                        self.callWsGetRestaurantMenuList()
                    }
                }
            }
            ////////
            else  if ((self.tblReviewList.contentOffset.y + self.tblReviewList.frame.size.height) >= self.tblReviewList.contentSize.height) {
                print("scroll on review table")
                
            }
            
        }
    }
}

//MARK: - searching operation
extension DetailVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let text = textField.text! as NSString
        
        if (text.length == 1) && (string == "") {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            strSearchText = ""
            self.arrMenuList.removeAll()
            self.limit = 100
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
        self.arrMenuList.removeAll()
        self.limit = 100
        self.offset = 0
        print("api calling in searching")
        self.callWsGetRestaurantMenuList()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //
        //        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
        //        self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
        //
        
        return true
    }
    
}


//MARK: - Webservice For get Review List

extension DetailVC {
    
    func callWsForGetReviewList(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param =  [:] as [String : Any]
        
        
        
        var strWsUrl = ""
        
        //        if strNextPageUrl == ""
        //        {
        //            strWsUrl  = WsUrl.getReviewList
        //
        //            param = [
        //                WsParam.limit: self.limitForReview,
        //                WsParam.offset: self.offsetForReview,
        //                WsParam.ratingFor: self.strRestaurantId
        //                ] as [String : Any]
        //        }
        //        else
        //        {
        //            strWsUrl = strNextPageUrl
        //        }
        
        strWsUrl  = WsUrl.getReviewList
        param = [
            WsParam.limit: self.limitForReview,
            WsParam.offset: self.offsetForReview,
            WsParam.ratingFor: self.strRestaurantId
        ] as [String : Any]
        
        print(param)
        
        
        objWebServiceManager.requestGet(strURL: strWsUrl  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
            print(response)
            
            
            
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                
                let dic  = response["data"] as? [String:Any]
                
                if  let  dataFound = dic?["data_found"] as? Int  {
                        if dataFound == 1 {
                       // self.vwNoData.isHidden = true
                        self.vwNoReview.isHidden = true
                        self.tblReviewList.isHidden = false
                        if let currentDatetime  = dic?["current_date"] as? String {
                            print("self.currentDatetime in string is \(currentDatetime)")
                            currentDateForReview = currentDatetime
                        }
                        self.totalRecords = Int(dic!["total_records"] as? String ?? "") ?? 0
                        
                        
                        if   let paging  = dic?["paging"] as? [String:Any]
                        {
                            if let strNext  = paging["next"] as? String
                            {
                                self.strNextPageUrl = strNext
                            }
                            
                        }
                        self.arrReviewList.removeAll()
                        
                        if let arrReviewData = dic?["review_list"] as? [[String: Any]]{
                            //  self.strNextPageUrl = ""
                            for dictListData in arrReviewData
                            {
                                let objListData = ReviewListModal.init(dict: dictListData)
                                self.arrReviewList.append(objListData)
                                
                                
                            }
                            print("self.arrReviewList.count in api is \(self.arrReviewList.count)")
                            
                        }
                        
                        self.tblReviewList.reloadData()
                        
                    }else{
                     //   self.lblNoData.text = "No review here"
                      //  self.vwNoData.isHidden = false
                        self.vwNoReview.isHidden = false
                        self.tblReviewList.isHidden = true
                        
                        self.tblReviewListHeight.constant = 415.0
                        self.tblMenuHeight.constant = 379.0
                    }
                }
                
                //                self.totalRecords = Int(dic!["total_records"] as? String ?? "") ?? 0
                //
                //
                //                if   let paging  = dic?["paging"] as? [String:Any]
                //                {
                //                    if let strNext  = paging["next"] as? String
                //                    {
                //                        self.strNextPageUrl = strNext
                //                    }
                //
                //                }
                //
                //                if let arrReviewData = dic?["review_list"] as? [[String: Any]]{
                //                    self.arrReviewList.removeAll()
                //               //  self.strNextPageUrl = ""
                //                    for dictListData in arrReviewData
                //                    {
                //                        let objListData = ReviewListModal.init(dict: dictListData)
                //                        self.arrReviewList.append(objListData)
                //                    }
                //                    print("self.arrReviewList.count is \(self.arrReviewList.count)")
                //
                //                }
                //
                //                self.tblReviewList.reloadData()
                
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
    
    func didLoadStupOfViews(){
    // let screenSize: CGRect = UIScreen.main.bounds
    // let screenHeight = screenSize.height

    if UIDevice.current.screenType == .iPhones_6_6s_7_8{
        //539-- 597
    self.vwMenu1Height.constant = 597
    self.vwReviews1Height.constant = 597
    self.vwDirection1Height.constant = 597
    }else if UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus{
        //608-- 666
        self.vwMenu1Height.constant = 676
        self.vwReviews1Height.constant = 676
        self.vwDirection1Height.constant = 676
    }else if UIDevice.current.screenType == .iPhones_X_XS{
        // 626
        self.vwMenu1Height.constant = 684
        self.vwReviews1Height.constant = 684
        self.vwDirection1Height.constant = 684
    }else if UIDevice.current.screenType == .iPhone_XSMax_ProMax{
        // 710
        self.vwMenu1Height.constant = 768
        self.vwReviews1Height.constant = 768
        self.vwDirection1Height.constant = 768
    }else if UIDevice.current.screenType == .iPhone_XR_11{
        // 710
        self.vwMenu1Height.constant = 768
        self.vwReviews1Height.constant = 768
        self.vwDirection1Height.constant = 768
   }else if UIDevice.current.screenType == .iPhone_11Pro{
    // 706
        self.vwMenu1Height.constant = 764
        self.vwReviews1Height.constant = 764
        self.vwDirection1Height.constant = 764
    }
    }
    
    func roundViewTopSetup(){
        
    if UIDevice.current.screenType == .iPhones_6_6s_7_8{
        self.vwRoundTop.constant = -350
    }else if UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus{
        self.vwRoundTop.constant = -365
    }else if UIDevice.current.screenType == .iPhones_X_XS{
        self.vwRoundTop.constant = -350
    }else if UIDevice.current.screenType == .iPhone_XSMax_ProMax{
        self.vwRoundTop.constant = -350
    }else if UIDevice.current.screenType == .iPhone_XR_11{
        self.vwRoundTop.constant = -365
   }else if UIDevice.current.screenType == .iPhone_11Pro{
    self.vwRoundTop.constant = -365
    }
    }
}

extension UIDevice {
    var iPhoneX: Bool { UIScreen.main.nativeBounds.height == 2436 }
    var iPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    var iPad: Bool { UIDevice().userInterfaceIdiom == .pad }
    
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR_11 = "iPhone XR or iPhone 11"
        case iPhone_XSMax_ProMax = "iPhone XS Max or iPhone Pro Max"
        case iPhone_11Pro = "iPhone 11 Pro"
        case unknown
    }
    
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR_11
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2426:
            return .iPhone_11Pro
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax_ProMax //2688
        default:
            return .unknown
        }
    }
}

