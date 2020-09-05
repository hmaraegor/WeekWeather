//
//  WeatherVC.swift
//  WeekWeather
//
//  Created by Egor on 03/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    var dayForecast: DayForecast?
    
    let cardView: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = #colorLiteral(red: 0.8301728751, green: 0.9081035013, blue: 0.9764705896, alpha: 1)
    
    }
    
    
}
