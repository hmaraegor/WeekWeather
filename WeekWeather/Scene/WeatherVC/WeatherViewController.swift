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
    
    func createBottomImageView(iconName: String, color: UIColor) -> UIImageView {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.image = UIImage(systemName: iconName)
        imageView.tintColor = color
        view.addSubview(imageView)
        return imageView
    }
    
    func createBottomLabel(color: UIColor, text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.sizeToFit()
        label.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        label.textColor = color
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
//        let fontFamilyNames = UIFont.familyNames
//        for familyName in fontFamilyNames {
//            print("------------------------------")
//            print("Font Family Name = [\(familyName)]")
//            let names = UIFont.fontNames(forFamilyName: familyName)
//            print("Font Names = [\(names)]")
//        }

        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
    
    func createBottomStackView(tempLabel: UILabel, imageView: UIImageView, descrLabel: UILabel) -> UIStackView {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.addArrangedSubview(tempLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(descrLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        return stackView
    }
    
    func createMainBottomStackView(mornSV: UIStackView, daySV: UIStackView, eveSV: UIStackView, nightSV: UIStackView) -> UIStackView {
        let stackView = UIStackView()
        stackView.spacing = 30
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.addArrangedSubview(mornSV)
        stackView.addArrangedSubview(daySV)
        stackView.addArrangedSubview(eveSV)
        stackView.addArrangedSubview(nightSV)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        return stackView
    }
    
    func createMainBottomStackView() {
        guard let dayForecast = dayForecast else { return }
        
        let mornTempLabel = createBottomLabel(color: #colorLiteral(red: 0.4980392157, green: 0.4745098039, blue: 0, alpha: 1), text:
            String(format: "%.0f", dayForecast.temp.morn) + AppConstants.celsius)
        let mornImageView = createBottomImageView(iconName: "sun.haze", color: #colorLiteral(red: 1, green: 0.8156862745, blue: 0, alpha: 0.5))
        let mornDescrLabel = createBottomLabel(color: #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1), text: "morning")
        let morningStackView = createBottomStackView(tempLabel: mornTempLabel, imageView: mornImageView, descrLabel: mornDescrLabel)
        
        let dayTempLabel = createBottomLabel(color: #colorLiteral(red: 0.4980392157, green: 0.3607843137, blue: 0, alpha: 1), text:
            String(format: "%.0f", dayForecast.temp.day) + AppConstants.celsius)
        let dayImageView = createBottomImageView(iconName: "sun.max", color: #colorLiteral(red: 1, green: 0.8156862745, blue: 0, alpha: 0.7441673801))
        let dayDescrLabel = createBottomLabel(color: #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1), text: "day")
        let dayStackView = createBottomStackView(tempLabel: dayTempLabel, imageView: dayImageView, descrLabel: dayDescrLabel)
        
        let eveTempLabel = createBottomLabel(color: #colorLiteral(red: 0.4980392157, green: 0.1215686275, blue: 0, alpha: 1), text: String(format: "%.0f", dayForecast.temp.eve) + AppConstants.celsius)
        let eveImageView = createBottomImageView(iconName: "sun.haze.fill", color: #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 0.5241063784))
        let eveDescrLabel = createBottomLabel(color: #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1), text: "evening")
        let eveningStackView = createBottomStackView(tempLabel: eveTempLabel, imageView: eveImageView, descrLabel: eveDescrLabel)
        
        let nightTempLabel = createBottomLabel(color: #colorLiteral(red: 0, green: 0.2352941176, blue: 0.4980392157, alpha: 1), text: String(format: "%.0f", dayForecast.temp.night) + AppConstants.celsius)
        let nightImageView = createBottomImageView(iconName: "moon", color: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.5))
        let nightDescrLabel = createBottomLabel(color: #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1), text: "night")
        let nightStackView = createBottomStackView(tempLabel: nightTempLabel, imageView: nightImageView, descrLabel: nightDescrLabel)
        
        let mainBottomStackView = createMainBottomStackView(mornSV: morningStackView, daySV: dayStackView, eveSV: eveningStackView, nightSV: nightStackView)
        
        
        mainBottomStackView.translatesAutoresizingMaskIntoConstraints = false
        mainBottomStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainBottomStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    func setPositionWeatherImage() {
        weatherImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor,
            constant: -weatherImageView.bounds.height).isActive = true
        weatherImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weatherImageView.image = icon
    }
    
    func setTempLabel() -> UILabel {
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
        
        view.addSubview(weatherImageView)
        setPositionWeatherImage()
        createMainBottomStackView()
        
        let label = UILabel(text: String(format: "%.0f", currentTemp) + AppConstants.celsius,
                        height: 100, size: 81)
        view.addSubview(label)
        
        label.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                     leading: nil,
                     bottom: nil,
                     trailing: view.safeAreaLayoutGuide.trailingAnchor,
                     padding: UIEdgeInsets(top: 0, left: 777,
                                           bottom: 777, right: 10),
                     size: label.bounds.size)
        
        
    }
    
    
}

extension UILabel {
    convenience init(text: String, color: UIColor = .black, font: String =  "HelveticaNeue-Light", height: CGFloat = 21, size: CGFloat = 17) {
        self.init()
        self.text = text
        self.textColor = color
        self.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        self.font = UIFont(name: font, size: size)
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

//func setupViews() {
//    if #available(iOS 11.0, *) {
//        profilePic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
//    } else {
//        profilePic.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 30).isActive = true
//    }
//}
