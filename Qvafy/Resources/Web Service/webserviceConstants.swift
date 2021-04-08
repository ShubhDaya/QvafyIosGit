//
//  webserviceConstants.swift
//  LightGeneration
//  Created by mindiii on 10/30/17.
//  Copyright © 2017 mindiii. All rights reserved.

import Foundation
import UIKit

    let BASE_URL =   "https://www.qvafy.com/api/v1/" // live
   //let BASE_URL =   "https://dev.qvafy.com/api/v1/" // dev
   let pkTest =  "pk_test_51HICv5AinsnjiJjUSYISltmDLEtRRWVR4W2tGApU9a5pd2dZevwNTcDI5ikh2uWVbsM7l1EF9iIT8HlZK3eVBm6N00BkqBAHBu" // new for dev
   let stripeKey = "Bearer sk_test_51HICv5AinsnjiJjUKIBJ8gfkFGWm0beQeJCRKW3SpCo1BtkVMKnhROuYXfsfk3lEDb4btxwS1FfODPKwGFyT98R100G8APXwK0"  // new for dev

// Api Base url with api name
struct WsUrl {
    // auth api
    static let signUp = BASE_URL + "auth/signup"
    static let login = BASE_URL + "auth/login"
    static let resetPassword = BASE_URL + "auth/reset-password"
    static let userRole = BASE_URL + "onboarding/user-role" /// UserRoleVC
    static let driverType = BASE_URL + "onboarding/driver-type" ///  UserRoleDriverVC
    static let vehicleList = BASE_URL + "onboarding/vehicle-list" /// BasicInfoVC
    static let vehicleAdd = BASE_URL + "onboarding/vehicle-add" ///  BasicInfoVC
    static let content = BASE_URL + "auth/content" /// AddBankDetailVC
    static let skipStep = BASE_URL + "onboarding/skip-step" // AddBankDetailVC
    static let setCubBankAccount = BASE_URL + "bank/set-cuba-bank-account" // AddBankDetailVC
    static let VerifyConnectedAccount = BASE_URL + "bank/verify-connected-account"
      
    static let ChangeLanguage = BASE_URL + "auth/change-language"

    
    // AddBankAccountVC
    static let createAccountLink = BASE_URL + "bank/create-account-link" // AddBankAccountVC
    static let addBankAccount = BASE_URL + "bank/add-bank-account" // AddBankAccountVC
    static let logout = BASE_URL + "auth/logout" /// LogoutVC
    static let getDriverList = BASE_URL + "ride/get-driver-list" /// MapVC
    static let addCard = BASE_URL + "add-card" /// Payments Method
    static let cardList = BASE_URL + "card-list" /// Payments Method
    static let getBookingDetails = BASE_URL + "ride/get-booking-details" /// TripDetailVC
    static let updateLocation = BASE_URL + "common/change-location" /// UserRoleVC /// /// both side
    static let bookingRide = BASE_URL + "ride/booking-ride" /// MapVC
    static let myCurrentRide = BASE_URL + "ride/my-current-ride" /// both side
    static let payRide = BASE_URL + "ride/pay-ride" ///   MapVC
    static let getTaxiDriverLocation = BASE_URL + "ride/get-driver-location" /// both side 
    static let changeRideStatus = BASE_URL + "ride/change-ride-status/" /// taxi driver
    static let getPastRide = BASE_URL + "ride/get-past-ride" /// taxi driver
    static let ratingReview = BASE_URL + "common/rating-review" ///  RatingVC
    static let getCustomerDetails = BASE_URL + "common/get-customer-details" /// CustomerProfileVC
    static let updateProfile = BASE_URL + "common/update-profile" /// EditCustomerProfileVC
    static let getDriverDetails = BASE_URL + "common/get-driver-details" /// TaxiDriverProfileVC & FoodDriverProfileVC
    static let setNotificationStatus = BASE_URL + "common/set-notification-status" /// SettingVC
    static let changePassword = BASE_URL + "user/change-password" /// SettingVC
    static let updateVehicleInfo = BASE_URL + "common/update-vehicle-info" /// EditVehicleInfoVC
    static let getReviewList = BASE_URL + "common/get-review-list" ///  ReviewListVC
    static let setOnlineStatus = BASE_URL + "common/set-online-status" /// TaxiDriverProfileVC & FoodDriverProfileVC
    static let getPromoCodeList = BASE_URL + "get-promo-code-list" /// RestaurantListVC
    static let getRestaurantList = BASE_URL + "get-restaurant-list?" /// RestaurantListVC
    static let getCategoryList = BASE_URL + "get-category-list" /// FilterVC
    static let getBusinessList = BASE_URL + "get-business-list" /// FilterVC
        
    static let getRestaurantDetail = BASE_URL + "get-restaurant-detail" /// RestaurantDetailVC
    static let getRestaurantMenuList = BASE_URL + "get-restaurant-menu-list?" /// RestaurantDetailVC
    static let cartAddUpdate = BASE_URL + "cart" /// RestaurantDetailVC and CartVC ( api used for add card,update ,delete and cartList)
    static let deleteCart = BASE_URL + "cart/" /// RestaurantDetailVC and CartVC ( api used for add card,update ,delete and cartList)
    
    static let deleteSavedCard = BASE_URL + "card-delete/" /// RestaurantDetailVC and CartVC ( api used for add card,update ,delete and cartList)
    static let cartList = BASE_URL + "cart?" /// RestaurantDetailVC and CartVC ( api used for add card,update ,delete and cartList)
    static let getCartCheckout = BASE_URL + "cart/cart-checkout?" /// CheckOutVC
    
    static let addDeliveryAddress = BASE_URL + "delivery-address" /// SelectAddressVC
    static let getDeliveryAddress = BASE_URL + "delivery-address?" /// SelectAddressVC
    static let makeDefaultAddress = BASE_URL + "delivery-address/" /// SelectAddressVC
    static let deleteDeliveryAddress = BASE_URL + "delivery-address/" /// SelectAddressVC
     
    static let placeOrder = BASE_URL + "order" /// CheckOutVC
    static let getFoodDriverLocation = BASE_URL + "order/get-driver-location" /// both side
    static let newOrder = BASE_URL + "order/new-order" /// NewOrderVC
    static let deliveryAddressLocation = BASE_URL + "order/delivery-address-location" /// FoodTrackingVC
    static let changeOrderStatus = BASE_URL + "order/change-order-status" /// ChangeStatusVC

    static let getUpcomingList = BASE_URL + "order/upcoming?" /// UpcomingVC
    static let cancelOrder = BASE_URL + "order/cancel-order" /// UpcomingVC
    
    static let getPastOrder = BASE_URL + "order/past-order?" /// PastOrderVC & CustomerPastOrderVC
    static let orderDetail = BASE_URL + "order/order-detail" /// NewOrderVC
    static let orderRating = BASE_URL + "order/order-rating" /// NewOrderVC
 
    static let getNotificationList = BASE_URL + "notification/get-notification-list?" /// NotificationVC
    static let readNotification = BASE_URL + "notification/read-notification" /// NotificationVC
    static let readBannerNotification = BASE_URL + "notification/read-bg-notification" /// Appdelegate
    static let checkCurrentStatus = BASE_URL + "common/check-current-status" /// Appdelegate
  
    static let getWallet = BASE_URL + "wallet/get-wallet-detail" // walletVC
    static let payToCompany = BASE_URL + "wallet/pay-to-company" // walletVC
    static let withdrawRequest = BASE_URL + "wallet/withdraw-request" // walletVC'
    
    static let ratingRemind = BASE_URL + "ride/rating-remind/" //
    static let cancelRide = BASE_URL + "ride/cancel-ride/" // mapVc

}


//Api parameters
struct WsParam {
    
    //login Signup and Profile & Setting module Params
    static let fullname = "full_name"
    static let password = "password"
    static let deviceToken = "device_token"
    static let confirmPassword = "confirm_password"
    static let signupfrom = "signup_from"
    static let profileTimezone = "profile_timezone"
    static let email = "email"
    static let profilePicture = "profile_image"
    static let userRole = "user_role"
    static let driverType = "driver_type"
    static let vehicleType = "vehicle_type"
    static let typeofDriver = "type_of_driver"
    static let year = "year"
    static let modelNumber = "model_number"
    static let make = "make"
    static let vehicleNumber = "vehicle_number"
    static let registrationImage = "registration_image"
    static let licenseImage = "license_image"
    static let skipStep = "skip_step"
    static let cubaBankId = "cuba_bank_id"
    static let cubaBankCard = "cuba_bank_card"
    static let stripeConnectAccountId = "stripe_connect_account_id"
    static let bankName = "bank_name"
    static let holderName = "holder_name"
    static let routingNumber = "routing_number"
    static let accountNumber = "account_number"
    static let address = "address"
    static let latitude = "latitude"
    static let longitude = "longitude"
    
    static let dialCode = "dial_code"
    static let countryCode = "country_code"
    
    static let phoneNumber = "phone_number"
    static let gender = "gender"
    static let notificationStatus = "notification_status"
    static let newPassword = "new_password"
    static let oldPassword = "old_password"
    static let language = "language"
    
    //Customer side map module params
    
    static let source = "source"
    static let destination = "destination"
    static let sourceLat = "source_lat"
    static let sourceLong = "source_long"
    static let destinationLat = "destination_lat"
    static let destinationLong = "destination_long"
    static let vehicleMetaId = "vehicle_meta_id"
    static let paymentMethod = "payment_method"
    static let cardId = "card_id"
    static let bookingID = "bookingID"
    static let stripeCardId = "stripe_card_id"
    static let cardHolderName = "card_holder_name"
    static let cardLast4Digits = "card_last_4_digits"
    static let cardExpiryMonth = "card_expiry_month"
    static let cardExpiryYear = "card_expiry_year"
    static let cardBrandType = "card_brand_type"
    
    static let id = "id"

    
    
    //Common side Past Trip and its detail module params
    static let userType = "user_type"
    static let tripType = "trip_type"
    static let offset = "offset"
    static let limit = "limit"
    static let rating = "rating"
    static let review = "review"
    static let ratingFor = "rating_for"
    static let referenceId = "reference_id"
    static let ratingType = "rating_type"
    
    //Taxi Driver side Profile module params
    static let onlineStatus = "online_status"
    
    // Customer side Restaurant module params
    
    static let radius = "radius"
    static let search = "search"
    static let categoryIds = "category_ids"
    static let businessIds = "business_ids"
    static let restaurantId = "restaurant_id"
    static let categoryId = "category_id"
    static let menuId = "menu_id"
    static let quantity = "quantity"
    static let promoCodeId = "promo_code_id"
    static let isDefault = "is_default"
    static let deliveryAddressId = "delivery_address_id"
    
    static let paymentMode = "payment_mode"
    static let customerDeliveryAddressId = "customer_delivery_address_id"

 
    //Food Delivery side New order module params
    
    static let orderID = "orderID"
    static let currentStatus = "current_status"
    
    //Customer side Past order module and Upcoming module params
    
    static let driverId = "driver_id"
    static let driverRating = "driver_rating"
    static let driverReview = "driver_review"
    static let restaurantRating = "restaurant_rating"
    static let restaurantReview = "restaurant_review"

    //Notification module params
    
    static let alertId = "alert_id"
    static let referenceType = "reference_type"
    static let recipientUserId = "recipient_user_id"
    
    //Wallet module params
    static let date = "date"
    static let amount = "amount"
    
}

//Api Header
struct WsHeader {
    //Login
    static let deviceId                    = "Device-Id"
    static let deviceType                  = "Device-Type"
    static let timeZone                    = "Device-Timezone"
    static let CurrentLanguage              = "Device-Language"
    
}

//Api check for params
struct WsParamsType
{
    static let PathVariable                   = "Path Variable"
    static let QueryParams                    = "Query Params"
    
}



