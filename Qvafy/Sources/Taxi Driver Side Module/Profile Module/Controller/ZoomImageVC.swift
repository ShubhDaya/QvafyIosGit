//
//  ZoomImageVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 23/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//


import UIKit
import SDWebImage
class ZoomImageVC: UIViewController , UIScrollViewDelegate {

    @IBOutlet weak var viewZoomImage: UIView!
    @IBOutlet weak var imgZoom: UIImageView!
    @IBOutlet weak var scrollViewImg: UIScrollView!
    @IBOutlet weak var vwBack: UIView!

    
    var strUrl = ""
    var objImage : UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.vwBack.setCornerRadius(radius: 20)
        self.vwBack.layer.cornerRadius = self.vwBack.frame.height/2
        self.scrollViewImg.minimumZoomScale = 1.0
        self.scrollViewImg.maximumZoomScale = 5.0
        self.scrollViewImg.delegate = self
        self.scrollViewImg.zoomScale = 1.0
        
            if let url = URL(string: (strUrl)){
                self.imgZoom.sd_setImage(with: url, placeholderImage: UIImage(named: "inactive_profile_ico"))
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.scrollViewImg.zoomScale = 1.0
        self.viewZoomImage.isHidden = true
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func btnBackZoomImg(_ sender: UIButton) {
        self.scrollViewImg.zoomScale = 1.0
        self.viewZoomImage.isHidden = true
        objAppShareData.isFromZoom = true
       self.dismiss(animated: false, completion: nil)

      //  self.navigationController?.popViewController(animated: false)
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgZoom
    }

}
