//
//  WeatherVC.swift
//  WeekWeather
//
//  Created by Egor on 03/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    var dayForecast: DayForecast!
    var icon: UIImage!
    var currentTemp: Double!
    
    let weatherImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.bounds.size = CGSize(width: 200, height: 150)
        imageView.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        return imageView
    }()
    
    func createMainBottomStackView() {
        guard let dayForecast = dayForecast else { return }
        
        let mornTempLabel = UILabel(text: String(format: "%.0f", dayForecast.temp.morn) + AppConstants.celsius, color: #colorLiteral(red: 0.4980392157, green: 0.4745098039, blue: 0, alpha: 1))
        let mornImageView = UIImageView(iconName: "sun.haze", tintColor:  #colorLiteral(red: 1, green: 0.8156862745, blue: 0, alpha: 0.5), image: nil)
        let mornDescrLabel = UILabel(text: "morning", color: #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1))
        let morningStackView = UIStackView(spacing: 5, axis: .vertical,
                                           distribution: .equalSpacing, alignment: .center,
                                           views: [mornTempLabel, mornImageView, mornDescrLabel])
        
        let dayTempLabel = UILabel(text: String(format: "%.0f", dayForecast.temp.day) + AppConstants.celsius, color: #colorLiteral(red: 0.4980392157, green: 0.3607843137, blue: 0, alpha: 1))
        let dayImageView = UIImageView(iconName: "sun.max", tintColor:  #colorLiteral(red: 1, green: 0.8156862745, blue: 0, alpha: 0.7441673801), image: nil)
        let dayDescrLabel = UILabel(text: "day", color: #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1))
        let dayStackView = UIStackView(spacing: 5, axis: .vertical,
                                           distribution: .equalSpacing, alignment: .center,
                                           views: [dayTempLabel, dayImageView, dayDescrLabel])
        
        let eveTempLabel = UILabel(text: String(format: "%.0f", dayForecast.temp.eve) + AppConstants.celsius, color: #colorLiteral(red: 0.4980392157, green: 0.1215686275, blue: 0, alpha: 1))
        let eveImageView = UIImageView(iconName: "sun.haze.fill", tintColor:  #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 0.5241063784), image: nil)
        let eveDescrLabel = UILabel(text: "evening", color: #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1))
        let eveningStackView = UIStackView(spacing: 5, axis: .vertical,
                                       distribution: .equalSpacing, alignment: .center,
                                       views: [eveTempLabel, eveImageView, eveDescrLabel])
        
        let nightTempLabel = UILabel(text: String(format: "%.0f", dayForecast.temp.night) + AppConstants.celsius, color: #colorLiteral(red: 0, green: 0.2352941176, blue: 0.4980392157, alpha: 1))
        let nightImageView = UIImageView(iconName: "moon", tintColor:  #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.5), image: nil)
        let nightDescrLabel = UILabel(text: "night", color: #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1))
        let nightStackView = UIStackView(spacing: 5, axis: .vertical,
                                           distribution: .equalSpacing, alignment: .center,
                                           views: [nightTempLabel, nightImageView, nightDescrLabel])
        
        let mainBottomStackView = UIStackView(spacing: 30, axis: .horizontal,
                                              distribution: .equalSpacing, alignment: .center,
                                              views: [morningStackView, dayStackView, eveningStackView, nightStackView])
        view.addSubview(mainBottomStackView)
        
        mainBottomStackView.anchor(top: nil,
                                   leading: nil,
                                   bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                   trailing: nil,
                                   padding: UIEdgeInsets(top: 777, left: 777, bottom: 10, right: 777))
        
        mainBottomStackView.centerAnchor(centerX: self.view.centerXAnchor, centerY: nil, constantX: 0, constantY: 777)
        
    }
    
    func setWeatherImage(){
        view.addSubview(weatherImageView)
        
        weatherImageView.centerAnchor(centerX: view.centerXAnchor,
                                      centerY: view.safeAreaLayoutGuide.centerYAnchor,
                                      constantX: 0,
                                      constantY: -weatherImageView.bounds.height)
        
        weatherImageView.image = icon
    }
    
    func setTempLabel() -> UILabel {
        let label = UILabel(text: String(format: "%.0f", currentTemp) + AppConstants.celsius,
                        height: 100, size: 81)
        
        view.addSubview(label)
        
        label.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                     leading: nil,
                     bottom: nil,
                     trailing: view.safeAreaLayoutGuide.trailingAnchor,
                     padding: UIEdgeInsets(top: 0, left: 777,
                                           bottom: 777, right: 10),
                     size: CGSize(width: label.bounds.size.width, height: 100))
        
        return label
    }
    
    func setLabel(text: String, color: UIColor = .black, font: String =  "HelveticaNeue-Light", height: CGFloat = 21, size: CGFloat = 17) -> UILabel {
        let label = UILabel()
        label.text = String(format: "%.0f", currentTemp) + AppConstants.celsius
        label.numberOfLines = 0
        label.sizeToFit()
        label.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        label.font = UIFont(name: "HelveticaNeue-Light", size: 81)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.8301728751, green: 0.9081035013, blue: 0.9764705896, alpha: 1)
        
        setTempLabel()
        setWeatherImage()
        createMainBottomStackView()
        
    }
    
}

extension UIStackView {
    convenience init(spacing: CGFloat, axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, views: [UIView]) {
        self.init()

        self.spacing = spacing
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}

extension UILabel {
    convenience init(text: String, color: UIColor = .black, font: String =  "HelveticaNeue-Light", height: CGFloat = 21, size: CGFloat = 17) {
        self.init()
        
        self.text = text
        self.textColor = color
        self.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        self.font = UIFont(name: font, size: size)
    }
}

extension UIImageView {
    convenience init(iconName: String?, tintColor: UIColor?, image: UIImage?, size: CGSize = CGSize(width: 60, height: 60)) {
        self.init()
        
        if let image = image {
            self.image = image
        }
        else if let iconName = iconName {
            self.image = UIImage(systemName: iconName)
        }
        
        if let tintColor = tintColor { self.tintColor = tintColor }
        
        self.anchorSize(size: size)
    }
}
