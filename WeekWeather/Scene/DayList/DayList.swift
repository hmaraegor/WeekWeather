//
//  ViewController.swift
//  WeekWeather
//
//  Created by Egor on 18/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

//MARK: ________________________ TableViewController ________________________

class DayList: UIViewController, DayCellDelegate, WeatherVCDelegate {
    
    var colorScheme: SchemeProtocol!
    
    var showPreasureHumidity: Bool!
    var showSunPhases: Bool!
    
    var oldIconsUrlWasPassed = false
    var imageArray = [String : UIImage]()
    var newIconsArray = [String : UIImage]()
    var useNewIcons = true
    var useSystemIcons = true
    var useLocalIconsForNoResponse = false // Don't touch
    
    @IBOutlet var backgroundImg: UIImageView!
    @IBOutlet var tableView: UITableView!
    private var weekForecastService = WeekForecastService()
    private var daylyForecast: WeekForecast?
    private let locationManager = CLLocationManager()
    var alreadyUpdatedLocation = false
    var weatherFromCoreDataLoaded = false
    var networkErrorShawed = false
    var errorView: NetworkErrorView!
    var indexOpenedCell: Int!
    
    let simpleOver = SimpleOver()
    
    override var title: String? {
        get {
            return super.title
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AppConstants.cityNameKey)
            super.title = newValue
        }
    }
    
    //MARK: ________________________ For use custon icons ________________________
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        setColorScheme()
        setUIFromColorSheme()
        setNavigationBar()
        
        tableView.register(DayCell.getNib(), forCellReuseIdentifier: DayCell.cell)
        loadWeatherFromCoreData()
        loadCityName()
        setNewIcons()
        location()
        
        setColorSchemeFromSun()
        setUIFromColorSheme()
        setNavigationBar()
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.register(DayCell.getNib(), forCellReuseIdentifier: DayCell.cell)
//        
//        loadWeatherFromCoreData()
//        location()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colorScheme.color.listTitleColor]
    }
    
    //MARK: _______________________ ColorScheme Methods _______________________
    
    private func setColorSchemeFromSun() {
        guard let weekForecast = daylyForecast else { return }
        let sunrise = weekForecast.current.sunrise
        let sunset = weekForecast.current.sunset
        switch TimeOfDay.timeOfDayFromSun(sunrise: sunrise, sunset: sunset) {
        case .day:
            colorScheme = ColorSchemes.Day()
        case .night:
            colorScheme = ColorSchemes.Night()
        default:
            colorScheme = ColorSchemes.Day()
        }
    }
    
    private func setColorScheme() {
        switch TimeOfDay.timeOfDay {
        case .day:
            colorScheme = ColorSchemes.Day()
        case .night:
            colorScheme = ColorSchemes.Night()
        default:
            colorScheme = ColorSchemes.Day()
        }
    }
    
    private func setUIFromColorSheme() {
        backgroundImg.image = colorScheme.image.backgroundListImg
        backgroundImg.layer.opacity = colorScheme.opasity.backgroundListImg
        self.view.backgroundColor = colorScheme.color.listViewColor
        self.tableView.separatorColor = .lightGray
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colorScheme.color.listTitleColor]
    }
    
    //MARK: ________________________ Loacate methods ________________________
    
    func location() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are not enabled")
            return
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Not determined")
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            startLocate()
        case .restricted, .denied:
            print("No access")
            requestLocalePermission()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Access")
            startLocate()
        @unknown default:
            break
        }
    }
    
    private func startLocate() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    private func requestLocalePermission() {
        let alert = UIAlertController(title: LocString.Alert.location_access_title, message: LocString.Alert.location_access_message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: LocString.Alert.settings, style: UIAlertAction.Style.default, handler: { action in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { action in
            ErrorAlertService.showErrorAlert(errorMessage: LocString.Alert.location_error, viewController: self)
            self.title = "San Francisco"
            self.getWeatherForecast(params: ["lat":37.785834, "lon":-122.406417])
        })
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func getWeatherForecast(params: [String : Any]) {
        
        weekForecastService.getForecast(params: params) { (result, error) in
            
            if let result = result {
                let group = DispatchGroup()
                group.enter()
                DispatchQueue.main.async {
                    self.daylyForecast = result
                    if self.oldIconsUrlWasPassed == false { self.oldIconsUrlWasPassed = true }
                    self.setNewIcons()
                    self.hideErrorView()
                    self.tableView.reloadData()
                    group.leave()
                }
                //self.isActualDate(dt: self.daylyForecast?.current.dt)
                group.notify(queue: .main) {
                    self.deleteAllCoreDataStores()
                    self.copyWeatherToCoreData()
                }
            }
            else if let error = error {
                print((error as! NetworkServiceError))
                guard self.networkErrorShawed == false else {
                    guard self.weatherFromCoreDataLoaded == false else { return }
                        DispatchQueue.main.async {
                            if self.errorView == nil {
                                if self.title == nil { self.title = LocString.Title.undefined_localion }
                                self.showErrorView()
                            }
                            self.retryGetWeatherForecast(params: params)
                        }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    if (error as! NetworkServiceError) == .noResponse {
                        self.useLocalIconsForNoResponse = true
                    }
                    ErrorAlertService.showErrorAlert(error: error as! NetworkServiceError, viewController: self)
                    self.networkErrorShawed = true
                    self.retryGetWeatherForecast(params: params)
                }
            }
            
        }
        
    }
    
    private func retryGetWeatherForecast(params: [String : Any]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.getWeatherForecast(params: params)
        }
    }
    
    //MARK: ________________________ Error View ________________________
    
    private func showErrorView() {
        DispatchQueue.main.async {
            self.errorView = NetworkErrorView.instanceFromNib()
            self.errorView.initView(message: LocString.Alert.network_ErrorMessage)
            self.view.addSubview(self.errorView)
            self.errorView.fillSuperview()
            UIView.animate(withDuration: 0.3) {
                self.errorView.layoutIfNeeded()
            }
        }
    }
    
    private func hideErrorView() {
        DispatchQueue.main.async {
            if self.errorView != nil {
                self.errorView.removeFromSuperview()
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //MARK: ________________________ Save/Load ( Core Data ) ________________________
    
    private func loadWeatherFromCoreData() {
        var dayForecastArray: [DayForecastMO] = []
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DayForecastMO> = DayForecastMO.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "dt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            dayForecastArray = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        for day in dayForecastArray {
        
            let temp = Temp(day: day.temp.day, night: day.temp.night, eve: day.temp.eve, morn: day.temp.morn)
            let feelsLike = Temp(day: day.feelsLike.day, night: day.feelsLike.night, eve: day.temp.eve, morn: day.temp.morn)
            let weather = Weather(main: day.weather.main, description: day.weather.descript, icon: day.weather.icon)
            
            if daylyForecast == nil && /*day == dayForecastArray.first &&*/ isActualDate(dt: day.dt){
                let currentTemp = TimeOfDay.getCurrentTemp(temp: temp)
                let currentWeather = CurrentWeather(dt: day.dt - 28800, temp: currentTemp, feelsLike: day.feelsLike.day, windSpeed: day.windSpeed, weather: [weather], sunrise: day.sunrise, sunset: day.sunset, pressure: day.pressure, humidity: day.humidity)
                daylyForecast = WeekForecast(daily: [], current: currentWeather)
            }
            
            if isActualDate(dt: day.dt) {
                daylyForecast?.daily.append( DayForecast(dt: day.dt, temp: temp, feelsLike: feelsLike, windSpeed: day.windSpeed, weather: [weather], sunrise: day.sunrise, sunset: day.sunset, pressure: day.pressure, humidity: day.humidity))
            }
            
        }
        if dayForecastArray.isEmpty == false { weatherFromCoreDataLoaded = true }
        tableView.reloadData()
    }
    
    private func copyWeatherToCoreData() {
        guard let week = daylyForecast?.daily else { return }
        for day in week {
            let dayForecastMO = DayForecastMO()
            dayForecastMO.feelsLike = TempMO()
            dayForecastMO.temp = TempMO()
            dayForecastMO.weather = WeatherMO()
            
            dayForecastMO.dt = day.dt
            dayForecastMO.windSpeed = day.windSpeed
            dayForecastMO.feelsLike.day = day.feelsLike.day
            dayForecastMO.feelsLike.night = day.feelsLike.night
            dayForecastMO.temp.day = day.temp.day
            dayForecastMO.temp.night = day.temp.night
            dayForecastMO.temp.eve = day.temp.eve
            dayForecastMO.temp.morn = day.temp.morn
            dayForecastMO.sunrise = day.sunrise
            dayForecastMO.sunset = day.sunset
            dayForecastMO.pressure = day.pressure
            dayForecastMO.humidity = day.humidity
            
            guard let dayWeather = day.weather.first else { return }
            dayForecastMO.weather.main = dayWeather.main
            dayForecastMO.weather.descript = dayWeather.description
            dayForecastMO.weather.icon = dayWeather.icon
            CoreDataManager.shared.saveContext()
        }
    }
    
    func deleteAllCoreDataStores() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = DayForecastMO.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let persistentStoreCoordinator = CoreDataManager.shared.persistentContainer.persistentStoreCoordinator
        
        do {
            try persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func isActualDate(dt: Double?) -> Bool {
        guard let dt = dt else { return false }
        let currentDate = Date()
        let dayDate = Date(timeIntervalSince1970: dt)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd'T'HH:mm:ss"
        
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        let dayDateYYYYMMDD = dateFormatter.string(from: dayDate as Date)
        
        guard let beginOfdayDate = dateFormatter.date(from: dayDateYYYYMMDD) else { return false }
        
        let maxTimeOfDayDate = beginOfdayDate + 86400 - 1
        if maxTimeOfDayDate.compare(currentDate) == .orderedDescending {
            return true
        }

        return false
    }
    
    func loadCityName() {
        guard let cityName = UserDefaults.standard.string(forKey: AppConstants.cityNameKey) else { return }
        self.title = cityName
    }
}

// MARK: ________________________ - Location manager delegate ________________________

extension DayList: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError", error.localizedDescription)
        print("location manager fails to get the current location")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        if !alreadyUpdatedLocation {
            getWeatherForecast(params: ["lat":locValue.latitude, "lon":locValue.longitude])
            alreadyUpdatedLocation = true
        } else {
//            locationManager.stopUpdatingLocation()
//            locationManager.stopMonitoringSignificantLocationChanges()
            return
        }
        
        guard let lastLocation = locations.last else {
            self.title = LocString.Title.undefined_localion
            return
        }
        let geocoder = CLGeocoder()
        
        
        geocoder.reverseGeocodeLocation(lastLocation) { [weak self] (placemarks, error) in
            if error == nil {
                if let firstLocation = placemarks?[0],
                    let cityName = firstLocation.locality { // get the city name
                    self?.title = cityName
                    self?.locationManager.stopUpdatingLocation()
                    self?.locationManager.stopMonitoringSignificantLocationChanges()
                    print(cityName)
                }
                else {
                    self?.title = LocString.Title.undefined_localion
                    print(LocString.Title.undefined_localion)
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    print("didChangeAuthorization")
                }
            }
        }
        
        switch status {
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .denied:
            print("denied")
            requestLocalePermission()
            self.title = "San Francisco"
            self.getWeatherForecast(params: ["lat":37.785834, "lon":-122.406417])
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        default:
            print()
        }
    }
}

// MARK: ________________________ - Table view data source ________________________

extension DayList: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daylyForecast?.daily.count ?? 0
    }
    
    func setColorShemeForCell(cell: /*DayCell*/ ThirdCell) {
        cell.currentTempLabel.textColor = colorScheme.color.cellTitlesColor
        cell.dayNightTempLabel.textColor = colorScheme.color.cellTitlesColor
        cell.feelsTempLabel.textColor = colorScheme.color.cellTitlesColor
        cell.weatherDescriptLabel.textColor = colorScheme.color.cellTitlesColor
        cell.windLabel.textColor = colorScheme.color.cellTitlesColor
        cell.weekDay.textColor = colorScheme.color.cellTitlesColor
        guard let weatherImage = cell.weatherIconImage else { return }
        //weatherImage.tintColor = colorScheme.color.cellTitlesColor
        weatherImage.tintColor = colorScheme.color.cellImageTintColor
        weatherImage.layer.opacity = colorScheme.opasity.cellIcon
        let replaced = cell.windLabel.text?.replacingOccurrences(of: "🚩", with: colorScheme.text.flag)
        cell.windLabel.text = replaced
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DayCell.cell, for: indexPath) as? /*DayCell*/ ThirdCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        if indexPath.row == 0 {
            cell.configureFirstCell(with: daylyForecast)
        }
        else {
            let dayForecast = daylyForecast?.daily[indexPath.row]
            cell.configure(with: dayForecast)
        }
        
        //cell.separatorInset = .zero
        //cell.selectionStyle = .blue
        
        //cell.selectionStyle = .none
        //cell.isUserInteractionEnabled = false
        
        setColorShemeForCell(cell: cell)
        guard let forecast = daylyForecast, let weather = forecast.daily[indexPath.row].weather.first else { return cell }
        //cell.setSystemIcon(strIcon: weather.icon)
        return cell
    }
    
    private func presentWeatherController(with dayForecast: DayForecast?, index: Int) {
        let currentTemp: Double?
        let feelsLikeTemp: Double?
        var image: UIImage?
        var imageName: String = ""
        var timeOfDayFromSun = TimeOfDay.day
        
        print("index: ", index)
        if index == 0 {
            currentTemp = daylyForecast?.current.temp
            feelsLikeTemp = daylyForecast?.current.feelsLike
            if let currentW = daylyForecast?.current, let weather = currentW.weather.first {
                image = imageArray[weather.icon/*weather.description*/]
//                self.delegate?.newIconsArray[weather.first!.icon]
                imageName = weather.icon
                timeOfDayFromSun = TimeOfDay.timeOfDayFromSun(sunrise: currentW.sunrise, sunset: currentW.sunset)
            }
        }
        else {
            currentTemp = dayForecast?.temp.day
            feelsLikeTemp = dayForecast?.feelsLike.day
            if let weather = dayForecast?.weather.first {
                image = imageArray[weather.icon/*weather.description*/]
                imageName = weather.icon
            }
        }
        
//        if let weather = daylyForecast?.daily[index].weather.first {
//            imageName = weather.icon
//        }
        
        let vc = WeatherViewController()
        vc.dayForecast = dayForecast
        vc.currentTemp = currentTemp
        vc.feelsLikeTemp = feelsLikeTemp
        vc.imageKey = imageName
        if index == 0 && timeOfDayFromSun == .night {
            vc.colorScheme = ColorSchemes.Night()
        } else {
            vc.colorScheme = ColorSchemes.Day()
        }
        //vc.colorScheme = colorScheme
        vc.delegate = self
        
        if useNewIcons, let weather = dayForecast?.weather.first  {
            let key = weather.icon
            vc.icon = newIconsArray[key]
        }
        else /*if let weather = dayForecast?.weather.first, let image = imageArray[weather.icon/*weather.description*/]*/  {
            vc.icon = image
        }
        
        vc.useLocalIcons = useLocalIconsForNoResponse
        
        if index == 0 {
            vc.blockNavigation = .back
        } else if index == tableView.numberOfRows(inSection: 0) - 1 {
            vc.blockNavigation = .forward
        }
            
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        backItem.tintColor = vc.colorScheme.color.backItem
        navigationItem.backBarButtonItem = backItem
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: vc.colorScheme.color.extendInfoTitleColor]
        //self.navigationController?.navigationBar.tintColor = .red -- backBarButton
        indexOpenedCell = index
        vc.nextNavigation = self
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}

class SimpleOver: NSObject, UIViewControllerAnimatedTransitioning {
    var forward: Bool = true
    var popStyle: Bool = false
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.20
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if popStyle {
            animatePop(using: transitionContext)
            forward = true
            return
        }
        
        if forward {
            rightToLeftAnimation(using: transitionContext)
            return
        } else {
            leftToRightAnimation2(using: transitionContext)
            return
        }
        
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let f = transitionContext.finalFrame(for: tz)
        
        let fOff = f.offsetBy(dx: f.width, dy: 0) //55
        tz.view.frame = fOff
        
        transitionContext.containerView.insertSubview(tz.view, aboveSubview: fz.view)
        
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                tz.view.frame = f
            }, completion: {_ in
                transitionContext.completeTransition(true)
            })
    }
    
    func animatePop(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let f = transitionContext.initialFrame(for: fz)
        let fOffPop = f.offsetBy(dx: f.width, dy: 0) // 55
        
        transitionContext.containerView.insertSubview(tz.view, belowSubview: fz.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fz.view.frame = fOffPop
            }, completion: {_ in
                transitionContext.completeTransition(true)
            })
    }
    
    func leftToRightAnimation2(using transitionContext: UIViewControllerContextTransitioning) {
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let f = transitionContext.finalFrame(for: tz) //tz
        
        let fOff = f.offsetBy(dx: -f.width, dy: 0) //55
        tz.view.frame = fOff
        
        transitionContext.containerView.insertSubview(tz.view, aboveSubview: fz.view)
        
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                tz.view.frame = f
            }, completion: {_ in
                transitionContext.completeTransition(true)
            })
    }
    
    
    func leftToRightAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let f = transitionContext.initialFrame(for: fz)
        let fOffPop = f.offsetBy(dx: f.width, dy: 0) // 55
        
        transitionContext.containerView.insertSubview(tz.view, belowSubview: fz.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fz.view.frame = fOffPop
            }, completion: {_ in
                transitionContext.completeTransition(true)
            })
    }
    
    func rightToLeftAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        if popStyle {
            
            animatePop(using: transitionContext)
            return
        }
        
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        //let from = forward ? tz : fz
        
        let f = transitionContext.finalFrame(for: tz) //tz
        
        let fOff = f.offsetBy(dx: f.width, dy: 0) //55
        tz.view.frame = fOff
        
        transitionContext.containerView.insertSubview(tz.view, aboveSubview: fz.view)
        
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                tz.view.frame = f
            }, completion: {_ in
                transitionContext.completeTransition(true)
            })
    }
}

extension DayList : UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        simpleOver.popStyle = (operation == .pop)
        return simpleOver
    }
}


protocol NextNavigation {
    func navigation(inDirection: Navigation)
}

enum Navigation {
    case back, forward
}

extension DayList: NextNavigation {
    
    func navigation(inDirection: Navigation) {
        guard let index = getIndexForNavigation(navigation: inDirection) else { return }
        setAnimationDirection(inDirection: inDirection)
        presentWeatherController(with: daylyForecast?.daily[index], index: index)
    }
    
    func setAnimationDirection(inDirection: Navigation) {
        simpleOver.forward = (inDirection == .forward)
    }
    
    func getIndexForNavigation(navigation: Navigation) -> Int? {
        switch navigation {
        case .back:
            if indexOpenedCell > 0 {
                return indexOpenedCell - 1
            } else {
                return nil
            }
        case .forward:
            if indexOpenedCell < tableView.numberOfRows(inSection: 0) - 1 {
                return indexOpenedCell + 1
            } else { return nil }
        }
        return 0
    }
}

// MARK: ________________________ - Table view delegate ________________________

extension DayList: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 160
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath.row: ", indexPath.row)
        presentWeatherController(with: daylyForecast?.daily[indexPath.row], index: indexPath.row)
    }
    
}

//TODO: Add saving images
// if let restaurantImage = photoImageView.image {
//        if let imageData = UIImagePNGRepresentation(restaurantImage) {
//            restaurant.image = NSData(data: imageData)
//        }
//}

//restaurantImageView.image = UIImage(data: restaurant.image as! Data)

//MARK: ________________________ For NewIcons downloading ________________________

extension DayList {
    private func setNewIcons() {
        guard useNewIcons else { return }
        downloadJSON(url: "https://hmaraegor.ml/Swift/WeekWeather/")
    }
    
    private func downloadJSON(url: String) {
        DownloadService().getForecast(url: url + "icons.json", params: nil) { (result: Icons?, error) in
            
            if let result = result {
                var json: Icons = result
                //json.useNewIcons = false
                if json.useNewIcons {
                    self.useNewIcons = json.useNewIcons
                    self.showSunPhases = json.showSunPhases
                    self.showPreasureHumidity = json.showPreasureHumidity
                    self.downloadIcons(url: url, icons: json)
                }
            }
            else if let error = error {
                DispatchQueue.main.async {
                    if (error as! NetworkServiceError) == .noResponse {
                        self.useLocalIconsForNoResponse = true
                    }
                    ErrorAlertService.showErrorAlert(error: error as! NetworkServiceError, viewController: self)
                }
            }
        }
    }
    
    private func downloadIcons(url: String, icons: Icons) {
        let url = url + icons.folder
        
        
        let iconsList = makeIconsList()
        
        for (key, value) in icons.dayIcons {
            guard iconsList.contains(key) else { continue }
            ImageDownloader.downloadImage(stringURL: url + "/" + value + ".png") { (imageData) in
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    self.newIconsArray[key] = image
                    self.imageArray = self.newIconsArray
                    //print("for \(key) image downloaded")
                    self.tableView.reloadData()
                }
            }
        }
        
        for (key, value) in icons.nightIcons {
            guard iconsList.contains(key) else { continue }
            ImageDownloader.downloadImage(stringURL: url + "/" + value + ".png") { (imageData) in
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    self.newIconsArray[key] = image
                    self.imageArray = self.newIconsArray
                    //print("for \(key) image downloaded")
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func makeIconsList() -> [String] {
        var iconsNames = [String]()
        guard let currentIcon = daylyForecast?.current.weather.first?.icon else { return [] }
        iconsNames.append(currentIcon)
        guard let days = daylyForecast?.daily else { return [] }
         
        for day in days {
            if let icon = day.weather.first?.icon {
                iconsNames.append(icon)
            }
        }
        
        return iconsNames
    }
}

//MARK: ________________________ Debug methods ________________________

extension DayList {
    func printLocale() {
        print(Locale.current.languageCode!)
        print(Locale.preferredLanguages[0])
        //print(Locale.preferredLanguages[0] as String)
        print(Locale.current.identifier)
        print(Locale.autoupdatingCurrent.languageCode)
        
        print(String(Locale.preferredLanguages[0].prefix(2)))
        print(Locale.preferredLanguages.first!)
        print(Bundle.main.preferredLocalizations.first!)
        print(Bundle.main.preferredLocalizations.first?.prefix(2))
        
        print(String(Locale.preferredLanguages[0].prefix(5)))
        print(Locale.preferredLanguages)
    }
    
    //MARK: For use mock object
    
    /*
     override func viewDidLoad() {
     super.viewDidLoad()
     let nib = UINib(nibName: cellXib, bundle: nil)
     tableView.register(nib, forCellReuseIdentifier: cell)
     //setNewIcons()
     createMockDaylyForecast()
     //location()
     }
     */
    
    func createMockDaylyForecast() {
        
        let newDayIcons = ["0":"cloudSnowflake", "1":"rainClounsSun", "2":"happyCloud", "3":"cloudsBroken", "4":"clouds", "5":"stars", "6":"star", "7":"moon", "8":"sun", "9":"heatCloud", "10":"happyRainCloud", "11":"sadRainCloud", "12":"lightningCloud", "13":"rainCloud", "14":"rainbow", "15":"sunClouds", "16":"umbrella", "17":"drops", "18":"sadDrop", "19":"happyDrop"]
        var newNightIcons = newDayIcons
        var newIcons = Icons(useNewIcons: true, folder: "newIcons", dayIcons: newDayIcons, nightIcons: newNightIcons)
        
        var weather = Weather(main: "yo", description: "norm norm norm nor", icon: "\(newDayIcons.count - 1)")
        var temp = Temp(day: 22, night: 17, eve: 18, morn: 15)
        var current = CurrentWeather(dt: 1598284319, temp: 22, feelsLike: 22, windSpeed: 1.2, weather: [weather], sunrise: 1598280000, sunset: 1598288319, pressure: 1015, humidity: 77)
        var dayForecast = DayForecast(dt: 1598284319, temp: temp, feelsLike: temp, windSpeed: 1.2, weather: [weather], sunrise: 1598281230, sunset: 1598283219, pressure: 1013, humidity: 60)
        var dayly = Array(repeating: dayForecast, count: newDayIcons.count)
        
        for x in 0...dayly.count - 1 {
            dayly[x].weather[0].icon = "\(x)"
        }
        
        daylyForecast = WeekForecast(daily: dayly, current: current)
        
        downloadIcons(url: "https://hmaraegor.ml/Swift/WeekWeather/", icons: newIcons)
    }
}
