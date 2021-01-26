//
//  WeatherVC.swift
//  WeekWeather
//
//  Created by Egor on 03/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

extension UIScreen{
    static var width: Double {
        get {
            print("width", Double(UIScreen.main.bounds.size.width))
            return Double(main.bounds.size.width)
        }
    }
    static var height: Double {
        get {
            print("height", Double(UIScreen.main.bounds.size.height))
            return Double(main.bounds.size.height)
        }
    }
    static var scalee: Double {
        get {
            return Double(main.scale)
        }
    }
    
    static let size = UIScreen.main.bounds.size
}

protocol WeatherVCDelegate {
    var newIconsArray: [String : UIImage] { get set }
    var imageArray: [String : UIImage] { get set }
    var showPreasureHumidity: Bool! { get set }
    var showSunPhases: Bool! { get set }
}

class WeatherViewController: UIViewController {
    
    // MARK: - Properties

    var nextNavigation: NextNavigation!
    var showPreasureHumidity: Bool!
    var showSunPhases: Bool!
    var imageKey: String!
    var dayForecast: DayForecast!
    var icon: UIImage!
    var currentTemp: Double!
    var feelsLikeTemp: Double!
    var useLocalIcons: Bool!
    var delegate: WeatherVCDelegate!
    var isCalledHandlePan = false
    var blockNavigation: Navigation!
    
    var  colorScheme: SchemeProtocol!
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(imageLiteralResourceName: /*"stars"*/"clouds"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        //imageView.layer.opacity = 0.3
        return imageView
    }()
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView(iconName: nil, tintColor: nil, image: nil, size: CGSize(width: 240, height: 180))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.bounds.size = CGSize(width: 240, height: 180)
        imageView.contentMode = .scaleAspectFit
        //        imageView.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        return imageView
    }()
    
    // MARK: Setup Methods
    
    func setBackgroundImage() {
        backgroundImageView.image = colorScheme.image.backgroundExtInfoImg
        backgroundImageView.layer.opacity = colorScheme.opasity.backgroundImg
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        backgroundImageView.layer.opacity = colorScheme.opasity.backgroundImg
        backgroundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(rect: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)).cgPath
        
        backgroundImageView.layer.mask = shapeLayer
    }
    
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
        
        var offset: CGFloat = 0
        if UIScreen.width == 320 || (UIScreen.width == 375 && UIScreen.scalee == 2) { offset = 30 }
        
        weatherImageView.centerAnchor(centerX: view.centerXAnchor,
                                      centerY: view.safeAreaLayoutGuide.centerYAnchor,
                                      constantX: 0,
                                      constantY: (-weatherImageView.bounds.height/2) + offset)
        
        if let currentImage = delegate.imageArray[imageKey] { //delegate.newIconsArray[imageKey] {
            weatherImageView.image = currentImage
            //TODO:
            //weatherImageView.image = LocalImages.getImage(by: "01n")
        }
        else {
            let closure = {() -> () in self.weatherImageView.image = self.delegate.imageArray[self.imageKey] } //self.delegate.newIconsArray[self.imageKey] }
            let condition = {() -> (Bool) in return self.weatherImageView.image != nil }
            timerForSettingImage(interval: 0.1, rerun: true, closure: closure, condition: condition)
        }
        weatherImageView.layer.opacity = colorScheme.opasity.weatherIcon
    }
    
    func createMainBottomStackView() -> UIStackView {
        guard let dayForecast = dayForecast else { return UIStackView() }
        
        let mornTempLabel = UILabel(text: TempS.tempToString(temp: dayForecast.temp.morn), color: colorScheme.color.mornTemp)
        let mornImageView = UIImageView(iconName: "sun.haze", tintColor: colorScheme.color.mornIcon , image: nil)
        let mornDescrLabel = UILabel(text: LocString.WeatherInfo.morning, color: colorScheme.color.mornDescr)
        let morningStackView = UIStackView(spacing: 5, axis: .vertical,
                                           distribution: .equalSpacing, alignment: .center,
                                           views: [mornTempLabel, mornImageView, mornDescrLabel])
        
        let dayTempLabel = UILabel(text: TempS.tempToString(temp: dayForecast.temp.day), color: colorScheme.color.dayTemp)
        let dayImageView = UIImageView(iconName: "sun.max", tintColor: colorScheme.color.dayIcon, image: nil)
        let dayDescrLabel = UILabel(text: LocString.WeatherInfo.day, color: colorScheme.color.dayDescr)
        let dayStackView = UIStackView(spacing: 5, axis: .vertical,
                                           distribution: .equalSpacing, alignment: .center,
                                           views: [dayTempLabel, dayImageView, dayDescrLabel])
        
        let eveTempLabel = UILabel(text: TempS.tempToString(temp: dayForecast.temp.eve), color: colorScheme.color.eveTemp)
        let eveImageView = UIImageView(iconName: "sun.haze.fill", tintColor: colorScheme.color.eveIcon, image: nil)
        let eveDescrLabel = UILabel(text: LocString.WeatherInfo.evening, color: colorScheme.color.eveDescr)
        let eveningStackView = UIStackView(spacing: 5, axis: .vertical,
                                       distribution: .equalSpacing, alignment: .center,
                                       views: [eveTempLabel, eveImageView, eveDescrLabel])
        
        let nightTempLabel = UILabel(text: TempS.tempToString(temp: dayForecast.temp.night), color: colorScheme.color.nightTemp)
        let nightImageView = UIImageView(iconName: "moon", tintColor: colorScheme.color.nightIcon, image: nil)
        let nightDescrLabel = UILabel(text: LocString.WeatherInfo.night, color: colorScheme.color.nightDescr)
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
    
    func createFeelsLikeLabel(tempLabel: UILabel) -> UILabel {
        let label = UILabel(text: LocString.Cell.feels_like + TempS.tempToString(temp: feelsLikeTemp),
                            color: colorScheme.color.tempLabel,
                            height: 20, size: 16)
        
        view.addSubview(label)
        
        label.anchor(top: tempLabel.bottomAnchor,
                     leading: nil,
                     bottom: nil,
                     trailing: tempLabel.trailingAnchor,
                     padding: UIEdgeInsets(top: -10, left: 777,
                                           bottom: 777, right: 0),
                     size: CGSize(width: label.bounds.size.width, height: 24))
        
        return label
    }
    
    func createTempLabel() -> UILabel {
        let label = UILabel(text: TempS.tempToString(temp: currentTemp),
                            color: colorScheme.color.tempLabel /*.darkGray*/,
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
    
    func createDescrLabel(feelsView: UIView, tempView: UIView) -> UILabel {
        guard let dayForecast = dayForecast, let weather = dayForecast.weather.first else { return UILabel() }
        let label = UILabel(text: weather.description,
                            color: colorScheme.color.descrLabel /*.darkGray*/,
                            height: 24, size: 20)
        
        feelsView.addSubview(label)
        
        var anch: (top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom:  NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?) = (top: feelsView.bottomAnchor, leading: nil, bottom: nil, trailing: feelsView.trailingAnchor)
        var padd: (top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) = (top: 5, left: 777,
                                                                                    bottom: 777, right: 0)
        
        if UIScreen.width == 320 {
            anch = (top: nil, leading: nil, bottom: tempView.topAnchor, trailing: tempView.trailingAnchor)
            padd = (top: 777, left: 777, bottom: -15, right: 0)
        }
            
        label.anchor(top: anch.top,
                     leading: anch.leading,
                     bottom: anch.bottom,
                     trailing: anch.trailing,
                     padding: UIEdgeInsets(top: padd.top, left: padd.left,
                                           bottom: padd.bottom, right: padd.right),
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
    
    func createSunPhases() -> (sunriseImg: UIImageView, sunsetImg: UIImageView) {
        guard let dayForecast = dayForecast else { return (UIImageView(), UIImageView()) }
        let sunriseImageView = UIImageView(iconName: "sunrise", tintColor: colorScheme.color.sunriseIcon, image: nil)
        let sunriseLabel = UILabel(text: DateService.getDate(unixTime: dayForecast.sunrise, dateFormat: "HH:mm"), color: colorScheme.color.sunriseLabel )
        let sunriseLabel2 = UILabel(text: "7:02", color: colorScheme.color.sunriseLabel )
        view.addSubview(sunriseImageView)
        view.addSubview(sunriseLabel)
        
        var offset: CGFloat = 0
        if UIScreen.width == 320 { offset = 20 }
        
        let sunsetImageView = UIImageView(iconName: "sunset", tintColor: colorScheme.color.sunsetIcon , image: nil)
        let sunsetLabel = UILabel(text: DateService.getDate(unixTime: dayForecast.sunset, dateFormat: "HH:mm"), color: colorScheme.color.sunsetLabel )
        let sunsetLabel2 = UILabel(text: "16:55", color: colorScheme.color.sunsetLabel )
        view.addSubview(sunsetImageView)
        view.addSubview(sunsetLabel)
        
        sunriseImageView.bounds.size = CGSize(width: 60, height: 60)
        
        sunriseImageView.anchor(top: nil,
                                leading: view.safeAreaLayoutGuide.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: nil,
                                padding: UIEdgeInsets(top: 777,
                                                      left: 20,
                                                      bottom: (view.bounds.height * 1/4) + offset,
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
                                                     bottom: view.bounds.height * 1/4  + offset /*(view.center.y * 3/2) - sunriseImageView.bounds.height*/,
                                                     right: 20),
                               size: .zero)
        
        sunsetLabel.anchor(top: sunsetImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: -8, left: 777, bottom: 777, right: 777), size: .zero)
        
        sunsetLabel.centerAnchor(centerX: sunsetImageView.centerXAnchor, centerY: nil, constantX: 0, constantY: 777)
        
        return (sunriseImageView, sunsetImageView)
    }
    
    func createPreasureAndHumidity() -> (humidityImg: UIImageView, preasureImg: UIImageView) {
        guard let dayForecast = dayForecast else { return (UIImageView(), UIImageView()) }
        let humidityImageView = UIImageView(iconName: "drop.triangle", tintColor: colorScheme.color.humidityIcon /* #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.5) */, image: nil, size: CGSize(width: 80, height: 80))
        let humidityLabel = UILabel(text: "\(Int(dayForecast.humidity))" + "%", color: colorScheme.color.humidityLabel /*.darkGray*/, size: 16)
        view.addSubview(humidityImageView)
        view.addSubview(humidityLabel)
        
        
        let preasureImageView = UIImageView(iconName: "gauge", tintColor: colorScheme.color.preasureIcon /*.gray*/, image: nil, size: CGSize(width: 35, height: 35))
        let preasureLabel = UILabel(text: String(format: "%.0f", dayForecast.pressure * 0.750062) + LocString.WeatherInfo.mm, color: colorScheme.color.preasureLabel /*.darkGray*/, size: 16)
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
        
        humidityLabel.anchor(top: humidityImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: -13, left: 777, bottom: 777, right: 777), size: .zero)
        
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

        preasureLabel.anchor(top: preasureImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 777, bottom: 777, right: 777), size: .zero)

        preasureLabel.centerAnchor(centerX: preasureImageView.centerXAnchor, centerY: nil, constantX: 0, constantY: 777)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: 40, y: 45), radius: 15, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
        
        humidityImageView.layer.mask = shapeLayer
        
        //return (humidityImg: humidityImageView, preasureImg: preasureImageView)
        return (humidityImageView, preasureImageView)
    }
    
    func createPreasureHumidityBackground(imagePreasure: UIImageView) {
        let backgroundView = UIView(color: colorScheme.color.preasureHumidityBg /* #colorLiteral(red: 0.768627451, green: 0.8509803922, blue: 0.9764705882, alpha: 0.4980201199)*/, size: nil, cornerRadius: 40, corners: (leftTop: false, rightTop: true, leftBottom: false, rightBottom: true))
        
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        
        backgroundView.anchor(top: imagePreasure.topAnchor,
                    leading: view.safeAreaLayoutGuide.leadingAnchor,
                    bottom: imagePreasure.bottomAnchor,
                    trailing: imagePreasure.trailingAnchor,
                    padding: UIEdgeInsets(top: -10,
                                          left: 0,
                                          bottom: -35,
                                          right: -23),
                    size: .zero)
        
    }
    
    func createSunriseSunsetBackground(suriseImg: UIImageView, susetImg: UIImageView) {
        let suriseBackgroundView = UIView(color: colorScheme.color.sunriseSunsetBg, size: nil, cornerRadius: 40, corners: (leftTop: false, rightTop: true, leftBottom: false, rightBottom: true))
        
        view.addSubview(suriseBackgroundView)
        view.sendSubviewToBack(suriseBackgroundView)
        
        suriseBackgroundView.anchor(top: suriseImg.topAnchor,
                    leading: view.safeAreaLayoutGuide.leadingAnchor,
                    bottom: suriseImg.bottomAnchor,
                    trailing: suriseImg.trailingAnchor,
                    padding: UIEdgeInsets(top: -2,
                                          left: 0,
                                          bottom: -18,
                                          right: -10),
                    size: .zero)
        
        
        let susetBackgroundView = UIView(color: colorScheme.color.sunriseSunsetBg, size: nil, cornerRadius: 40, corners: (leftTop: true, rightTop: false, leftBottom: true, rightBottom: false))
        
        view.addSubview(susetBackgroundView)
        view.sendSubviewToBack(susetBackgroundView)
        
        susetBackgroundView.anchor(top: susetImg.topAnchor,
                    leading: susetImg.leadingAnchor,
                    bottom: susetImg.bottomAnchor,
                    trailing: view.safeAreaLayoutGuide.trailingAnchor,
                    padding: UIEdgeInsets(top: -2,
                                          left: -10,
                                          bottom: -18,
                                          right: 0),
                    size: .zero)
        
    }
    
    func createBottomStackViewBackground(stackView: UIStackView) -> UIView {
        let stackViewBackgroundView = UIView(color: colorScheme.color.bottomStackBg, size: nil, cornerRadius: 30, corners: (leftTop: true, rightTop: true, leftBottom: true, rightBottom: true))
        
        view.addSubview(stackViewBackgroundView)
        view.sendSubviewToBack(stackViewBackgroundView)
        
        stackViewBackgroundView.anchor(top: stackView.topAnchor,
                    leading: stackView.leadingAnchor,
                    bottom: stackView.bottomAnchor,
                    trailing: stackView.trailingAnchor,
                    padding: UIEdgeInsets(top: -10,
                                          left: -20,
                                          bottom: -10,
                                          right: -20),
                    size: .zero)
        
        return stackViewBackgroundView
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
        
        
        let gradient = CAGradientLayer()
            gradient.frame = view.bounds

            let clearColor = UIColor.clear.cgColor
            let blackColor = UIColor.black.cgColor

            gradient.colors = [clearColor, clearColor, blackColor, blackColor, clearColor, clearColor]
            gradient.locations = [0.0, 0.15, 0.25, 0.75, 0.85, 1.0]
            view.layer.mask = gradient

        view.backgroundColor = UIColor.clear
        
    }
    
    func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
     
        gradientLayer.frame = self.view.bounds
        
        let firstColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        let secondColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0)
     
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
     
        self.view.layer.addSublayer(gradientLayer)
    }
    
    func useLocalIcon() {
        view.addSubview(weatherImageView)
        
        weatherImageView.centerAnchor(centerX: view.centerXAnchor,
                                      centerY: view.safeAreaLayoutGuide.centerYAnchor,
                                      constantX: 0,
                                      constantY: -weatherImageView.bounds.height/2)
        
        let iconName = dayForecast.weather.first?.icon ?? ""
        weatherImageView.image = LocalImages.getImage(by: iconName)
    }
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colorScheme.color.viewColor // #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.title = DateService.getDate(unixTime: dayForecast.dt, dateFormat: "EEEE, dd MMM")
        
        
        let tempLabel = createTempLabel()
        let feelsLikeLabel = createFeelsLikeLabel(tempLabel: tempLabel)
        createDescrLabel(feelsView: feelsLikeLabel, tempView: tempLabel)
        
        if useLocalIcons { useLocalIcon() }
        else  { setWeatherImage() }
        
        let bottomStackView = createMainBottomStackView()
        //createSunPhasesIfNeeded() //-> 👇
        let suns = createSunPhases()
        //createPreasureHumidityIfNeeded() //-> 👇
        var preasureHumidity = createPreasureAndHumidity()
        
        createPreasureHumidityBackground(imagePreasure: preasureHumidity.preasureImg)
        createSunriseSunsetBackground(suriseImg: suns.sunriseImg, susetImg: suns.sunsetImg)
        createBottomStackViewBackground(stackView: bottomStackView)
        
        setBackgroundImage()
        
        setupGestureRecognizers()
        
        //makeGradient(view: preasureHumidity.preasureImg)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //createGradientLayer()
    }
    
    // MARK: - GestureRecognizer
    
    private func setupGestureRecognizers() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panRecognizer)
    }
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        guard isCalledHandlePan == false else { return }
        var direction: Navigation
        let translation = sender.translation(in: view)
        let x = translation.x
        if x < 0 {
            direction = .forward
        } else {
            direction = .back
        }
        guard abs(x) > 50 else { return }
        guard blockNavigation != direction else { return }
        
        
        guard let navigationController = self.navigationController else { return }
        guard navigationController.viewControllers.count > 1 else { return }
        let navArrayCount = navigationController.viewControllers.count
        
//        self.navigationController?.popViewController(animated: false)
        
        opacityAnimation()
        positionAnimation(direction: direction)
        
        nextNavigation.navigation(inDirection: direction)
        var navigationArray = navigationController.viewControllers
        navigationArray.remove(at: navigationArray.count - 2)
        self.navigationController?.viewControllers = navigationArray
        
        isCalledHandlePan = true
    }
    
    // MARK: - Animations
    
    func opacityAnimation() {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        opacityAnimation.duration = 0.8
        view.layer.add(opacityAnimation, forKey: "opacity")
    }
    
    func positionAnimation(direction: Navigation) {
        let toXValue = (direction == .forward) ? -view.layer.position.x : (view.layer.position.x * 2)
        let screenSize: CGRect = UIScreen.main.bounds
        let theAnimation = CABasicAnimation(keyPath: "position")
        theAnimation.fromValue = CGPoint(x: view.layer.position.x, y: view.layer.position.y)
        theAnimation.toValue = CGPoint(x: toXValue, y: view.layer.position.y)
        theAnimation.duration = 1.1 //0.6
        view.layer.add(theAnimation, forKey: "position")
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
        
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
        
        self.anchorSize(size: size)
    }
}

extension UIView {
    convenience init(color: UIColor = .magenta, size: CGSize?, cornerRadius: CGFloat?, corners: (leftTop: Bool, rightTop: Bool, leftBottom: Bool, rightBottom: Bool) = (leftTop: true, rightTop: true, leftBottom: true, rightBottom: true)) {
        self.init()
        
        self.backgroundColor = color
        if let size = size {
            self.anchorSize(size: size)
        }
        
        guard let radius = cornerRadius else { return }
        layer.cornerRadius = radius
        
        var layerCorners1 = CACornerMask()
        var layerCorners2 = CACornerMask()
        var layerCorners3 = CACornerMask()
        var layerCorners4 = CACornerMask()
        
        if corners.leftTop { layerCorners1 = .layerMinXMinYCorner }
        if corners.rightTop { layerCorners2 = .layerMaxXMinYCorner }
        if corners.leftBottom { layerCorners3 = .layerMinXMaxYCorner }
        if corners.rightBottom { layerCorners4 = .layerMaxXMaxYCorner }
        
        layer.maskedCorners = [layerCorners1, layerCorners2, layerCorners3, layerCorners4]
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

extension UIView {
    func makeClearViewWithShadow(
        cornderRadius: CGFloat,
        shadowColor: CGColor,
        shadowOpacity: Float,
        shadowRadius: CGFloat) {
        
        self.frame = self.frame.insetBy(dx: -shadowRadius * 2,
                                        dy: -shadowRadius * 2)
        self.backgroundColor = .clear
        let shadowView = UIView(frame: CGRect(
            x: shadowRadius * 2,
            y: shadowRadius * 2,
            width: self.frame.width - shadowRadius * 4,
            height: self.frame.height - shadowRadius * 4))
        shadowView.backgroundColor = .black
        shadowView.layer.cornerRadius = cornderRadius
        shadowView.layer.borderWidth = 1.0
        shadowView.layer.borderColor = UIColor.clear.cgColor
        
        shadowView.layer.shadowColor = shadowColor
        shadowView.layer.shadowOpacity = shadowOpacity
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.layer.masksToBounds = false
        self.addSubview(shadowView)
        
        let p:CGMutablePath = CGMutablePath()
        p.addRect(self.bounds)
        p.addPath(UIBezierPath(roundedRect: shadowView.frame, cornerRadius: shadowView.layer.cornerRadius).cgPath)
        
        let s = CAShapeLayer()
        s.path = p
        s.fillRule = CAShapeLayerFillRule.evenOdd
        
        self.layer.mask = s
    }
}
