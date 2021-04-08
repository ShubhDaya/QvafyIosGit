//
//  VehicleSheetVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 31/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

//MARK: step 1 Add Protocol here
protocol VehicleSheetVCDelegate: class {
    
    func sendDataFromVehicleSheetVC(strId: String, strName: String)
    
    func sendObjFromVehicleSheetVC(obj: VehicleModel)
}


class VehicleSheetVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var tblBottom: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var vwtbl: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnDone: UIButton!
    
    //MARK: step 2 Create a delegate property here, don't forget to make it weak!
    var delegate: VehicleSheetVCDelegate? = nil
    
    // MARK:- Varibles
    
    var arrBottom:[VehicleModel] = []
    var strHeader = ""
    var strId: String = ""
    var strName = ""
    var strSearchText = ""
    var strMakeId = ""
    var strVehicleTypeId = ""
    var closerCallApi:((_ isClearList:Bool)   ->())?
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewSearch.isHidden = true
        
        ////
        
        if self.strHeader == "Select_Make".localize {
            
            self.strId = objAppShareData.strSelectedVehicleCompanyId
            self.strName =  objAppShareData.strSelectedCompanyNames
            print(strId)
            print(strName)
            
        }else{
            
            self.strId = objAppShareData.strSelectedVehicleMetaId
            self.strName =  objAppShareData.strSelectedModelNames
            print(strId)
            print(strName)
            
        }
        
        self.lblHeader.text = self.strHeader
        self.vwtbl.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
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
                self.tblHeight.constant = self.tblBottom.contentSize.height + 30
                self.tblBottom.isScrollEnabled = false
            }
        }
    }
    
    // MARK:- Buttons Action
    
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
    
}
// MARK:- TableView Delegate and DataSource
extension VehicleSheetVC : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrBottom.count
        //print("self.arrBottom count is \(self.arrBottom.count)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicInfoCell")as! BasicInfoCell
        
        if self.strHeader == "Select_Make".localize {
            
            
            let obj = self.arrBottom[indexPath.row]
            cell.lblTitle.text = obj.strCompany
            cell.btnCheck.tag = indexPath.row
            cell.btnCheck.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
            
            
            if self.strId == obj.strVehicleCompanyId{
                cell.imgCheck.image = #imageLiteral(resourceName: "active_check_box_ico")
                
            }else{
                cell.imgCheck.image = #imageLiteral(resourceName: "inactive_tick_ico")
            }
        } else {
            
            let obj = self.arrBottom[indexPath.row]
            
            //            if self.strMakeId == obj.strVehicleCompanyId {
            //
            //                cell.lblTitle.text = obj.strModel
            //
            //            }
            
            cell.lblTitle.text = obj.strModel
            cell.btnCheck.tag = indexPath.row
            cell.btnCheck.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
            
            
            if self.strId == obj.strMehicleMetaId{
                cell.imgCheck.image = #imageLiteral(resourceName: "active_check_box_ico")
                
            }else{
                cell.imgCheck.image = #imageLiteral(resourceName: "inactive_tick_ico")
                
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 44
        
    }
    
    @objc func buttonClicked(sender:UIButton) {
        
        if self.arrBottom.count > 0 {
            
            let obj = self.arrBottom[sender.tag]
            
            if self.strHeader == "Select_Make".localize {
                
                
                
                self.strId = obj.strVehicleCompanyId
                self.strName =  obj.strCompany
                objAppShareData.strSelectedCompanyNames = obj.strCompany
                objAppShareData.strSelectedVehicleCompanyId  = obj.strVehicleCompanyId
                // new deepak
                objAppShareData.strSelectedVehicleMetaId = ""
                //   self.closerCallApi?(true)
                // new deepak
                
                if self.strMakeId != obj.strVehicleCompanyId {
                    self.delegate?.sendDataFromVehicleSheetVC(strId: strId , strName: strName)
                    self.delegate?.sendObjFromVehicleSheetVC(obj: obj)
                    self.tblBottom.reloadData()
                    self.dismiss(animated: false, completion: nil)
                }
                
            }else{
                
                self.strId = obj.strMehicleMetaId
                self.strName =  obj.strModel
                objAppShareData.strSelectedModelNames =   obj.strModel
                objAppShareData.strSelectedVehicleMetaId  = obj.strMehicleMetaId
                
                if self.strVehicleTypeId != obj.strMehicleMetaId {
                    self.delegate?.sendDataFromVehicleSheetVC(strId: strId , strName: strName)
                    self.tblBottom.reloadData()
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
        
    }
}

