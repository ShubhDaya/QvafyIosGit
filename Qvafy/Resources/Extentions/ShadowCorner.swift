//
//  ShadowCorner.swift
//  Trade
//
//  Created by Mindiii on 5/8/18.
//  Copyright © 2018 Mindiii. All rights reserved.
//

import UIKit

class ShadowCorner: NSObject {
    
}
extension UIView{
    
    func setviewbottomShadow(){
        layer.shadowColor =  #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
    }
    
    func setviewBottomShadowLight()
    {
        layer.shadowColor =  #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: -0.5 , height: 4.0)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 2.5
    }
    
  
    
    func creatDashedLine(view: UIView){
        let topPoint = CGPoint(x: view.bounds.minX, y: view.bounds.maxY)
        let bottomPoint = CGPoint(x: view.bounds.maxX, y: view.bounds.maxY)
        view.createDashedLine(from: topPoint, to: bottomPoint, color: #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1) , strokeLength: 8, gapLength: 4, width: 0.5)
    }
    
    func setShadowCornerRadius(){
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowRadius = 6.0
        layer.masksToBounds = false
    }
    
    func setCornerRadBoarder(color : UIColor,cornerRadious : Int){
        layer.cornerRadius = CGFloat(cornerRadious)
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
    }
    
    func setCornerRadiusQwafy(vw : UIView){
          vw.layer.cornerRadius = 24
        vw.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        vw.layer.borderWidth = 1.0
    }
    
    
    func setViewRole(view : UIView){
        view.layer.cornerRadius = 22.5
        view.layer.masksToBounds = true;
        view.layer.shadowColor = #colorLiteral(red: 0.5764705882, green: 0.5764705882, blue: 0.5764705882, alpha: 0.1495378521)
            // UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        view.layer.shadowRadius = 6.0
        view.layer.masksToBounds = false
    }
    
    func setViewCircle(vwImage:UIView){
        vwImage.layer.cornerRadius = vwImage.layer.frame.size.height / 2
        vwImage.layer.masksToBounds = true
        vwImage.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        vwImage.layer.borderWidth = 2.0
    }
    
    
    func setButtonView(vwOuter : UIView , vwImage : UIView ,btn :UIButton){
        vwImage.layer.cornerRadius = vwImage.layer.frame.size.height / 2
        vwImage.layer.masksToBounds = true
        vwImage.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        vwImage.layer.borderWidth = 2.0
        vwOuter.layer.cornerRadius = 25
        vwOuter.layer.masksToBounds = true;
        vwOuter.layer.shadowColor = UIColor.lightGray.cgColor
        vwOuter.layer.shadowOpacity = 0.8
        vwOuter.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        vwOuter.layer.shadowRadius = 6.0
        vwOuter.layer.masksToBounds = false
        btn.layer.cornerRadius = 22.5
    }
    
    
    func setButtonVerifyView(vwOuter : UIView  ,btn :UIButton,viewRadius:Int, btnRadius:Int){
        vwOuter.layer.cornerRadius = CGFloat(viewRadius)//22.5
        vwOuter.layer.masksToBounds = true;
        vwOuter.layer.shadowColor = UIColor.lightGray.cgColor
        vwOuter.layer.shadowOpacity = 0.8
        vwOuter.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        vwOuter.layer.shadowRadius = 6.0
        vwOuter.layer.masksToBounds = false
        btn.layer.cornerRadius = CGFloat(btnRadius)//22.5
    }
    
    func setProfileVerifyView(vwOuter : UIView  ,img :UIImageView){
        vwOuter.layer.cornerRadius = 22.5
        vwOuter.layer.masksToBounds = true;
        vwOuter.layer.shadowColor = UIColor.lightGray.cgColor
        vwOuter.layer.shadowOpacity = 0.8
        vwOuter.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        vwOuter.layer.shadowRadius = 6.0
        vwOuter.layer.masksToBounds = false
        img.layer.cornerRadius = img.frame.height/2
        img.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        img.layer.borderWidth = 3
    }
    
    func setSubProfileVerifyView(vwOuter : UIView  ,img :UIImageView , radius: Int){
        vwOuter.layer.cornerRadius = CGFloat(radius)
        vwOuter.layer.masksToBounds = true;
        vwOuter.layer.shadowColor = UIColor.lightGray.cgColor
        vwOuter.layer.shadowOpacity = 0.8
        vwOuter.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        vwOuter.layer.shadowRadius = 6.0
        vwOuter.layer.masksToBounds = false
        img.layer.cornerRadius = img.frame.height/2
        img.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        img.layer.borderWidth = 2
    }
    
    func setUserProfileView(vwOuter : UIView  ,img :UIImageView , radius: Int){
        vwOuter.layer.cornerRadius = CGFloat(radius)
        vwOuter.layer.masksToBounds = true;
        vwOuter.layer.shadowColor = UIColor.lightGray.cgColor
        vwOuter.layer.shadowOpacity = 0.8
        vwOuter.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        vwOuter.layer.shadowRadius = 6.0
        vwOuter.layer.masksToBounds = false
        img.layer.cornerRadius = img.frame.height/2
        img.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        img.layer.borderWidth = 1
    }
    
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,byRoundingCorners: corners,cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
        
    func setCornerRadiusBoarder(color : UIColor,cornerRadious : Int){
        layer.cornerRadius = CGFloat(cornerRadious)
        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = color.cgColor
    }
    
    func setCornerRadius(radius : Int){
        layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }
    
    func setShadowListCornerRadius(cornerRadious : Int){
        layer.cornerRadius = CGFloat(cornerRadious) //8
        layer.masksToBounds = true;
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowRadius = 6.0
        layer.masksToBounds = false
    }
    func setShadowWithCornerRadius(){
        layer.cornerRadius = 5
        layer.masksToBounds = true;
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowRadius = 3.0
        layer.masksToBounds = false
    }
    
    func setViewborder(color : UIColor){
        //layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = color.cgColor
    }
    func createDashedLine(from point1: CGPoint, to point2: CGPoint, color: UIColor, strokeLength: NSNumber, gapLength: NSNumber, width: CGFloat) {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [strokeLength, gapLength]
        
        let path = CGMutablePath()
        //  path.addLines(between: [point1, point2])
        path.addLines(between: [point1, point2])
        
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
}


class CustomDashedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
    
    
    
}



//class CustomDottedView: UIView {

@IBDesignable class DottedVertical: UIView {
    
    @IBInspectable var dotColor: UIColor = .clear
    @IBInspectable var lowerHalfOnly: Bool = false
    
    override func draw(_ rect: CGRect) {
        
        // say you want 8 dots, with perfect fenceposting:
        let totalCount = 5 + 5 - 1
        let fullHeight = bounds.size.height
        let width = bounds.size.width
        let itemLength = fullHeight / CGFloat(totalCount)
        
        let path = UIBezierPath()
        
        let beginFromTop = CGFloat(0.0)
        let top = CGPoint(x: width/2, y: beginFromTop)
        let bottom = CGPoint(x: width/2, y: fullHeight)
        
        path.move(to: top)
        path.addLine(to: bottom)
        
        path.lineWidth = width
        
        let dashes: [CGFloat] = [itemLength, itemLength]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        
        // for ROUNDED dots, simply change to....
        //let dashes: [CGFloat] = [0.0, itemLength * 2.0]
        //path.lineCapStyle = CGLineCap.round
        
        dotColor.setStroke()
        path.stroke()
    }
}
//}
extension UIButton
{
    func setCornerRadius(cornerRadious : Int){
        layer.cornerRadius = CGFloat(cornerRadious)
        layer.masksToBounds = true
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
    }
    func setCornerRadWithBoarder(color : UIColor,cornerRadious : Int){
        layer.cornerRadius = CGFloat(cornerRadious)
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
    }
    
    //    func setCornerRediues(){
    //        layer.cornerRadius = 8
    //        layer.masksToBounds = true
    //        layer.borderWidth = 1
    //        layer.borderColor = UIColor.clear.cgColor
    //    }
    //
    //    func setCornerGrayRediues(){
    //        layer.cornerRadius = 8
    //        layer.masksToBounds = true
    //        layer.borderWidth = 1
    //        layer.borderColor = UIColor.lightGray.cgColor
    //    }
    //    func setClickColor(){
    //        layer.borderColor = #colorLiteral(red: 0.137254902, green: 0.768627451, blue: 0.4, alpha: 1)
    //        setTitleColor(#colorLiteral(red: 0.137254902, green: 0.768627451, blue: 0.4, alpha: 1), for: .normal)
    //    }
    //    func deSelectColor(){
    //        layer.borderColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
    //        setTitleColor(#colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1), for: .normal)
    //    }
    //    func setShadowButton(){
    //        layer.cornerRadius = 4
    //        layer.borderColor = UIColor.lightGray.cgColor
    //        layer.borderWidth = 0.7
    //        layer.shadowColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
    //        layer.shadowOffset = CGSize(width: 1, height: 1)
    //        layer.shadowRadius = 2
    //        layer.shadowOpacity = 0.7
    //    }
    //    func setShadowBtn(){
    //        layer.shadowColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
    //        layer.shadowOffset = CGSize(width: 1, height: 1)
    //        layer.shadowRadius = 2
    //        layer.shadowOpacity = 0.7
    //    }
}
extension UIButton {
    
    func applyGradient() {
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 35)
        gradient.startPoint = CGPoint(x:0.0, y:0.5)
        gradient.endPoint = CGPoint(x:1.0, y:0.5)
        
        gradient.colors = [UIColor.systemPink.cgColor, UIColor.blue.cgColor]
        // gradient.colors = [UIColor.init(red: 179, green: 12, blue: 14, alpha: 1).cgColor, UIColor.init(red: 2, green: 3, blue: 158, alpha: 1).cgColor]
        //  #b30c29
        // #02039e
        self.layer.addSublayer(gradient)
    }
    func setCornerRadiusWithBoarder(color : UIColor,cornerRadious : Int){
        layer.cornerRadius = CGFloat(cornerRadious)
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
    }
    
    
}
extension UITextField {
    func addDoneButtonOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self, action: #selector(resignFirstResponder))
        keyboardToolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = keyboardToolbar
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
extension UIColor {
    class func colorConvert(withData data:Data) -> UIColor {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor ?? UIColor(red: 23.0 / 255.0, green: 29.0 / 255.0, blue: 49.0 / 255.0, alpha: 1.0)
    }
    
    func encode() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
}
extension UILabel{
    
    func setCornerRadiusWithBoarder(color : UIColor,cornerRadious : Int){
        layer.cornerRadius = CGFloat(cornerRadious)
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
    }
}

extension Date{
    func strrigWithFormat(format:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        return formatter.string(from:self)
    }
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

extension String{
    func dateWithFormat(format:String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        return formatter.date(from:self) ?? Date()
    }
  
    func capitalizingFirstLetter() -> String {
    let first = String(prefix(1)).capitalized
    let other = String(dropFirst())
    return first + other
    }

    mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
    }
  
}
extension NSAttributedString {
    
    class func attributedPlaceholderString(string: String) -> NSAttributedString {
        let color = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        let attributedString =  NSAttributedString(string:string, attributes:[NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font :UIFont(name: "Nunito-SemiBold", size: 16.7)!])
        return attributedString
    }
    
    class func attributedPlaceholderStringForTextView(string: String) -> NSAttributedString {
        let color = #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1)
        let attributedString =  NSAttributedString(string:string, attributes:[NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font :UIFont(name: "Nunito-SemiBold", size: 16.7)!])
        return attributedString
    }
}

extension UIImageView
{
    
    func setImgeRadius(){
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
    }
    
    
}
