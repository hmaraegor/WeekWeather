//
//  IBExtension.swift
//  WeekWeather
//
//  Created by Egor on 11/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableImageInCircle: UIImageView {

    @IBInspectable var arcCenter: CGPoint = CGPoint(x: 500.0, y: 500.0)
    @IBInspectable var radius: CGFloat = 1000
    @IBInspectable var circleInCenter: Bool = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let shapeLayer = CAShapeLayer()
        
        if circleInCenter {
            arcCenter.x = self.bounds.width/2
            arcCenter.y = self.bounds.height/2
        }
        
        shapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: arcCenter.x, y: arcCenter.y), radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
        
        layer.mask = shapeLayer
    }
    
    override func prepareForInterfaceBuilder() {
        setNeedsLayout()
    }
}

@IBDesignable
class DesignableSpecialCorners: UIView {

    @IBInspectable var leftTopCorner: Bool = true
    @IBInspectable var rightTopCorner: Bool = true
    @IBInspectable var leftBottomCorner: Bool = true
    @IBInspectable var rightBottomCorner: Bool = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        
        var layerCorners1 = CACornerMask()
        var layerCorners2 = CACornerMask()
        var layerCorners3 = CACornerMask()
        var layerCorners4 = CACornerMask()
        
        if leftTopCorner { layerCorners1 = .layerMinXMinYCorner }
        if rightTopCorner { layerCorners2 = .layerMaxXMinYCorner }
        if leftBottomCorner { layerCorners3 = .layerMinXMaxYCorner }
        if rightBottomCorner { layerCorners4 = .layerMaxXMaxYCorner }
        
        layer.maskedCorners = [layerCorners1, layerCorners2, layerCorners3, layerCorners4]
    }
    
    override func prepareForInterfaceBuilder() {
        setNeedsLayout()
    }
}

@IBDesignable
class DesignableImage: UIImageView {
    override func prepareForInterfaceBuilder() {
        setNeedsLayout()
    }
}

@IBDesignable
class DesignableView: UIView {
    override func prepareForInterfaceBuilder() {
        setNeedsLayout()
    }
}

@IBDesignable
class DesignableButton: UIButton {
    override func prepareForInterfaceBuilder() {
        setNeedsLayout()
    }
}

@IBDesignable
class DesignableLabel: UILabel {
    override func prepareForInterfaceBuilder() {
        setNeedsLayout()
    }
}

extension UIView {
    
//    override open func prepareForInterfaceBuilder() {
//        setNeedsLayout()
//    }
    

    
    @IBInspectable
    var specialCorners: Bool {
        get {
            return true//layer.maskedCorners
        }
        set {
            clipsToBounds = true
            //layer.maskedCorners = newValue
        }
    }
    
//    private func setCorner() {
//        fileNameView.clipsToBounds = true
//        fileNameView.layer.cornerRadius = 10
//        fileNameView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//    }
//
//    private func returnCorner() {
//        fileNameView.layer.cornerRadius = 10
//        fileNameView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
