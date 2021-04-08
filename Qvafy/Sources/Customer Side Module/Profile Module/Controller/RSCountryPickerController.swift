//
//  RSCountryPickerController.swift
//  Qvafy
//
//  Created by ios-deepak b on 15/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

struct CountryInfo {
    let country_code : String
    let dial_code: String
    let country_name : String
    // let flag : UIImage
}

//Make Protocol
protocol RSCountrySelectedDelegate {
    func RScountrySelected(countrySelected country: CountryInfo) -> Void
}


class RSCountryPickerController: UIViewController,UITextFieldDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet var vwHeader: UIView!
    @IBOutlet var vwContainTfSearch: UIView!
    @IBOutlet var tfSearchBar: UITextField!
    @IBOutlet var tblCountryList: UITableView!
     @IBOutlet var lblNoData: UILabel!
    
    // localisation outlets -
    @IBOutlet weak var lblLOSerarchCountryHeader: UILabel!
    @IBOutlet weak var lblLONoCountryHear: UILabel!
    
    
    //Variables
    var countries = [[String: String]]()
    var RScountryDelegate: RSCountrySelectedDelegate!
    var RScountriesFiltered = [CountryInfo]()
    var RScountriesModel = [CountryInfo]()
    var strCheckCountry = ""
    
    //App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("check",self.strCheckCountry)
        jsonSerial()
        collectCountries()
        self.RScountriesFiltered = self.RScountriesModel
        self.tfSearchBar.addTarget(self, action: #selector(searchWorkersAsPerText(_ :)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localisation()
        self.lblNoData.isHidden = true
        self.tfSearchBar.attributedPlaceholder = NSAttributedString.attributedPlaceholderString(string: "Search_Country".localize)
         self.vwContainTfSearch.setShadowWithCornerRadius()
    }
    
    func localisation(){
        self.lblLOSerarchCountryHeader.text =  "Search_Country".localize
        self.lblNoData.text =  "No_country_here".localize
    }
    
    //IBAction
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Searching
extension RSCountryPickerController{
    
    @objc func searchWorkersAsPerText(_ textfield:UITextField) {
        self.RScountriesFiltered.removeAll()
        if textfield.text?.count != 0 {
            for dicData in self.RScountriesModel {
                let isMachingWorker : NSString = (dicData.country_name) as NSString
                let range = isMachingWorker.lowercased.range(of: textfield.text!, options: NSString.CompareOptions.caseInsensitive, range: nil,   locale: nil)
                if range != nil {
                    RScountriesFiltered.append(dicData)
                }
            }
        } else {
            self.RScountriesFiltered = self.RScountriesModel
        }
       
         self.tblCountryList.reloadData()
        if RScountriesFiltered.count == 0 {
           // print("RScountriesFiltered has 0 count")
            self.lblNoData.isHidden = false
        }else{
            self.lblNoData.isHidden = true
           //  print("RScountriesFiltered not has 0 count")
            
        }
        
    }
    
    
}

//Functions
extension RSCountryPickerController{
    
    func jsonSerial() {
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "countries", ofType: "json")!))
        do {
            let parsedObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            countries = parsedObject as! [[String : String]]
            //      print("country list \(countries)")
        }catch{
            print("not able to parse")
        }
    }
    
    func collectCountries() {
        for country in countries  {
            let code = country["code"] ?? ""
            let name = country["name"] ?? ""
            let dailcode = country["dial_code"] ?? ""
            RScountriesModel.append(CountryInfo(country_code:code,dial_code:dailcode, country_name:name))
        }
    }
    
    //Used when default search bar
    //    func filtercountry(_ searchText: String) {
    //        RScountriesFiltered = RScountriesModel.filter({(country ) -> Bool in
    //            let value = country.country_name.lowercased().contains(searchText.lowercased()) || country.country_code.lowercased().contains(searchText.lowercased())
    //            return value
    //        })
    //        tblCountryList.reloadData()
    //    }
    
    func checkSearchBarActive() -> Bool {
        if tfSearchBar.text != "" {
            return true
        } else {
            return false
        }
    }
    
    //    //--------------------------XXXX--------------------------
    //
    class func getDialCode(countryCode: String) -> String? {
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "countries", ofType: "json")!))
        do {
            let parsedObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            var countries = [[String: String]]()
            countries = parsedObject as! [[String : String]]
            for dic in countries {
                if dic["code"] == countryCode {
                    return dic["dial_code"]
                }
            }
            return nil
        }catch{
            print("not able to parse")
            return nil
        }
    }
    
    
    class func getCountryCode(dialCode: String) -> String {
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "countries", ofType: "json")!))
        do {
            let parsedObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            var countries = [[String: String]]()
            countries = parsedObject as! [[String : String]]
            for dic in countries {
                if dic["dial_code"] == dialCode {
                    return dic["code"] ?? ""
                }
            }
            return nil ?? ""
        }catch{
            print("not able to parse")
            return nil ?? ""
        }
    }
    
    
    class func getCountryName(countryCode: String) -> String? {
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "countries", ofType: "json")!))
        do {
            let parsedObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            var countries = [[String: String]]()
            countries = parsedObject as! [[String : String]]
            for dic in countries {
                if dic["code"] == countryCode {
                    return dic["name"]
                }
            }
            return nil
        }catch{
            print("not able to parse")
            return nil
        }
    }
    
    class func getCountryInfo(countryCode: String) -> CountryInfo? {
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "countries", ofType: "json")!))
        do {
            let parsedObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            var countries = [[String: String]]()
            countries = parsedObject as! [[String : String]]
            for dic in countries {
                if dic["code"] == countryCode {
                    return CountryInfo(country_code: dic["code"]!, dial_code: dic["dial_code"]!, country_name: dic["name"]!)
                }
            }
            return nil
        }catch{
            print("not able to parse")
            return nil
        }
    }
    
    class func getCountryInfo(dialCode: String) -> CountryInfo? {
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "countries", ofType: "json")!))
        do {
            let parsedObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            var countries = [[String: String]]()
            countries = parsedObject as! [[String : String]]
            for dic in countries {
                if dic["code"] == dialCode {
                    return CountryInfo(country_code: dic["code"]!, dial_code: dic["dial_code"]!, country_name: dic["name"]!)
                }
            }
            return nil
        }catch{
            print("not able to parse")
            return nil
        }
    }
    //--------------------------XXXX--------------------------
}


//MARK:- TableVies Datasource
extension RSCountryPickerController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if checkSearchBarActive() {
            return RScountriesFiltered.count
        }
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSCountryTableViewCell")as! RSCountryTableViewCell
        // RScountryDelegate = self as? RSCountrySelectedDelegate
        
        let contry: CountryInfo
        if checkSearchBarActive() {
            contry = RScountriesFiltered[indexPath.row]
        }else{
            contry = RScountriesModel[indexPath.row]
        }
        cell.lblCountryName.text = contry.country_name
        cell.lblCountryDialCode.text = contry.dial_code
        let imagestring = contry.country_code
        let imagePath = "CountryPicker.bundle/\(imagestring).png"
        cell.imgCountryFlag.image = UIImage(named: imagePath)
   
        
        return cell
    }
    
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 50
    //    }
    
}
//MARK:- TableVies Delegate
extension RSCountryPickerController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     ///   let cell = tableView.cellForRow(at: indexPath) as! RSCountryTableViewCell
        /// cell.imgRadioCheck.image = #imageLiteral(resourceName: "inactive_check_ico")
        if checkSearchBarActive() {
            RScountryDelegate.RScountrySelected(countrySelected: RScountriesFiltered[indexPath.row])
            
            //countryDelegate.SRcountrySelected(countrySelected: countriesFiltered[indexPath.row])
        }else {
            
            RScountryDelegate.RScountrySelected(countrySelected: RScountriesModel[indexPath.row])
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

