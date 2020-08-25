//
//  ViewController.swift
//  WeekWeather
//
//  Created by Egor on 18/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import CoreLocation

class DayList: UIViewController, DayCellDelegate {
    
    var imageArray = [String : UIImage]()
    
    @IBOutlet var tableView: UITableView!
    private var weekForecastService = WeekForecastService()
    private var daylyForecast: WeekForecast?
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "DayCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
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
            self.title = "Undefine Place"
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DayCell else {
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
