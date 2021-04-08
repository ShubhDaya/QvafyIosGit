//
//  NotificationCell.swift
//  Qvafy
//
//  Created by ios-deepak b on 01/09/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import SDWebImage

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var vwProfile: UIView!
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var vwDotted: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnCell: UIButton!
    @IBOutlet weak var imgDotted: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vwDotted.creatDashedLine(view: vwDotted)
        //   self.vwProfile.setSubProfileVerifyView(vwOuter: self.vwProfile, img: self.imgProfile ,radius : 4)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    // MARK: - Common function for Review List
    
    func NotificationListCell(obj:NotificationModel) {
        
        
        lblDate.text = obj.strRemainingTime
        // print(" obj.strRemainingTime is \(obj.strRemainingTime)")
        
        if obj.strbody.contains("[UNAME]"){
            
            if obj.strRole == "1"{
                print(obj.strType)
                if obj.strType == "rating_remind"{
                    let fullNameArr = obj.strbody.components(separatedBy: "[UNAME]")
                    lblTitle.text = fullNameArr[0] + obj.strFullName.capitalizingFirstLetter() + " " + fullNameArr[1]
                } else if obj.strbody.contains("[UNAME]") &&  obj.strbody.contains("[RNAME]") {
                    if obj.strRole == "1"{
                       if obj.strTitle == "In Route"{
           
                           let swiftyString = obj.strbody.replacingOccurrences(of: "[UNAME]", with: "\(obj.strFullName.capitalizingFirstLetter())")
           
                           let finalString = swiftyString.replacingOccurrences(of: "[RNAME]", with: "\(obj.strRestaurantName.capitalizingFirstLetter())")
                           print(finalString)
                           lblTitle.text = finalString
                       }
                   }
           
                }else if obj.strTitle == "Being Prepared"{
                    let fullNameArr = obj.strbody.components(separatedBy: "[UNAME]")
                    lblTitle.text =  fullNameArr[0] + obj.strFullName.capitalizingFirstLetter()
                }
                else if obj.strTitle == "Order Accepted"{
                    let fullNameArr = obj.strbody.components(separatedBy: "[UNAME]")
                    lblTitle.text =  fullNameArr[0] + obj.strFullName.capitalizingFirstLetter()
                }
                else if obj.strTitle == "Order Rejected"{
                    let fullNameArr = obj.strbody.components(separatedBy: "[UNAME]")
                    lblTitle.text =  fullNameArr[0] + obj.strFullName.capitalizingFirstLetter()
                }
                else{
                    let fullNameArr = obj.strbody.components(separatedBy: "[UNAME]")
                    lblTitle.text = obj.strFullName.capitalizingFirstLetter() + " " + fullNameArr[1]
                }
                
            }else if obj.strRole == "2"{
                
                if obj.strTitle ==  "Trip Review"{
                    let fullNameArr = obj.strbody.components(separatedBy: "[UNAME]")
                    lblTitle.text =  obj.strFullName.capitalizingFirstLetter() + " " + fullNameArr[1]
                }else{
                    
                    let fullNameArr = obj.strbody.components(separatedBy: "[UNAME]")
                    lblTitle.text =  fullNameArr[0] + " " + obj.strFullName.capitalizingFirstLetter() + fullNameArr[1]
                }
            } else if obj.strRole == "3"{
                // if obj.strTitle ==  "Order Review"{
//                if obj.strType ==  "order_review"{
//                    let fullNameArr = obj.strbody.components(separatedBy: "[UNAME]")
//                    lblTitle.text =  obj.strFullName.capitalizingFirstLetter() + " " + fullNameArr[1]
//                }else
                if obj.strType ==  "new_order" {
                    let fullNameArr = obj.strbody.components(separatedBy: "[UNAME]")
                    lblTitle.text =  fullNameArr[0] + " " + obj.strFullName.capitalizingFirstLetter()
                }else  if obj.strType ==  "order_review" &&  obj.strCurrentStatus == "6"{
                    let fullNameArr = obj.strbody.components(separatedBy: "[UNAME]")
                    let str1 =  obj.strFullName.capitalizingFirstLetter() + " " + fullNameArr[1]
                    
                    let finalString = str1.replacingOccurrences(of: "[RNAME]", with: "\(obj.strRestaurantName.capitalizingFirstLetter())")
                    print(finalString)
                    lblTitle.text = finalString
                }
            }
            
        }else if obj.strbody.contains("[RNAME]"){
            if obj.strRole == "1"{
                print(obj.strType)
                if obj.strType == "Picked Up"{
                    let fullNameArr = obj.strbody.components(separatedBy: "[RNAME]")
                    lblTitle.text = fullNameArr[0] + obj.strRestaurantName.capitalizingFirstLetter() + " " + fullNameArr[1]
                }else if obj.strTitle == "Food Delivered"{
                    let fullNameArr = obj.strbody.components(separatedBy: "[RNAME]")
                    lblTitle.text = fullNameArr[0] + obj.strRestaurantName.capitalizingFirstLetter()
                    
                }else if obj.strTitle == "Picked Up"{
                    let fullNameArr = obj.strbody.components(separatedBy: "[RNAME]")
                    lblTitle.text = fullNameArr[0] + obj.strRestaurantName.capitalizingFirstLetter()
                }
            }
        }

        else{
            lblTitle.text = obj.strbody
        }
        
        if obj.strIsRead == "1" {
            self.vwContainer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            // self.vwDotted.isHidden = false
            /// self.imgDotted.isHidden = false
            
        }else{
            self.vwContainer.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
            //  self.vwDotted.isHidden = true
            /// self.imgDotted.isHidden = true
        }
        
    }
    
    func checkImages(obj:NotificationModel) {
        
        if objAppShareData.UserDetail.strRole == "1" { // for Customer side
            
            if obj.strReferenceType == "1"{ // for ride booking
                
                if obj.strCurrentStatus == "1" ||  obj.strCurrentStatus == "2" {
                    imgProfile.image = #imageLiteral(resourceName: "taxi_Type")
                    
                } else if obj.strCurrentStatus == "4" {
                    imgProfile.image = #imageLiteral(resourceName: "taxi_Type")
                    
                } else if obj.strCurrentStatus == "5" {
                    imgProfile.image = #imageLiteral(resourceName: "taxi_Type")
                    
                } else if obj.strCurrentStatus == "6" {
                    imgProfile.image = #imageLiteral(resourceName: "taxi_Type")
                    
                } else if obj.strCurrentStatus == "7" {
                    imgProfile.image = #imageLiteral(resourceName: "taxi_Type")
                    
                }else if obj.strCurrentStatus == "0" {
                    
                    
                    if obj.strTitle == "Booking Rejected"{
                        imgProfile.image = #imageLiteral(resourceName: "cancelled_bookingRide")
                    }else{
                        imgProfile.image = #imageLiteral(resourceName: "request_Type_ico")
                    }
                    
                }
            }else if obj.strReferenceType == "2" { // for order
                
                if obj.strCurrentStatus == "1"  {
                    imgProfile.image = #imageLiteral(resourceName: "newOrder_Type_ico")
                    
                } else if obj.strCurrentStatus == "2" || obj.strCurrentStatus == "3" {
                    
                    imgProfile.image = #imageLiteral(resourceName: "Deliverd_Type")
                    
                }
                //                else if obj.strCurrentStatus == "3" {
                //
                //                    if obj.strVehicleType == "3" {
                //
                //                        imgProfile.image = #imageLiteral(resourceName: "bike_type")
                //
                //                    }else{
                //                        imgProfile.image = #imageLiteral(resourceName: "moterCycle_type")
                //                    }
                //
                //                }
                else if obj.strCurrentStatus == "4" {
                    
                    if obj.strVehicleType == "3" {
                        
                        imgProfile.image = #imageLiteral(resourceName: "bike_type")
                        
                    }else{
                        imgProfile.image = #imageLiteral(resourceName: "moterCycle_type")
                    }
                    
                } else if obj.strCurrentStatus == "5" {
                    
                    if obj.strVehicleType == "3" {
                        
                        imgProfile.image = #imageLiteral(resourceName: "bike_type")
                        
                    }else{
                        imgProfile.image = #imageLiteral(resourceName: "moterCycle_type")
                    }
                    
                } else if obj.strCurrentStatus == "6" {
                    
                    if obj.strVehicleType == "3" {
                        
                        imgProfile.image = #imageLiteral(resourceName: "bike_type")
                        
                    }else{
                        imgProfile.image = #imageLiteral(resourceName: "moterCycle_type")
                    }
                    
                    //   imgProfile.image = #imageLiteral(resourceName: "review_Type_ico")
                    
                    
                } else if obj.strCurrentStatus == "7" {
                    
                    //                    if obj.strVehicleType == "3" {
                    //
                    //                        imgProfile.image = #imageLiteral(resourceName: "bike_type")
                    //
                    //                    }else{
                    //                        imgProfile.image = #imageLiteral(resourceName: "moterCycle_type")
                    //                    }
                    
                    
                    imgProfile.image = #imageLiteral(resourceName: "cancel_order_ico")
                }
                
            }
            
            
            
        } else  if objAppShareData.UserDetail.strRole == "2" { // for Taxi Driver side
            
            
            if obj.strReferenceType == "1"{ // for ride booking
                
                if obj.strCurrentStatus == "1" ||  obj.strCurrentStatus == "2" {
                    imgProfile.image = #imageLiteral(resourceName: "taxi_Type")
                    
                }else if obj.strCurrentStatus == "0" {
                    imgProfile.image = #imageLiteral(resourceName: "taxi_Type")
                    
                }else if obj.strCurrentStatus == "3" {
                    imgProfile.image = #imageLiteral(resourceName: "taxi_Type")
                    
                } else if obj.strCurrentStatus == "4" {
                    imgProfile.image = #imageLiteral(resourceName: "taxi_Type")
                    
                } else if obj.strCurrentStatus == "5" {
                    
                    if obj.strType == "trip_review"{
                        imgProfile.image = #imageLiteral(resourceName: "review_Type_ico")
                    }else{
                        imgProfile.image = #imageLiteral(resourceName: "taxi_Type")
                    }
                    
                    
                } else if obj.strCurrentStatus == "6" {
                    // imgProfile.image = #imageLiteral(resourceName: "taxi_Type")
                    
                    if obj.strType == "trip_review"{
                        imgProfile.image = #imageLiteral(resourceName: "review_Type_ico")
                    }else{
                        imgProfile.image = #imageLiteral(resourceName: "taxi_Type")
                    }
                    
                } else if obj.strCurrentStatus == "7" {
                    imgProfile.image = #imageLiteral(resourceName: "taxi_Type")
                    
                }
            }else if obj.strReferenceType == "0" { // for other
                if obj.strType == "wallet"{
                    imgProfile.image = #imageLiteral(resourceName: "payment_Type_ico")
                }else{
                    imgProfile.image = #imageLiteral(resourceName: "document_Type_ico_new")
                }
            }
            
        }else  if objAppShareData.UserDetail.strRole == "3" { // for Food Delivery side
            
            
            if obj.strReferenceType == "2"{ // for order
                
                if obj.strCurrentStatus == "1" ||  obj.strCurrentStatus == "2" {
                    imgProfile.image = #imageLiteral(resourceName: "newOrder_Type_ico")
                    
                }else if obj.strCurrentStatus == "0" {
                    imgProfile.image = #imageLiteral(resourceName: "newOrder_Type_ico")
                    
                }else if obj.strCurrentStatus == "3" {
                    imgProfile.image = #imageLiteral(resourceName: "newOrder_Type_ico")
                    
                } else if obj.strCurrentStatus == "4" {
                    imgProfile.image = #imageLiteral(resourceName: "newOrder_Type_ico")
                    
                } else if obj.strCurrentStatus == "5" {
                    
                    if obj.strTitle == "Order Review"{
                        imgProfile.image = #imageLiteral(resourceName: "review_Type_ico")
                    }else{
                        imgProfile.image = #imageLiteral(resourceName: "newOrder_Type_ico")
                    }
                    
                    
                } else if obj.strCurrentStatus == "6" {
                    if obj.strTitle == "Order Review"{
                        imgProfile.image = #imageLiteral(resourceName: "review_Type_ico")
                    }else{
                        imgProfile.image = #imageLiteral(resourceName: "newOrder_Type_ico")
                    }
                    
                } else if obj.strCurrentStatus == "7" {
                    imgProfile.image = #imageLiteral(resourceName: "cancel_order_ico")
                    
                }
            }else if obj.strReferenceType == "0" { // for other
                
                if obj.strType == "wallet"{
                    imgProfile.image = #imageLiteral(resourceName: "payment_Type_ico")
                }else{
                    imgProfile.image = #imageLiteral(resourceName: "document_Type_ico_new")
                }
                
                
            }
            
            
        }
        
        
    }
    
}


