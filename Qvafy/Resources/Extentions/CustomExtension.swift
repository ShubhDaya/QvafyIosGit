//
//  CustomExtension.swift
//  Mualab
//
//  Created by MINDIII on 11/1/17.
//  Copyright © 2017 MINDIII. All rights reserved.
//

import UIKit


class CustomExtension: NSObject {
}

func relativePast(for date : Date) -> String {
    let units = Set<Calendar.Component>([.year, .month, .day, .weekOfYear])
    let components = Calendar.current.dateComponents(units, from: date, to: Date())
    
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    let strDateTime = formatter.string(from: date)
    let arrDate = strDateTime.components(separatedBy: " ")
    
    var msgDateDay = 0
    var strDate = ""
    if arrDate.count == 2{
        let date1 = arrDate[0]
        var arrNew = date1.components(separatedBy: "-")
        arrNew = arrNew.reversed()
        msgDateDay = Int(arrNew[0])!
        strDate = arrNew.joined(separator: "/")
    }
    
    let currentDate = Date()
    let strCurrentDateTime = formatter.string(from: currentDate)
    let arrCurrentDate = strCurrentDateTime.components(separatedBy: " ")
    var currentDateDay = 0
    if arrCurrentDate.count == 2{
        let date2 = arrCurrentDate[0]
        var arrCurrentNew = date2.components(separatedBy: "-")
        arrCurrentNew = arrCurrentNew.reversed()
        currentDateDay = Int(arrCurrentNew[0])!
    }
    
    if components.year! > 0 {
        let str = converteDateMsgDay(strDateFromServer: strDate)
        return str
    } else if components.month! > 0 {
        let str = converteDateMsgDay(strDateFromServer: strDate)
        return str
    } else if components.weekOfYear! > 0 {
        let str = converteDateMsgDay(strDateFromServer: strDate)
        return str
    } else if (components.day! > 0) {
        if (components.day! > 1){
            let str = converteDateMsgDay(strDateFromServer: strDate)
            return str
        }else{
           // let str = converteDateMsgDay(strDateFromServer: strDate)
            //return str
            return "Yesterday".localize
        }
    } else {
        if currentDateDay>msgDateDay{
            return "Yesterday".localize
        }else{
            return "Today".localize
        }
    }
}

// Convert date formate
func converteDateMsgDay(strDateFromServer: String) -> (String) {
    
    var strConvertedDate : String = ""
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    dateFormatter.dateFormat = "dd-MM-yyyy"
    
    
    let dateFromServer: Date? = dateFormatter.date(from: strDateFromServer)
    
    if let dateFromServer = dateFromServer {
        
        dateFormatter.dateFormat = "MMMM dd, yyyy" //EEE, dd MMM"
        
        let strDate:String? = dateFormatter.string(from: dateFromServer)
        
        if let strDate = strDate {
            strConvertedDate = strDate
        }
    }
    return strConvertedDate
}


@IBDesignable class PaddingLabel: UILabel {

@IBInspectable var topInset: CGFloat = 5.0
@IBInspectable var bottomInset: CGFloat = 5.0
@IBInspectable var leftInset: CGFloat = 7.0
@IBInspectable var rightInset: CGFloat = 7.0

override func drawText(in rect: CGRect) {
let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
super.drawText(in: rect.inset(by: insets))
}

override var intrinsicContentSize: CGSize {
let size = super.intrinsicContentSize
return CGSize(width: size.width + leftInset + rightInset,
height: size.height + topInset + bottomInset)
}

override var bounds: CGRect {
didSet {
// ensures this works within stack views if multi-line
preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
}
}
}



