//
//  FoodDeliveryTabbar.swift
//  Qvafy
//
//  Created by ios-deepak b on 22/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.

import UIKit
import Alamofire
import SDWebImage

class FoodDeliveryTabbar: UITabBarController, UITabBarControllerDelegate{
  //  var count = 0
    
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
            
            if strReferenceType == "2"{ // for food order
                if strCurrentStatus == "6" ||  strCurrentStatus == "7"  {
                    // self.goToFoodDriverPastOrderDetailVC()
                    selected_TabIndex = 2
                    self.selectedIndex = selected_TabIndex
                }else {
                    // goToFoodTrackingVC()
                    selected_TabIndex = 0
                    self.selectedIndex = selected_TabIndex
                }
            } else if strReferenceType == "0" {
                
                if  objAppShareData.strBannerNotificationType == "wallet"{
                selected_TabIndex = 3
                self.selectedIndex = selected_TabIndex
            }else{
                    // for doc
                    // self.goToFoodDriverProfile()
                    selected_TabIndex = 4
                    self.selectedIndex = selected_TabIndex
                }
              }
            }
          }
        }
    
    func manageUserImage(){
        let tabWidth = (tabBar.frame.size.width/5)
        let tabBarWidth = tabBar.frame.size.width
        
        //imgUserTabbar = UIImageView(frame: CGRect(x: (tabBarWidth - (tabBarWidth/5) + (tabWidth/2))-13, y: 8, width: 26, height: 26))
        
        imgUserTabbar = UIImageView(frame: CGRect(x: (tabBarWidth - (tabBarWidth/5) + tabWidth/2)-15, y: 8, width: 30, height: 30))
        //imgUserTabbar = UIImageView(frame: CGRect(x: 0, y: 8, width: 28, height: 28))
       // imgUserTabbar = UIImageView(frame: CGRect(x: (tabBarWidth - (tabBarWidth/4) + tabWidth/2)-15, y: 6, width: 26, height: 26))
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
        let tabWidth = (tabBar.frame.size.width/5)
        let tabBarWidth = tabBar.frame.size.width
        
        imgUserTabbar = UIImageView(frame: CGRect(x: (tabBarWidth - (tabBarWidth/5) + tabWidth/2)-15, y: 8, width: 30, height: 30))
        
       // imgUserTabbar = UIImageView(frame: CGRect(x: (tabBarWidth - (tabBarWidth/4) + tabWidth/2)-15, y: 6, width: 26, height: 26))
        let profilePic = objAppShareData.UserDetail.strAvatar
        if profilePic != "" {
            let url = URL(string: profilePic)
            // imgUserTabbar.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder_img"))
            imgUserTabbar.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
        }else{
            imgUserTabbar.image = UIImage.init(named: "inactive_profile_ico")
        }
        imgUserTabbar.layer.cornerRadius = 15.0
        imgUserTabbar.layer.borderWidth = 1.2
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
            //objAppShareData.strChatUnreadCount = objAppShareData.strChatUnreadCount
        }
         // objAppShareData.strChatUnreadCount = self.count
        // deepak new Testing
        objAppShareData.isDriverProfile = true
        // deepak new Testing
    }
}

