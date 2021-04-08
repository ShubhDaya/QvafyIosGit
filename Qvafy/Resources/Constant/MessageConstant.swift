//
//  MessageConstant.swift
//  CubaRing
//
//  Created by Traning-IOS on 05/12/19.
//  Copyright © 2019 Traning-IOS. All rights reserved.
//

import Foundation
import UIKit

let ValidYear: String = "Please enter the correct Year"
let BlankYear : String = "Please_enter_year"
let BlankModel : String = "Please enter vehicle model number"
let BlankNumber : String = "Please_enter_vehicle_number"
let BlankMake : String = "Please_select_vehicle_make"
let BlankVehicle : String = "Please_select_vehicletype"
let BlankRegistration : String = "Please_upload_registration"
let BlankLicense : String = "Please upload license"
let YearValidation : String = "Please_enter_valid_year"
let NumberValidation : String = "Number should not less than 5 characters"
let ModelValidation : String = "Model should not less than 5 characters"
let BlankBank : String = "Please_select_cuba_bank"
let BlankCubanBankCard : String = "Please_enter_your_cuban_card_number"
let BlankCubanCardValidation : String = "Cuban card number should not less than 12 characters"
let ValidCubanBankCard : String = "Please enter valid cuban card number"
let BlankBankAccount : String = "Please_enter_bank_name"
let BlankAccountHolderName : String = "Please_enter_account_holder_name"
let BlankAccountNo : String = "Please_enter_account_number"
let BlankRoutingNo : String = "Please_enter_routing_number"
let AccountValidation : String = "Account number should not less than 12 characters"
let RoutingValidation : String = "Routing number should not less than 9 characters"
let ValidAccount : String = "Please enter valid account number"
let ValidRouting : String = "Please enter valid routing number"
let FullNameValidation : String = "Name_must_be_atleast_2_characters"
let BankNameValidation : String = "Full name should be greater than 3 characters"
let AccountHolderNameValidation : String = "Full name should be greater than 3 characters"

let CardNumber : String = "Please_enter_your_card_number"

let UsernameLength: String = "Username must be atleast 4 characters long"
let CorrectUsername: String = "Username cannot contains whitespace"
let BlankEmail: String = "Please_enter_your_email"
let BlankPhone: String = "Please_enter_your_phone_number"
let BlankDialCode: String = "Please select dial code"

let BlankSocialEmail: String = "Please enter your social email id"
let InvalidEmail: String = "Email_address_is_not_valid,_please_provide_a_alid_email"
let InvalidPhone: String = "Please_enter_your_valid_phone_number"
let InvalidAddedNUmber: String = "We not able to make a call your number is not valid."


let BlankPassword: String = "Please_enter_your_password"
let ValidEmail: String = "Email_address_is_not_valid,_please_provide_a_alid_email"

let BlankConfirmPw: String = "Please_enter_your_confirm_password"
let BlankOldPassword: String = "Please_enter_your_old_password"
let BlankNewPassword: String = "Please_enter_your_new_password"

let OldPasswordInvalid: String = "Your old password must contain min 8 characters with at least one uppercase, lowercase, number digit & special character."
let NewPasswordInvalid: String = "Your new password must contain min 8 characters with at least one uppercase, lowercase, number digit & special character."
let PasswordLength: String = "Password_should_not_less_than_6_characters"

let validPassword8Digit : String = "Your password must contain min 8 characters with at least one uppercase, lowercase, number digit & special character."

let ConfirmPwLength: String = "Confirm_password_should_not_less_than_6_characters"
let PasswordMatching : String = "Password_and_confirm_password_does_not_match"
let Confirm_Password : String = "Password_and_confirm_password_does_not_match"

let ConfirmPassInvalid : String = "Confirm password should be same as password."
//let Confirm_Password : String = "Sorry, your Password were not matching."

let Password_Validation : String = "Password must contain 5 characters and 1 number"
let FullName : String = "Please_enter_your_full_name"
let Address : String = "Please enter your address"
let Gender : String = "Please_select_gender"
let Age : String = "Please select the age"
let Car_Make : String = "Please enter the car make"
let Car_Model : String = "Please enter the car model"
let Car_Plate : String = "Please enter the car plate number"
let Car_Color : String = "Please enter the car color"
let Emai_AlreadyExist : String = "This email address is already exist, please enter another email to change the existing one."
let No_Connection : String = "Something_went_wrong"
let NoConnection : String = "No network connection"
let Email_NotExist : String = "Invalid Email/Password"
let Error : String = "Your token is invalid"
let OldPassword : String = "Please_enter_your_old_password"
let NewPassword : String = "Please_enter_your_new_password"
let Subject : String = "Please enter the subject"
let SubjectValidation : String = "Subject should not less than 5 characters"
let Message : String = "Please enter the message"
let MessageValidation : String = "Message should not less than 5 characters"
let CardHolderName : String = "Please_enter_your_card_holder_name"
let CardExpiryDate : String = "Please_enter_your_card_expiry_date"
let CardCVV : String = "Please_enter_your_cvv_number"
let CardValidationCVV : String = "CVV_number_must_be_3_digit_long"
let CardValidationHolderName : String = "Card holder name should not less than 3 charcters"
let CardValidationNumber : String = "Card_number_must_be_16_digit_long"
let BankHolderName : String = "Please enter your first name"
let BankHolderLastName : String = "Please enter your last name"
let BankHolderValidationName : String = "First Name should not less than 3 characters"
let BankAccountNumber : String = "Please enter your bank account number"
let BankHolderValidationLastName : String = "Last Name should not less than 3 characters"
let BankAccountRegisteredAddress : String = "Please enter your registered address"
let BankCountry : String = "Please enter your date of birth"
let BankPostCode : String = "Please enter your routing number"
let EmptySendGift : String = "Please enter the money"
let destinationReach : String = "You have reached the spot, we are now closing your connection."
let SwapSpotCheck1 : String = "Unable to swap. Please select looking action first before swaping spot"
let SwapSpotCheck2 : String = "You cannot swap with the leaving spot action"

let SuccessFullPayment : String = "Transaction Successful"

let NoNetwork: String = "No network connection"
let SessionExpired : String = "Your session is  expired. Please login again"

let kAlertMessage: String = "Message"
let kAlertTitle: String = "Alert"
let kErrorMessage: String = "Something_went_wrong"
let k_success = "Success"

func showAlertVC(title:String,message:String,controller:UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let subView = alertController.view.subviews.first!
    let alertContentView = subView.subviews.first!
    alertContentView.backgroundColor = UIColor.gray
    alertContentView.layer.cornerRadius = 20
    let OKAction = UIAlertAction(title: "OK".localize , style: .default, handler: nil)
    alertController.addAction(OKAction)
    controller.present(alertController, animated: true, completion: nil)
}

func sessionExpireAlertVC(controller:UIViewController) {
    let alertController = UIAlertController(title: kAlertTitle.localize , message: "Your session is expired , please login again".localize , preferredStyle: .alert)
    let subView = alertController.view.subviews.first!
    let alertContentView = subView.subviews.first!
    alertContentView.backgroundColor = UIColor.gray
    alertContentView.layer.cornerRadius = 20
    let OKAction = UIAlertAction(title: "OK".localize , style: .default, handler: {(_ action: UIAlertAction) -> Void in
        //objAppShareData.objAppdelegate.logOut()
    })
    alertController.addAction(OKAction)
    controller.present(alertController, animated: true, completion: nil)
}

func checkForNULL(obj:Any?) -> Any {
    return obj ?? ""
}

