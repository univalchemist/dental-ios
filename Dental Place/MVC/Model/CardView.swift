//
//  CardView.swift
//  LaptureApp
//
//  Created by administrator on 01/02/19.
//  Copyright © 2019 Lapture Systems! . All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView
{

    @IBInspectable var cornerRedius:CGFloat = 10
    @IBInspectable   var shadowOffWidth:CGFloat = 0
    @IBInspectable  var shadowoffHeight:CGFloat = 2
    @IBInspectable  var shadowColor:UIColor = UIColor.clear
    @IBInspectable  var shadowOpecity:CGFloat = 1
    
    
    
    override func layoutSubviews()
    {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = Float(shadowOpecity)
        //   backgroundColor = UIColor.gray
        layer.shadowOffset = CGSize(width: shadowOffWidth, height: shadowoffHeight)
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRedius)
        layer.shadowPath = path.cgPath
        
        layer.cornerRadius = cornerRedius//10
        layer.borderWidth = 0.8
        layer.borderColor = UIColor.lightGray.cgColor
    }

}

@IBDesignable
class CustomSlider: UISlider {
    /// custom slider track height
    @IBInspectable var trackHeight: CGFloat = 3
    @IBInspectable var cornerRedius:CGFloat = 2
    @IBInspectable   var shadowOffWidth:CGFloat = 0
    @IBInspectable  var shadowoffHeight:CGFloat = 2
    @IBInspectable  var shadowColor:UIColor = UIColor.clear
    @IBInspectable  var shadowOpecity:CGFloat = 1
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Use properly calculated rect
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
    
    
   
    
    
//    override func layoutSubviews()
//    {
//        layer.shadowColor = shadowColor.cgColor
//        layer.shadowOpacity = Float(shadowOpecity)
//        //   backgroundColor = UIColor.gray
//        layer.shadowOffset = CGSize(width: shadowOffWidth, height: shadowoffHeight)
//        //let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRedius)
//       // layer.shadowPath = path.cgPath
//
//        layer.cornerRadius = 10
//        layer.borderWidth = 0.8
//        layer.borderColor = UIColor.lightGray.cgColor
//    }
//
}
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
}
extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
