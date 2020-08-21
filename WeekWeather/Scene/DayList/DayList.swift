//
//  ViewController.swift
//  WeekWeather
//
//  Created by Egor on 18/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import CoreLocation

class DayList: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var weekForecastService = WeekForecastService()
    var daylyForecast = [DayForecast]()
    let locationManager = CLLocationManager()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "DayCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are not enabled")
            return
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            print("No access")
            requestLocalePermission()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Access")
        @unknown default:
            break
        }
        
        
        
    }
    
    func requestLocalePermission() {
        let alert = UIAlertController(title: "Allow Location Access", message: "WeekWeather needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
        
        // Button to Open Settings
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
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
            self.title = "San Francisco"
            self.getWeatherForecast(params: ["lat":37.785834, "lon":-122.406417])
        })
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getWeatherForecast(params: [String : Any]) {
        
        weekForecastService.getForecast(params: params) { (result, error) in
            
            if result != nil {
                DispatchQueue.main.async {
                    self.daylyForecast = result!.daily
                    self.tableView.reloadData()
                }
            }
            else if error != nil {
                DispatchQueue.main.async {
                    ErrorAlertService.showErrorAlert(error: error as! NetworkServiceError, viewController: self)
                }
            }
            
        }
        
    }
}

// MARK: - Location manager delegate

extension DayList: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        getWeatherForecast(params: ["lat":locValue.latitude, "lon":locValue.longitude])
        
        if let lastLocation = locations.last {
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
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    print("didChangeAuthorization")
                }
            }
        }
    }
}

// MARK: - Table view data source

extension DayList: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daylyForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DayCell else {
            return UITableViewCell()
        }
        
        let dayForecast = daylyForecast[indexPath.row]
        cell.configure(with: dayForecast)
        
        return cell
    }
    
}

// MARK: - Table view delegate

extension DayList: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
}
