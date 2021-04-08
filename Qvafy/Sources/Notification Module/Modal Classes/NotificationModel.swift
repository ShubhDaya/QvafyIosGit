//
//  NotificationModel.swift
//  Qvafy
//
//  Created by ios-deepak b on 02/09/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import Foundation
import UIKit

class NotificationModel: NSObject {
    
    var strAlertID: String = ""
    var strSenderUserId: String = ""
    var strRecipientUserId: String = ""
    var strReferenceId: String = ""
    var strImage: String = ""
    var strType: String = ""
    var strTitle: String = ""
    var strIsRead: String = ""
    var strReferenceType: String = ""
    var strCreatedAt: String = ""
    var strUpdatedAt: String = ""
    var strFullName: String = ""
    var strRole: String = ""
    var date = Date()
    var currentDate = Date()
    var strRemainingTime = ""
    var strbody = ""
    var strSound = ""
    var strToRole = ""
    var strBadge = ""
    var strCurrentStatus = ""
    var strVehicleType = ""
    var strTypeOfDriver = ""
    var strRestaurantName = ""
        
    init(dict : [String:Any]) {
        super.init()

        self.strAlertID = dictToStringKeyParam(dict: dict, key: "alertID")
        self.strSenderUserId = dictToStringKeyParam(dict: dict, key: "sender_user_id")
        self.strRecipientUserId = dictToStringKeyParam(dict: dict, key: "recipient_user_id")
        self.strReferenceId = dictToStringKeyParam(dict: dict, key: "reference_id")
        self.strImage = dict["image"] as? String ?? ""
        self.strType = dict["type"] as? String ?? ""
        self.strTitle = dict["title"] as? String ?? ""
        self.strIsRead = dict["is_read"] as? String ?? ""
        self.strReferenceType = dict["reference_type"] as? String ?? ""
        self.strCreatedAt = dict["created_at"] as? String ?? ""
        self.strUpdatedAt = dict["updated_at"] as? String ?? ""
        self.strFullName = dict["full_name"] as? String ?? ""
        self.strCurrentStatus = dict["current_status"] as? String ?? ""
        self.strVehicleType = dict["type_of_driver"] as? String ?? ""
        self.strVehicleType = dict["vehicle_type"] as? String ?? ""
        self.strRestaurantName = dict["restaurant_name"] as? String ?? ""

        
        

      //  self.strRole = dict["role"] as? String ?? ""
        
        if self.strCreatedAt != ""{
            self.date = self.strCreatedAt.dateWithFormat(format: "yyyy-MM-dd HH:mm:ss")
            self.currentDate = currentDateTime.dateWithFormat(format: "yyyy-MM-dd HH:mm:ss")
            self.strRemainingTime = relativePastTime(for: self.date, currentDate: self.currentDate)
        }
        
        // deepak
        //self.strRemainingTime = self.timeGapBetweenDates(previousDate: self.strCreatedAt, currentDate: currentDateTime)
        //
        
        if let created = dict["body"] as? String{

            //"body": "{\"type\":\"new_order\",\"body\":\"Order with reference number YRNQ202636102908 has been assign by restaurant.\",\"title\":\"Order Assign\",\"sound\":\"default\",\"reference_id\":\"20\",\"badge\":0,\"reference_type\":\"2\",\"role\":\"3\"}",
            //
            let data = created.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    self.strbody = jsonArray["body"] as? String ?? ""
                    self.strSound = jsonArray["sound"] as? String ?? ""
                    self.strRole = jsonArray["role"] as? String ?? ""
                    self.strBadge = jsonArray["badge"] as? String ?? ""
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
        }

    }
}


extension NotificationModel{
    
    func relativePastTime(for date : Date,currentDate : Date) -> String {

        let units = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .weekOfYear])
        let components = Calendar.current.dateComponents(units, from: date, to: currentDate)

        if components.year! > 0 {
            return "\(components.year!) " + (components.year! > 1 ? "years ago".localize : "year ago".localize)

        } else if components.month! > 0 {
            return "\(components.month!) " + (components.month! > 1 ? "months ago".localize : "month ago".localize)

        } else if components.weekOfYear! > 0 {
            return "\(components.weekOfYear!) " + (components.weekOfYear! > 1 ? "weeks ago".localize : "week ago".localize)

        } else if (components.day! > 0) {
            return (components.day! > 1 ? "\(components.day!) \("days ago".localize)" : "Yesterday".localize)

        } else if components.hour! > 0 {
            return "\(components.hour!) " + (components.hour! > 1 ? "hours ago".localize : "hour ago".localize)

        } else if components.minute! > 0 {
            return "\(components.minute!) " + (components.minute! > 1 ? "minutes ago".localize : "minute ago".localize)

        } else {
           // return "\(components.second!) " + (components.second! > 1 ? "seconds ago" : "second ago")
            return "Just now".localize
        }
    }
   
    func timeGapBetweenDates(previousDate : String,currentDate : String) -> String {
        let dateString1 = previousDate
        let dateString2 = currentDate

        let Dateformatter = DateFormatter()
        Dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        Dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale

        let date1 = Dateformatter.date(from: dateString1)
        let date2 = Dateformatter.date(from: dateString2)


        let distanceBetweenDates: TimeInterval? = date2?.timeIntervalSince(date1!)
        let secondsInAnHour: Double = 3600
        let minsInAnHour: Double = 60
        let secondsInDays: Double = 86400
        let secondsInWeek: Double = 604800
        let secondsInMonths : Double = 2592000
        let secondsInYears : Double = 31104000

        let minBetweenDates = Int((distanceBetweenDates! / minsInAnHour))
        let hoursBetweenDates = Int((distanceBetweenDates! / secondsInAnHour))
        let daysBetweenDates = Int((distanceBetweenDates! / secondsInDays))
        let weekBetweenDates = Int((distanceBetweenDates! / secondsInWeek))
        let monthsbetweenDates = Int((distanceBetweenDates! / secondsInMonths))
        let yearbetweenDates = Int((distanceBetweenDates! / secondsInYears))
        let secbetweenDates = Int(distanceBetweenDates!)


         var returnString = ""

        if yearbetweenDates > 0
        {
            print(yearbetweenDates,"years")//0 years
            returnString = "\(yearbetweenDates)" + " years ago"
        }
        else if monthsbetweenDates > 0
        {
            print(monthsbetweenDates,"months")//0 months
            returnString = "\(monthsbetweenDates)" + " months ago"
        }
        else if weekBetweenDates > 0
        {
            print(weekBetweenDates,"weeks")//0 weeks
            returnString = "\(weekBetweenDates)" + " weeks ago"
        }
        else if daysBetweenDates > 0
        {
            print(daysBetweenDates,"days")//5 days
            returnString = "\(daysBetweenDates)" + " days ago"
        }
        else if hoursBetweenDates > 0
        {
            print(hoursBetweenDates,"hours")//120 hours
            returnString = "\(hoursBetweenDates)" + " hours ago"
        }
        else if minBetweenDates > 0
        {
            print(minBetweenDates,"minutes")//7200 minutes
            returnString = "\(minBetweenDates)" + " minutes ago"
        }
        else if secbetweenDates > 0
        {
            print(secbetweenDates,"seconds")//seconds
            returnString = "\(secbetweenDates)" + " seconds ago"
        }
        
        print(" returnString is \(returnString)")
        return returnString

    }
       
    
}


func dictToStringKeyParam(dict: [String:Any], key: String) -> String {
    if let value = dict[key] as? String {
        return value
    } else if let value = dict[key] as? Int {
        return String(value)
    } else if let value = dict[key] as? Double {
        return String(value)
    } else if let value = dict[key] as? Float {
        return String(value)
    } else {
        return ""
    }
}



