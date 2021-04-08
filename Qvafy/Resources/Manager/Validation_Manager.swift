//
//  Validation_Manager.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 27/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//

import Foundation
let objValidationManager = Validation_Manager.sharedObject()

class Validation_Manager {
    
 private static var sharedValidationManager: Validation_Manager = {
  let validation = Validation_Manager()
  return validation
  }()
    
// MARK: - Accessors
    class func sharedObject() -> Validation_Manager {
    return sharedValidationManager
    }
    
//MARK: - Validation Methods
    // Validate email id URL's
    func validateEmail(with Email: String) -> Bool {
        
      //let email = "^((\.)\.)+[a-zA-Z0-9]@[a-zA-Z0-9]([\w\-]+)((\.([a-zA-Z]){2,9})+)$"
       // "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        //new
      //  let emailRegex = "[A-Z0-9a-z.]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,3}"
      
        // ([\\+a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\\.[a-zA-Z0-9._-]+)

        //        let emailRegex = "^([a-zA-Z0-9_\\-\\.+-]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4})(\\]?)$"
        // old
    let emailRegex = "^([a-zA-Z0-9.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9]+\\.)+))([a-zA-Z]{2,4})(\\]?)$"
        
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: Email)
    }
    
    func isPwdLenth(password: String) -> Bool {
           if password.count < 6 {
               return true
           }else{
               return false
           }
       }
    
    func ValidPassWord8digit(with Password: String) -> Bool {
          let passwordRegex = "^(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
          let paswordtest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
          return paswordtest.evaluate(with: Password)
          }
    
    //  "/^(?=.*\d)(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,}$/"
    
    func validpassword(mypassword : String) -> Bool
    {
    let passwordreg = ("^(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}")
    let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
    return passwordtesting.evaluate(with: mypassword)
    }
    
    

    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
     
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    func isNameString(nameStr:String)-> Bool{
        let nameRegEx = "^([A-Za-z](\\.)?+(\\s)?[A-Za-z|\\'|\\.]*){1,7}$"
        let nameTest = NSPredicate (format:"SELF MATCHES %@",nameRegEx)
        let result = nameTest.evaluate(with: nameStr)
        return result
    }
    
    func isValidBankAccountNUmber(testStr:String?) -> Bool {
           guard testStr != nil else { return false }
           let accountNumberTest = NSPredicate(format: "SELF MATCHES %@", "[0-9]{16}")
           return accountNumberTest.evaluate(with: testStr)
       }
       
       func isValidRoutingNo(testStr:String?) -> Bool {
           guard testStr != nil else { return false }
           let accountNumberTest = NSPredicate(format: "SELF MATCHES %@", "[0-9]{16}")
           return accountNumberTest.evaluate(with: testStr)
       }
   
    
// Valid phone number ----
    func isvalidatePhone(value: String) -> Bool {
//        let PHONE_REGEX = "[235689][0-9]{6}([0-9]{3})?"
        let PHONE_REGEX = "^\\D?(\\d{3})\\D?\\D?([0-9]{3})\\D?(\\d{4})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    
    func isValidNUmber(testStr:String?) -> Bool {
            guard testStr != nil else { return false }
            let accountNumberTest = NSPredicate(format: "SELF MATCHES %@", "[0-9]{4}")
            return accountNumberTest.evaluate(with: testStr)
        }
    
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func isvalidPhoneNo(value: String) -> Bool {
           
           if value.count >= 3 {
               return true
           }else{
               return false
           }
           
       }
    
// Only integer id validation --
    func isValidId(Id: String) -> Bool {
           let phoneRegex = "^[0-9+]{0,1}+[0-9]{2,12}$"
           let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
           return phoneTest.evaluate(with: Id)
       }

// Validate Name Strings
    func validateNameStrings(_ nameString: String) -> Bool {
        let nameRegEx = "^([A-Za-z](\\.)?+(\\s)?[A-Za-z|\\'|\\.]*){1,7}$"
        let nameTest = NSPredicate (format:"SELF MATCHES %@",nameRegEx)
        let result = nameTest.evaluate(with: nameString)
        return result
    }
    

//Validation for url

    func validateUrl(_ candidate: String) -> Bool {
    // Converted with Swiftify v1.0.6488 - https://objectivec2swift.com/
    if candidate.hasPrefix("http://") {
    return true
    }
    else if candidate.hasPrefix("https://") {
    return true
    }
    else if candidate.hasPrefix("www") {
    return true
    }
    else {
    return false
    }
    }

    //MARK - time format
    func timeFormat(_ time: String) -> String {
    let dateFormatter3 = DateFormatter()
        dateFormatter3.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    dateFormatter3.dateStyle = .medium
    dateFormatter3.dateFormat = "HH:mm:ss"
    let date1: Date? = dateFormatter3.date(from: time)
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    let formattedTime: String = formatter.string(from: date1!)
    return formattedTime

    }

    func timeFormat(forAPI date: Date) -> String {
    let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    formatter.dateFormat = "hh:mm a"
    let formattedTime: String = formatter.string(from: date)
    return formattedTime
    }

    //MARH - date format
    func dateFormat(_ date: String) -> String {
    let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    dateFormatter.dateStyle = .medium
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date1: Date? = dateFormatter.date(from: date)
    let dateFormatter2 = DateFormatter()
        dateFormatter2.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    dateFormatter2.dateFormat = "MM/dd/yyyy"
    let formatedDate: String = dateFormatter2.string(from: date1!)
    return formatedDate
    }

    func dateFormat(forAPI date: Date) -> String {
    let dateFormator = DateFormatter()
        dateFormator.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    dateFormator.dateFormat = "yyyy-MM-dd"
    let formatedDate: String = dateFormator.string(from: date)
    return formatedDate
    }

    func date(withTime date: Date) -> String {
    let dateFormatter3 = DateFormatter()
        dateFormatter3.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    dateFormatter3.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date1: Date? = dateFormatter3.date(from: "\(date)")
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd hh:mm a"
    let formattedTime: String = formatter.string(from: date1!)
    return formattedTime
   }
    
}
