//
//  WeatherVC.swift
//  WeekWeather
//
//  Created by Egor on 03/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

protocol WeatherVCDelegate {
    var newIconsArray: [String : UIImage] { get set }
    var imageArray: [String : UIImage] { get set }
    var showPreasureHumidity: Bool! { get set }
    var showSunPhases: Bool! { get set }
}

class WeatherViewController: UIViewController {

    var showPreasureHumidity: Bool!
    var showSunPhases: Bool!
    var imageKey: String!
    var dayForecast: DayForecast!
    var icon: UIImage!
    var currentTemp: Double!
    var delegate: WeatherVCDelegate!
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(imageLiteralResourceName: "clouds"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.opacity = 0.3
        return imageView
    }()
    
    func setBackgroundImage() {
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        backgroundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(rect: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)).cgPath
        
        backgroundImageView.layer.mask = shapeLayer
    }
    
    let weatherImageView: UIImageView = {
           let imageView = UIImageView(iconName: nil, tintColor: nil, image: nil, size: CGSize(width: 200, height: 150))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.bounds.size = CGSize(width: 200, height: 150)
            imageView.contentMode = .scaleAspectFit
    //        imageView.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            return imageView
        }()
    
    func timerForSettingImage(interval: Double, rerun: Bool, closure: @escaping () -> (), condition: @escaping () -> (Bool)) {
        
        var runCount = 0
        
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            closure()
            runCount += 1
            print("runCount: ", runCount)

            if condition() || runCount == 20 {
                if condition() {
                    timer.invalidate()
                }
                else if rerun {
                    timer.invalidate()
                    self.timerForSettingImage(interval: 0.2, rerun: false, closure: closure, condition: condition)
                }
                else {
                    timer.invalidate()
                }
            }
        }
//        timer.tolerance = 0.2
//        RunLoop.current.add(timer, forMode: .RunLoop.Mode.common)
//        RunLoop.current.add(timer, forMode: .common)
//        timer.fire()
    }
    
    func setWeatherImage() {
        view.addSubview(weatherImageView)
        
        weatherImageView.centerAnchor(centerX: view.centerXAnchor,
                                      centerY: view.safeAreaLayoutGuide.centerYAnchor,
                                      constantX: 0,
                                      constantY: -weatherImageView.bounds.height/2)
        
//        if let icon = icon {
//            weatherImageView.image = icon
//        }
         if let currentImage = delegate.imageArray[imageKey] { //delegate.newIconsArray[imageKey] {
            weatherImageView.image = currentImage
        }
        else {
            let closure = {() -> () in self.weatherImageView.image = self.delegate.imageArray[self.imageKey] } //self.delegate.newIconsArray[self.imageKey] }
            let condition = {() -> (Bool) in return self.weatherImageView.image != nil }
            timerForSettingImage(interval: 0.1, rerun: true, closure: closure, condition: condition)
        }
    }
    
    func createMainBottomStackView() -> UIStackView {
        guard let dayForecast = dayForecast else { return UIStackView() }
        
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
        
        let mainBottomStackView = UIStackView(spacing: 23, axis: .horizontal,
                                              distribution: .equalSpacing, alignment: .center,
                                              views: [morningStackView, dayStackView, eveningStackView, nightStackView])
        view.addSubview(mainBottomStackView)
        
        mainBottomStackView.anchor(top: nil,
                                   leading: nil,
                                   bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                   trailing: nil,
                                   padding: UIEdgeInsets(top: 777, left: 777, bottom: 10, right: 777))
        
        mainBottomStackView.centerAnchor(centerX: self.view.centerXAnchor, centerY: nil, constantX: 0, constantY: 777)
        
        return mainBottomStackView
    }
    
    func createTempLabel() -> UILabel {
        let label = UILabel(text: String(format: "%.0f", currentTemp) + AppConstants.celsius,
                            color: .darkGray,
                            height: 92, size: 77)
        
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
    
    func createDescrLabel(view: UIView) -> UILabel {
        guard let dayForecast = dayForecast, let weather = dayForecast.weather.first else { return UILabel() }
        let label = UILabel(text: weather.description,
                            color: .darkGray,
                            height: 24, size: 20)
        
        view.addSubview(label)
        
        label.anchor(top: view.bottomAnchor,
                     leading: nil,
                     bottom: nil,
                     trailing: view.trailingAnchor,
                     padding: UIEdgeInsets(top: 0, left: 777,
                                           bottom: 777, right: 0),
                     size: CGSize(width: label.bounds.size.width, height: 24))
        return label
    }
    
    func createSunPhasesIfNeeded() {
        let closure = {() -> () in
            if let showSunPhases = self.delegate.showSunPhases {
                self.showSunPhases = showSunPhases
                if showSunPhases { self.createSunPhases() }
            }
        }
        
        let condition = {() -> (Bool) in
            return self.showSunPhases != nil
        }
        timerForSettingImage(interval: 0.1, rerun: true, closure: closure, condition: condition)
    }
    
    func createPreasureHumidityIfNeeded() {
        let closure = {() -> () in
            if let showPreasureHumidity = self.delegate.showPreasureHumidity {
                self.showPreasureHumidity = showPreasureHumidity
                if showPreasureHumidity { self.createPreasureAndHumidity() }
            }
        }
        
        let condition = {() -> (Bool) in
            return self.showSunPhases != nil
        }
        timerForSettingImage(interval: 0.1, rerun: true, closure: closure, condition: condition)
    }
    
    func createSunPhases() -> (UIImageView, UIImageView) {
        guard let dayForecast = dayForecast else { return (UIImageView(), UIImageView()) }
        //let sunriseImageView = UIImageView(iconName: "sunrise", tintColor:  #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1), image: nil)
        let sunriseImageView = UIImageView(iconName: "sunrise", tintColor:  #colorLiteral(red: 1, green: 0.7834197891, blue: 0, alpha: 0.6987639127), image: nil)
        let sunriseLabel = UILabel(text: DateService.getDate(unixTime: dayForecast.sunrise, dateFormat: "HH:mm"), color: #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1))
        view.addSubview(sunriseImageView)
        view.addSubview(sunriseLabel)
        
        
        //let sunsetImageView = UIImageView(iconName: "sunset", tintColor:  #colorLiteral(red: 1, green: 0.4352941176, blue: 0, alpha: 1), image: nil)
        let sunsetImageView = UIImageView(iconName: "sunset", tintColor:  #colorLiteral(red: 1, green: 0.4352941176, blue: 0, alpha: 0.6951519692), image: nil)
        let sunsetLabel = UILabel(text: DateService.getDate(unixTime: dayForecast.sunset, dateFormat: "HH:mm"), color: #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1))
        view.addSubview(sunsetImageView)
        view.addSubview(sunsetLabel)
        
        sunriseImageView.bounds.size = CGSize(width: 60, height: 60)
        
        sunriseImageView.anchor(top: nil,
                                leading: view.safeAreaLayoutGuide.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: nil,
                                padding: UIEdgeInsets(top: 777,
                                                      left: 20,
                                                      bottom: (view.bounds.height * 1/4),
                                                      right: 777),
                                size: .zero)
        
        sunriseLabel.anchor(top: sunriseImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: -8, left: 777, bottom: 777, right: 777), size: .zero)
        
        sunriseLabel.centerAnchor(centerX: sunriseImageView.centerXAnchor, centerY: nil, constantX: 0, constantY: 777)
        
        
        sunsetImageView.bounds.size = CGSize(width: 60, height: 60)
        
        sunsetImageView.anchor(top: nil,
                               leading: nil,
                               bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               trailing: view.safeAreaLayoutGuide.trailingAnchor,
                               padding: UIEdgeInsets(top: 777,
                                                     left: 777,
                                                     bottom: view.bounds.height * 1/4 /*(view.center.y * 3/2) - sunriseImageView.bounds.height*/,
                                                     right: 20),
                               size: .zero)
        
        sunsetLabel.anchor(top: sunsetImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: -8, left: 777, bottom: 777, right: 777), size: .zero)
        
        sunsetLabel.centerAnchor(centerX: sunsetImageView.centerXAnchor, centerY: nil, constantX: 0, constantY: 777)
        
        return (sunriseImageView, sunsetImageView)
    }
    
    func createPreasureAndHumidity() -> (UIImageView, UIImageView, UILabel, UILabel) {
        guard let dayForecast = dayForecast else { return (UIImageView(), UIImageView(), UILabel(), UILabel()) }
        let humidityImageView = UIImageView(iconName: "drop.triangle", tintColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.5), image: nil, size: CGSize(width: 80, height: 80))
        let humidityLabel = UILabel(text: "\(Int(dayForecast.humidity))" + "%", color: .darkGray)
        view.addSubview(humidityImageView)
        view.addSubview(humidityLabel)
        
        
        let preasureImageView = UIImageView(iconName: "gauge", tintColor: .gray, image: nil, size: CGSize(width: 35, height: 35))
        let preasureLabel = UILabel(text: String(format: "%.0f", dayForecast.pressure * 0.750062) + "mm", color: .darkGray)
        view.addSubview(preasureImageView)
        view.addSubview(preasureLabel)
        
        //humidityImageView.bounds.size = CGSize(width: 90, height: 90)
        
        humidityImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                leading: view.safeAreaLayoutGuide.leadingAnchor,
                                bottom: nil,
                                trailing: nil,
                                padding: UIEdgeInsets(top:  -5,
                                                      left: -10,
                                                      bottom: 777,
                                                      right: 777),
                                size: .zero)
        
        humidityLabel.anchor(top: humidityImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: -11, left: 777, bottom: 777, right: 777), size: .zero)
        
        humidityLabel.centerAnchor(centerX: humidityImageView.centerXAnchor, centerY: nil, constantX: 0, constantY: 777)
        
        
        //preasureImageView.bounds.size = CGSize(width: 60, height: 60)
        
        preasureImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 leading: humidityImageView.trailingAnchor,
                               bottom: nil,
                               trailing: nil,
                               padding: UIEdgeInsets(top: 22,
                                                     left: 11,
                                                     bottom: 777,
                                                     right: 777),
                               size: .zero)

        preasureLabel.anchor(top: preasureImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 7, left: 777, bottom: 777, right: 777), size: .zero)

        preasureLabel.centerAnchor(centerX: preasureImageView.centerXAnchor, centerY: nil, constantX: 0, constantY: 777)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: 40, y: 45), radius: 15, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
        
        humidityImageView.layer.mask = shapeLayer
        
        return (humidityImageView, preasureImageView, humidityLabel, preasureLabel)
    }
    
    func makeGradient(view: UIView) {
        view.backgroundColor = .blue
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.blue.cgColor, UIColor.red.cgColor]
        gradientLayer.locations = [0, 0.2, 1]
        view.layer.mask = gradientLayer
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.title = DateService.getDate(unixTime: dayForecast.dt, dateFormat: "EEEE, dd MMM")
        
        let tempLabel = createTempLabel()
        createDescrLabel(view: tempLabel)
        setWeatherImage()
        createMainBottomStackView()
        //createSunPhasesIfNeeded() //-> 👇
        createSunPhases()
        //createPreasureHumidityIfNeeded() //-> 👇
        let (imageVHum, imageVPreas, labelHum, labelPreas) = createPreasureAndHumidity()
        setBackgroundImage()
        
        
        
        //makeGradient(view: labelPreas)
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
        //self.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
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
        
        self.contentMode = .scaleAspectFit
        
        if let tintColor = tintColor { self.tintColor = tintColor }
        
        self.anchorSize(size: size)
    }
}
