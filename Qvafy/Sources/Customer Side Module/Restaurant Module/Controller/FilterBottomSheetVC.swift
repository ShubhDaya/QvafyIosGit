//
//  FilterBottomSheetVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 05/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

//import UIKit
//
//class FilterBottomSheetVC: UIViewController {
//
//}


import UIKit

//MARK: step 1 Add Protocol here
protocol FilterBottomSheetVCDelegate: class {
    
    func sendDataToFirstViewController(arrId:[Int], arrName:[String])
}

class FilterBottomSheetVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var tblBottom: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var vwtbl: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var vwDone: UIView!
    @IBOutlet weak var vwImgDone: UIView!
    
    
    //MARK: step 2 Create a delegate property here, don't forget to make it weak!
    var delegate: FilterBottomSheetVCDelegate? = nil
    var strSearchText = ""
    
    // MARK:- Varibles

    
    var arrCategory:[FilterModel] = []
    var arrBusiness:[FilterModel] = []
    var arrBottom:[FilterModel] = []
    var arrBottomAll:[FilterModel] = []
  
    var SelectedArrBottom:[Int] = []
    // var arrID:[Int] = []
    var arrName:[String] = []
    var strHeader = ""
    var selectAll: Bool = false
    var arrLanguage:[String] = []
    
    
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwDone.setButtonView(vwOuter : self.vwDone , vwImage : self.vwImgDone, btn: self.btnDone )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //localisation -
        self.txtSearch.placeholder = "Search_Country".localize
        self.btnDone.setTitle("Done".localize, for: .normal)
        
        if self.strHeader == "Bussiness Type".localize {
          //self.SelectedArrBottom = objAppShareData.arrSelectedBusinessId
           
            // deepak new
            if !objAppShareData.arrSelectedBusinessId.isEmpty {
            self.SelectedArrBottom = objAppShareData.arrSelectedBusinessId
            }// deepak new
            
        } else if self.strHeader == "Select_Language".localize {
            
         //   objAppShareData.arrSelectedLanguageId = [2]
        //            objAppShareData.arrSelectedLanguageName = ["Spanish"]
            
            
            let selectedlanguage =  UserDefaults.standard.string(forKey: "Selectdlanguage")
             print(selectedlanguage ?? "")
             if selectedlanguage  == "es"{
             LocalizationSystem.sharedInstance.setLanguage(languageCode: "es")
                objAppShareData.arrSelectedLanguageId = [2]
                   objAppShareData.arrSelectedLanguageName = ["Spanish"]
                   
             }else{
             LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
                objAppShareData.arrSelectedLanguageId = [1]
                objAppShareData.arrSelectedLanguageName = ["English"]
             }

            
            
            ////////////////////
            self.SelectedArrBottom = objAppShareData.arrSelectedLanguageId
            self.arrName = objAppShareData.arrSelectedLanguageName
            print(self.SelectedArrBottom.count)
            print(self.arrName.count)
        }else {
        //  self.SelectedArrBottom = objAppShareData.arrSelectedCategoryId
            
            // deepak new
            if !objAppShareData.arrSelectedCategoryId.isEmpty {
            self.SelectedArrBottom = objAppShareData.arrSelectedCategoryId
            } // deepak new
            
           }
        
        self.viewSearch.isHidden = true
        self.lblHeader.text = self.strHeader
        self.vwtbl.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
        self.tblBottom.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
   
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        if strSearchText.count == 0{
            if self.arrBottom.count > 14{
                let bounds = UIScreen.main.bounds.size.height
                self.tblHeight.constant = bounds - 150
                self.tblBottom.isScrollEnabled = true
            }else{
                self.tblHeight.constant = self.tblBottom.contentSize.height + 10
                self.tblBottom.isScrollEnabled = false
            }
        }
    }
    
    // MARK:- Buttons Action
    @IBAction func btnDoneAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if self.strHeader == "Bussiness Type".localize{
            if self.selectAll == false && self.SelectedArrBottom.count == 0 {
                
                objAlert.showAlert(message: "Please_select_atleast_one_type".localize, title: kAlert.localize , controller: self)
                return
            }else{
            }
            
        }else{
            if self.selectAll == false && self.SelectedArrBottom.count == 0 {
                
                objAlert.showAlert(message:"Please_select_atleast_one_type".localize , title: kAlert.localize , controller: self)
                return
            }else{
            }
            
        }
        self.delegate?.sendDataToFirstViewController(arrId:self.SelectedArrBottom, arrName:self.arrName )
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
        //self.navigationController?.popViewController(animated: false)
    }
    
}
// MARK:- TableView Delegate and DataSource
extension FilterBottomSheetVC : UITableViewDelegate ,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrBottom.count
        //print("self.arrBottom count is \(self.arrBottom.count)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicInfoCell")as! BasicInfoCell
        
        let obj = self.arrBottom[indexPath.row]
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        
        
        if self.strHeader == "Bussiness Type".localize{
            cell.lblTitle.text = obj.strName.capitalizingFirstLetter()

            if self.selectAll{
                cell.imgCheck.image = #imageLiteral(resourceName: "active_check_box_ico")
            }else if SelectedArrBottom.contains(Int(obj.strBusinessTypeID) ?? 0){
                cell.imgCheck.image = #imageLiteral(resourceName: "active_check_box_ico")
            }else{
                cell.imgCheck.image = #imageLiteral(resourceName: "deselect_ico")
            }
            
        } else if self.strHeader == "Select_Language".localize{
            cell.lblTitle.text = obj.strName.capitalizingFirstLetter()

            if SelectedArrBottom.contains(Int(obj.strBusinessTypeID) ?? 0){
                cell.imgCheck.image = #imageLiteral(resourceName: "active_check_box_ico")
            }else{
                cell.imgCheck.image = #imageLiteral(resourceName: "inactive_tick_ico")
            }
        }else {
            cell.lblTitle.text = obj.strCategoryName.capitalizingFirstLetter()

            if self.selectAll{
                cell.imgCheck.image = #imageLiteral(resourceName: "active_check_box_ico")
            }else if SelectedArrBottom.contains(Int(obj.strCategoryID) ?? 0){
                cell.imgCheck.image = #imageLiteral(resourceName: "active_check_box_ico")
            }else{
                cell.imgCheck.image = #imageLiteral(resourceName: "inactive_tick_ico")
                
            }
        }
      
        if self.arrBottom.count - 1 == indexPath.row {
            cell.vwShadow.backgroundColor = UIColor.clear
        }else{
            cell.vwShadow.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 60 // 44
    }
    
    @objc func buttonClicked(sender:UIButton) {
        
        if self.arrBottom.count > 0 {
        
        let obj = self.arrBottom[sender.tag]
        
        if self.strHeader == "Bussiness Type".localize{
            
            if let index = SelectedArrBottom.firstIndex(of: Int(obj.strBusinessTypeID)!) {
                SelectedArrBottom.remove(at: index)
             ///   self.arrName.remove(at: index)
            }else{
                if !SelectedArrBottom.contains(Int(obj.strBusinessTypeID)!){
                    SelectedArrBottom.append(Int(obj.strBusinessTypeID)!)
                }
                if !self.arrName.contains(obj.strName){
                ///    self.arrName.append(obj.strName)
                }
            }
            
        }else if self.strHeader == "Select_Language".localize{
            
            if let index = SelectedArrBottom.firstIndex(of: Int(obj.strBusinessTypeID)!) {
//                SelectedArrBottom.remove(at: index)
//                self.arrName.remove(at: index)
            }else{
            
                self.arrName.removeAll()
                self.SelectedArrBottom.removeAll()
                
                if !SelectedArrBottom.contains(Int(obj.strBusinessTypeID)!){
                    SelectedArrBottom.append(Int(obj.strBusinessTypeID)!)
                }
                if !self.arrName.contains(obj.strName){
                    self.arrName.append(obj.strName)
                }
            }
        }else{
            
            if let index = SelectedArrBottom.firstIndex(of: Int(obj.strCategoryID)!) {
                SelectedArrBottom.remove(at: index)
              ///  self.arrName.remove(at: index)
            }else{
                if !SelectedArrBottom.contains(Int(obj.strCategoryID)!){
                    SelectedArrBottom.append(Int(obj.strCategoryID)!)
                }
                if !self.arrName.contains(obj.strCategoryName){
                ///   self.arrName.append(obj.strCategoryName)
                }
            }
        }
        
        print(" self.SelectedArrBottom \(self.SelectedArrBottom)")
        print(" self.arrName \(self.arrName)")
        
        self.tblBottom.reloadData()
    }
        
    }
    
}

