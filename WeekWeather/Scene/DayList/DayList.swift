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

class DayList: UIViewController, DayCellDelegate {
    
    var imageArray = [String : UIImage]()
    var newIconsArray = [String : UIImage]()
    var useNewIcons = false
    
    @IBOutlet var tableView: UITableView!
    private var weekForecastService = WeekForecastService()
    private var daylyForecast: WeekForecast?
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(DayCell.getNib(), forCellReuseIdentifier: DayCell.cell)
        
        loadWeatherFromCoreData()
        location()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    private func location() {
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
                DispatchQueue.main.async {
                    ErrorAlertService.showErrorAlert(error: error as! NetworkServiceError, viewController: self)
                }
            }
            
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
    
    //MARK: For Core Data debugging
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
            
            if daylyForecast == nil && day == dayForecastArray.first && isActualDate(dt: day.dt){
                let currentWeather = CurrentWeather(dt: day.dt - 28800, temp: day.temp.day, feelsLike: day.feelsLike.day, windSpeed: day.windSpeed, weather: [weather], sunrise: day.sunrise, sunset: day.sunset, pressure: day.pressure, humidity: day.humidity)
                daylyForecast = WeekForecast(daily: [], current: currentWeather)
            }
            
            if isActualDate(dt: day.dt) {
                daylyForecast?.daily.append( DayForecast(dt: day.dt, temp: temp, feelsLike: feelsLike, windSpeed: day.windSpeed, weather: [weather], sunrise: day.sunrise, sunset: day.sunset, pressure: day.pressure, humidity: day.humidity))
            }
            
        }
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
}

// MARK: - Location manager delegate

extension DayList: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError", error.localizedDescription)
        print("location manager fails to get the current location")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        getWeatherForecast(params: ["lat":locValue.latitude, "lon":locValue.longitude])
        
        guard let lastLocation = locations.last else {
            self.title = LocString.Title.undefined_localion
            return
        }
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(lastLocation) { [weak self] (placemarks, error) in
            if error == nil {
                if let firstLocation = placemarks?[0],
                    let cityName = firstLocation.locality { // get the city name
                    self?.locationManager.stopUpdatingLocation()
                    self?.title = cityName
                    print(cityName)
                }
                else {
                    self?.title = LocString.Title.undefined_localion
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DayCell.cell, for: indexPath) as? DayCell else {
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
        
        //cell.selectionStyle = .none
        //cell.isUserInteractionEnabled = false
        return cell
    }
    
    private func presentWeatherController(with dayForecast: DayForecast?, index: Int) {
        let currentTemp: Double?
        if index == 0 { currentTemp = daylyForecast?.current.temp }
        else { currentTemp = dayForecast?.temp.day }
        let vc = WeatherViewController()
        vc.dayForecast = dayForecast
        vc.currentTemp = currentTemp
        if let weather = dayForecast?.weather.first,
            let image = imageArray[weather.description]  {
            vc.icon = image
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Table view delegate

extension DayList: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
