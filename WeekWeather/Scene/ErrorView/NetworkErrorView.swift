//
//  NetworkErrorView.swift
//  WeekWeather
//
//  Created by Egor on 21.01.2021.
//  Copyright © 2021 Egor. All rights reserved.
//

import UIKit

class NetworkErrorView: UIView {

    @IBOutlet var errorMessageLabel: UILabel!
    
    class func instanceFromNib() -> NetworkErrorView {
        return UINib(nibName: "NetworkErrorView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NetworkErrorView
    }
    
    func initView(message: String) {
        errorMessageLabel.text = message
    }
    
}
