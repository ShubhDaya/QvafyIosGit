//
//  CustomerTabbar.swift
//  Qvafy
//
//  Created by ios-deepak b on 22/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
//import Alamofire
import SDWebImage

var imgUserTabbar = UIImageView()
var selected_TabIndex:Int = 2

let SEPARATOR_WIDTH = 1.0
var viewOverTabBar = UIView()

class CustomerTabbar: UITabBarController, UITabBarControllerDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "refreshTabbarUserImage"), object: nil, queue: nil) { [weak self](Notification) in
            self?.manageUserImageSelected()
        }
        
        
        for viewController in self.viewControllers! {
            _ = viewController.view
        }
        self.selectedIndex = selected_TabIndex
        
        self.manageUserImage()
        
        self.checkBannerRedirections()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //    self.tabBar.backgroundColor = UIColor(named: "background")
        
        super.viewWillAppear(animated)
        self.tabBar.clipsToBounds = true
        self.tabBar.layer.borderWidth = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           for vc in self.viewControllers! {
               if #available(iOS 13.0, *) {
                   vc.tabBarItem.imageInsets = UIEdgeInsets(top: 1, left: 0, bottom:2, right: 0)
               }else{
                   vc.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom:-5, right: 0)
               }
           }
       }
    
    func checkBannerRedirections(){
        
        if objAppShareData.isFromBannerNotification == true {
            
            
            if  objAppShareData.strBannerNotificationType == "chat"{
                
                selected_TabIndex = 0
                self.selectedIndex = selected_TabIndex
                
            } else {
                
            let strReferenceType = objAppShareData.strBannerReferenceType
            let strCurrentStatus = objAppShareData.strBannerCurrentStatus
            
            print(" strReferenceType in customer tabbar is \(strReferenceType)")
            print(" currentStatus in customer tabbar is \(strCurrentStatus)")
            
            if strReferenceType == "1"{ // for ride booking
                
                if strCurrentStatus == "1" ||  strCurrentStatus == "2" {
                    selected_TabIndex = 0
                    self.selectedIndex = selected_TabIndex
                    
                    // self.goToMapVC()
                } else if strCurrentStatus == "3" {
                    selected_TabIndex = 0
                    self.selectedIndex = selected_TabIndex
                    
                    //self.goToMapVC()
                    
                }else if strCurrentStatus == "4" {
                    selected_TabIndex = 0
                    self.selectedIndex = selected_TabIndex
                    
                    //self.goToMapVC()
                    
                }else if strCurrentStatus == "5" {
                    // self.goToTripDetailVCFromCustomer()
                   // selected_TabIndex = 4 // old
                    selected_TabIndex = 0 // new
                    self.selectedIndex = selected_TabIndex
                    
                }else if strCurrentStatus == "6" {
                    //self.goToTripDetailVCFromCustomer()
                    selected_TabIndex = 4
                    self.selectedIndex = selected_TabIndex
                    
                }else if strCurrentStatus == "7" {
                    //self.goToTripDetailVCFromCustomer()
                    selected_TabIndex = 4
                    self.selectedIndex = selected_TabIndex
                    
                    
                } else if strCurrentStatus == "0" {
                    // self.goToTripDetailVCFromCustomer()
                    selected_TabIndex = 4
                    self.selectedIndex = selected_TabIndex
                    
                }
                
            } else if strReferenceType == "2"{ // for restorent order
                if strCurrentStatus == "1" ||  strCurrentStatus == "2" || strCurrentStatus == "3" ||
                    strCurrentStatus == "4" || strCurrentStatus == "5" {
                    // self.goToUpcomingDetailVC()
                    selected_TabIndex = 2
                    self.selectedIndex = selected_TabIndex

                } else if strCurrentStatus == "6" {
                    //self.goToCustomerPastOrderDetailVC()
                    selected_TabIndex = 4
                    self.selectedIndex = selected_TabIndex

                }else if strCurrentStatus == "7" {
                    //self.goToCustomerPastOrderDetailVC()
                    selected_TabIndex = 4
                    self.selectedIndex = selected_TabIndex

                }
              }
            }
          }
        }
    
    
    func manageUserImage(){
        let tabWidth = (tabBar.frame.size.width/4)
        let tabBarWidth = tabBar.frame.size.width
        
        imgUserTabbar = UIImageView(frame: CGRect(x: (tabBarWidth - (tabBarWidth/4) + tabWidth/2)-15, y: 8, width: 30, height: 30))
        objAppShareData.fetchUserInfoFromAppshareData()
        
        let profilePic = objAppShareData.UserDetail.strAvatar
        if profilePic != "" {
            let url = URL(string: profilePic)
            imgUserTabbar.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
        }else{
            imgUserTabbar.image = UIImage.init(named: "inactive_profile_ico")
        }
        imgUserTabbar.layer.cornerRadius = 15.0
        imgUserTabbar.layer.masksToBounds = true
        self.tabBar.addSubview(imgUserTabbar)
        imgUserTabbar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        viewOverTabBar = UIView(frame: CGRect(x: 0 , y: 0, width: tabBar.frame.size.width, height: 100))
        self.tabBar.addSubview(viewOverTabBar)
        viewOverTabBar.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        viewOverTabBar.isHidden = true
    }
    
    func manageUserImageSelected(){
        let tabWidth = (tabBar.frame.size.width/4)
        let tabBarWidth = tabBar.frame.size.width
        objAppShareData.fetchUserInfoFromAppshareData()
        
        imgUserTabbar = UIImageView(frame: CGRect(x: (tabBarWidth - (tabBarWidth/4) + tabWidth/2)-15, y: 8, width: 30, height: 30))
        let profilePic = objAppShareData.UserDetail.strAvatar
        if profilePic != "" {
            let url = URL(string: profilePic)
            imgUserTabbar.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
        }else{
            imgUserTabbar.image = UIImage.init(named: "inactive_profile_ico")
        }
        
        imgUserTabbar.layer.cornerRadius = 15.0
         imgUserTabbar.layer.borderWidth = 1.5
        imgUserTabbar.layer.borderColor = UIColor.init(red: 218.0/255.0, green: 186.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        imgUserTabbar.layer.masksToBounds = true
        self.tabBar.addSubview(imgUserTabbar)
        imgUserTabbar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        viewOverTabBar = UIView(frame: CGRect(x: 0 , y: 0, width: tabBar.frame.size.width, height: 100))
        self.tabBar.addSubview(viewOverTabBar)
        viewOverTabBar.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        viewOverTabBar.isHidden = true
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
      //  let indexOfTab = tabBar.items?.index(of: item)
        let indexOfTab = tabBar.items?.firstIndex(of: item)
        print("pressed tabBar: \(String(describing: indexOfTab))")
        
        selected_TabIndex = indexOfTab!
        
        
        if indexOfTab == 4{
            self.manageUserImageSelected()
        }else{
            self.manageUserImage()
        }
        
        if indexOfTab == 1{
        }else{
            objAppShareData.removeFilter()
        }
        
    }
}


