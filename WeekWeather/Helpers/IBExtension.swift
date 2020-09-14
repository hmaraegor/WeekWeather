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
class DesignableImage: UIImageView {
}

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

extension UIView {
    
//    override open func prepareForInterfaceBuilder() {
//        setNeedsLayout()
//    }
    
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
