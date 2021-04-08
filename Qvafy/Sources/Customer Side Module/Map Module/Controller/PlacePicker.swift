//
//  GooglePlacePicker.swift
//  Appointment
//
//  Created by Apple on 31/07/18.
//  Copyright © 2018 MINDIII. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

import INTULocationManager

class PlacePicker:NSObject, GMSAutocompleteViewControllerDelegate {

    var strAddress = ""
    var strLat = ""
    var strLong = ""

    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    static let shared = PlacePicker()

    var successBlock : ((_ placeInfo: [String: Any])->())?
    var failureBlock : ((_ error: Error)->())?
    var controller: UIViewController?

    override init() {
        print("Shared Place initialized.")

    }

    func openPicker(controller: UIViewController, success: @escaping ([String: Any])->(), failure: @escaping (Error)-> ()) {
        self.successBlock = success
        self.failureBlock = failure
        self.controller = controller

        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.modalPresentationStyle = .fullScreen
//        self.controller?.modalPresentationStyle = .fullScreen
        self.controller?.present(autocompleteController, animated: true, completion: nil)

    }

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        var dict  = [String: Any]()
        dict["coordLat"] = place.coordinate.latitude
        dict["coordLong"] = place.coordinate.longitude
        dict["lat"] = String(place.coordinate.latitude)
        dict["long"] = String(place.coordinate.longitude)
        dict["formattedAddress"]  = place.formattedAddress
        dict["placeName"]  = place.name
        self.successBlock?(dict)
        self.successBlock = nil
        self.failureBlock = nil
        self.controller?.dismiss(animated: true, completion: nil)

    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.failureBlock?(error)
        self.successBlock = nil
        self.failureBlock = nil
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {

        self.controller?.dismiss(animated: true, completion: nil)
        self.successBlock = nil
        self.failureBlock = nil

    }
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}

//MARK:- Place Api
extension PlacePicker{

    func locationAuthorization(controller: UIViewController, success: @escaping ([String: Any])->(), failure: @escaping (Error)-> ()) {

        self.successBlock = success
        self.failureBlock = failure

        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            self.PlaceAPIWork()

        }else if CLLocationManager.authorizationStatus() == .authorizedAlways{
            self.PlaceAPIWork()
        }
        else if (CLLocationManager.authorizationStatus() == .denied) {

            let alert = UIAlertController(title: "Need_Authorization".localize, message: "This app is unusable if you don't authorize this app to use your location!".localize, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel".localize, style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel".localize, style: .default, handler: { _ in
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }))
            controller.present(alert, animated: true, completion: nil)

        } else {
            locManager.requestWhenInUseAuthorization()
            self.PlaceAPIWork()
        }
    }

    func PlaceAPIWork(){
        let locationManager = INTULocationManager.sharedInstance()
        locationManager.requestLocation(withDesiredAccuracy: .city,timeout: 10.0,delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in

            if (status == INTULocationStatus.success) {let lcc = CLLocation.init(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
                self.strLat = String(describing: (currentLocation?.coordinate.latitude)!)
                self.strLong = String(describing: (currentLocation?.coordinate.longitude)!)

                 _ = self.getAddressFromLocation(location: lcc)
            }else if (status == INTULocationStatus.timedOut) {}else {} }
    }

    func getAddressFromLocation(location:CLLocation) ->String{
        var addressString = String()
        CLGeocoder().reverseGeocodeLocation(location,completionHandler: {(placemarks, error) -> Void in
            //locationManager.stopUpdatingLocation()
            if error != nil {
                return
            }
            if (placemarks?.count)! > 0 {
                let pm = placemarks?.last
                if let formattedAddress = pm?.addressDictionary?["FormattedAddressLines"] as? [String] {
                    addressString = formattedAddress.joined(separator: ", ")
                    self.strAddress = addressString

                    var dict  = [String: String]()
                    dict["lat"] = self.strLat
                    dict["long"] = self.strLong
                    dict["add"] = self.strAddress
                    self.successBlock?(dict)

                }}
            else {
            }
        })
        return addressString
    }

}

extension PlacePicker{
    func showLocationAlert() {
        let alert = UIAlertController(title: "Location_is_disabled".localize, message: "We need access to your location to show you relevant search result, Please click on Settings to allow location.".localize, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".localize, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings".localize, style: .default, handler: { _ in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        //self.present(alert, animated: true, completion: nil)
    }



    func getUserCurrentAdreessUsingGoogleAPI( success: @escaping (AddressModel)->(), failure: @escaping (Error)-> ()){

        if (CLLocationManager.authorizationStatus() == .denied) {
            self.showLocationAlert()
            let errorTemp = NSError(domain:"locaion access denied", code:10, userInfo:nil)
            failure(errorTemp)
        }
        else{
            let locationManager = INTULocationManager.sharedInstance()
            locationManager.requestLocation(withDesiredAccuracy: .city,timeout: 10.0,delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in

                if (status == INTULocationStatus.success) {
                    self.reverseGeocodeCoordinate((currentLocation?.coordinate)!, success: { (address) in

                        success(address)

                    }, failure: { (error) in
                        failure(error)
                    })
                }
                else if (status == INTULocationStatus.timedOut) {
                    let errorTemp = NSError(domain:"", code:10, userInfo:nil)
                    failure(errorTemp)

                }
                else {
                    let errorTemp = NSError(domain:"", code:100, userInfo:nil)
                    failure(errorTemp)

                }

            }
        }

    }

    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, success: @escaping (AddressModel)->(), failure: @escaping (Error)-> ()) {

        let geocoder = GMSGeocoder()

        print("coordinate = \(coordinate)")
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let err =  error {
                  failure(err)
                return
            }

            guard let address = response?.firstResult(), let lines = address.lines else {
                let errorTemp = NSError(domain:"", code:1000, userInfo:nil)
                failure(errorTemp)
                return
            }
            print("address = \(address)")

            let addrLines = lines.joined(separator: "\n")
            let currentAddress = AddressModel()
            currentAddress.address = addrLines
            currentAddress.city = address.locality
            currentAddress.state = address.administrativeArea
            currentAddress.country = address.country
            currentAddress.zipCode = address.postalCode
            currentAddress.lat = String(address.coordinate.latitude)
            currentAddress.lng = String(address.coordinate.longitude)

            success(currentAddress)

        }
    }

    func getUserCurrentAdreessUsingAppleAPI( success: @escaping (AddressModel)->(), failure: @escaping (Error)-> ()){
        let locationManager = INTULocationManager.sharedInstance()
        locationManager.requestLocation(withDesiredAccuracy: .city,timeout: 10.0,delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in

            if (status == INTULocationStatus.success) {
                self.reverseGeocodeLocationNative(currentLocation!, success: { (address) in
                    success(address)
                }, failure: { (error) in
                    failure(error)
                })
            }
            else if (status == INTULocationStatus.timedOut) {
                let errorTemp = NSError(domain:"", code:10, userInfo:nil)
                failure(errorTemp)

            }
            else {
                let errorTemp = NSError(domain:"", code:10, userInfo:nil)
                failure(errorTemp)

            }

        }
    }

    func reverseGeocodeLocationNative(_ location: CLLocation, success: @escaping (AddressModel)->(), failure: @escaping (Error)-> ()) {

        CLGeocoder().reverseGeocodeLocation(location,completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                failure(error!)
                return
            }
            if let arrPlacemarks = placemarks, arrPlacemarks.count > 0{
                //                for pm in arrPlacemarks{
                //                    print(pm.addressDictionary)
                //                }
                let currentAdddress = AddressModel()
                if let clossestPlace =  arrPlacemarks.last, let addressLines =  clossestPlace.addressDictionary?["FormattedAddressLines"] as? [String]  {
                    currentAdddress.address = addressLines.joined(separator: ", ")
                    if let city = clossestPlace.locality{
                        currentAdddress.city = city
                    }
                    if let state = clossestPlace.administrativeArea{
                        currentAdddress.state = state
                    }
                    if let country = clossestPlace.country{
                        currentAdddress.country = country
                    }
                    if let zip = clossestPlace.postalCode{
                        currentAdddress.zipCode = zip
                    }
                    currentAdddress.lat = String(clossestPlace.location!.coordinate.latitude)
                    currentAdddress.lng = String(clossestPlace.location!.coordinate.longitude)
                    success(currentAdddress)
                }
            }
            else{
                let errorTemp = NSError(domain:"No Placemark found", code:10, userInfo:nil)
                failure(errorTemp)
            }
        })
    }

    func getUsersCurrentLocation(success: @escaping (CLLocationCoordinate2D)->(), failure: @escaping (Error)-> ()){

        if (CLLocationManager.authorizationStatus() == .denied) {
            self.showLocationAlert()
            let errorTemp = NSError(domain:"locaion access denied", code:10, userInfo:nil)
            failure(errorTemp)
        }
        else {
            let locationManager = INTULocationManager.sharedInstance()
            locationManager.requestLocation(withDesiredAccuracy: .block,timeout: 10.0,delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in

                if (status == INTULocationStatus.success) {
                    success((currentLocation?.coordinate)!)

                }else if (status == INTULocationStatus.timedOut) {
                    let errorTemp = NSError(domain:"timeout", code:10, userInfo:nil)
                    failure(errorTemp)
                }else {
                    let errorTemp = NSError(domain:"errr", code:10, userInfo:nil)
                    failure(errorTemp)
                }

            }
        }
    }

}

class AddressModel:NSObject{
    var address:String!
    var city:String!
    var state:String!
    var country:String!
    var zipCode:String!
    var lat :String!
    var lng :String!

    override init(){
        self.address = ""
        self.city = ""
        self.state = ""
        self.country = ""
        self.lat = ""
        self.lng = ""
    }
}
