//
//  ViewController.swift
//  WeekWeather
//
//  Created by Egor on 18/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import CoreLocation

struct Icons: Codable {
    var useNewIcons: Bool
    var folder: String
    var dayIcons: [String : String]
    var nightIcons: [String : String]
}

extension DayList {
    private func setNewIcons() {
        downloadJSON(url: "https://hmaraegor.ml/Swift/WeekWeather/")
    }
    
    private func downloadJSON(url: String) {
        DownloadService().getForecast(url: url + "icons.json", params: nil) { (result: Icons?, error) in
            
            if let result = result {
                var json: Icons = result
                json.useNewIcons = false
                if json.useNewIcons {
                    self.useNewIcons = json.useNewIcons
                    self.downloadIcons(url: url, icons: json)
                }
            }
            else if let error = error {
                DispatchQueue.main.async {
                    ErrorAlertService.showErrorAlert(error: error as! NetworkServiceError, viewController: self)
                }
            }
        }
    }
    
    private func downloadIcons(url: String, icons: Icons) {
        let url = url + icons.folder
        
        for (key, value) in icons.dayIcons {
            ImageDownloader.downloadImage(stringURL: url + "/" + value + ".png") { (imageData) in
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    self.newIconsArray[key] = image
                    self.tableView.reloadData()
                }
            }
        }
    }
    
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
    
    func createMockDaylyForecast() {
        
        let newDayIcons = ["0":"cloudSnowflake", "1":"rainClounsSun", "2":"happyCloud", "3":"cloudsBroken", "4":"clouds", "5":"stars", "6":"star", "7":"moon", "8":"sun", "9":"heatCloud", "10":"happyRainCloud", "11":"sadRainCloud", "12":"lightningCloud", "13":"rainCloud", "14":"rainbow", "15":"sunClouds", "16":"umbrella", "17":"drops", "18":"sadDrop", "19":"happyDrop"]
        var newNightIcons = newDayIcons
        var newIcons = Icons(useNewIcons: true, folder: "newIcons", dayIcons: newDayIcons, nightIcons: newNightIcons)

        var weather = Weather(main: "yo", description: "norm norm norm nor", icon: "\(newDayIcons.count - 1)")
        var temp = Temp(day: 22, night: 17)
        var current = CurrentWeather(dt: 1598284319, temp: 22, feelsLike: 21, weather: [weather], windSpeed: 1.2)
        var dayForecast = DayForecast(dt: 1598284319, temp: temp, feelsLike: temp, windSpeed: 1.1, weather: [weather])
        var dayly = Array(repeating: dayForecast, count: newDayIcons.count)
        
        for x in 0...dayly.count - 1 {
            dayly[x].weather[0].icon = "\(x)"
        }
        
        daylyForecast = WeekForecast(daily: dayly, current: current)
        
        downloadIcons(url: "https://hmaraegor.ml/Swift/WeekWeather/", icons: newIcons)
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
    
    //MARK: For use custon icons
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: cellXib, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cell)
        setNewIcons()
        location()
    }
    */
    
    
}

class DayList: UIViewController, DayCellDelegate {
    
    let cellXib = AppConstants.Storyboard.newCellXib
    let cell = AppConstants.Storyboard.Cell.newCell
    
    var imageArray = [String : UIImage]()
    var newIconsArray = [String : UIImage]()
    var useNewIcons = false
    
    @IBOutlet var tableView: UITableView!
    private var weekForecastService = WeekForecastService()
    private var daylyForecast: WeekForecast?
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: cellXib, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cell)
        location()
    }
    
    private func location() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are not enabled")
            return
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Not determined")
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            self.startLocate()
        case .restricted, .denied:
            print("No access")
            self.requestLocalePermission()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Access")
            self.startLocate()
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
        let alert = UIAlertController(title: LocString.Alert.locationAccessTitle, message: LocString.Alert.locationAccessMessage, preferredStyle: UIAlertController.Style.alert)
        
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
            ErrorAlertService.showErrorAlert(errorMessage: LocString.Alert.locationError, viewController: self)
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
                DispatchQueue.main.async {
                    self.daylyForecast = result
                    self.tableView.reloadData()
                }
            }
            else if let error = error {
                DispatchQueue.main.async {
                    ErrorAlertService.showErrorAlert(error: error as! NetworkServiceError, viewController: self)
                }
            }
            
        }
        
    }
}

// MARK: - Location manager delegate

extension DayList: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError", error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        getWeatherForecast(params: ["lat":locValue.latitude, "lon":locValue.longitude])
        
        guard let lastLocation = locations.last else {
            self.title = LocString.Title.undefinedLocalion
            return
        }
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(lastLocation) { [weak self] (placemarks, error) in
            if error == nil {
                if let firstLocation = placemarks?[0],
                    let cityName = firstLocation.locality { // get the city name
                    //self?.locationManager.stopUpdatingLocation()
                    self?.title = cityName
                    print(cityName)
                }
                else {
                    self?.title = LocString.Title.undefinedLocalion
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

// MARK: - Table view data source

extension DayList: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daylyForecast?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath) as? DayCell else {
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
        
        cell.isUserInteractionEnabled = false
        return cell
    }
    
}

// MARK: - Table view delegate

extension DayList: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
