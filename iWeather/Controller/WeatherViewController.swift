//
//  WeatherViewController.swift
//  iWeather
//
//  Created by Mohit Andhare on 13/07/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    @IBOutlet weak var forecastImage1: UIImageView!
    @IBOutlet weak var forecastImage2: UIImageView!
    @IBOutlet weak var forecastImage3: UIImageView!
    @IBOutlet weak var forecastImage4: UIImageView!
    
    @IBOutlet weak var forecastTemp1: UILabel!
    @IBOutlet weak var forecastTemp2: UILabel!
    @IBOutlet weak var forecastTemp3: UILabel!
    @IBOutlet weak var forecastTemp4: UILabel!
    
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var time2: UILabel!
    @IBOutlet weak var time3: UILabel!
    @IBOutlet weak var time4: UILabel!
    
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var sunriseTime: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    
    
    
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var forecastManager = ForecastManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        forecastManager.delegate = self
        
    }

}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
            forecastManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
        
    }
}

//MARK: - WeatherManagerDelegate


extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.feelsLikeLabel.text = ("\(String(format: "%.0f", weather.feels_like))°C")
            self.humidityLabel.text = "\(String(weather.humdidity))%"
            self.sunriseTime.text = weather.sunriseString
            self.sunsetLabel.text = weather.sunsetString
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - ForecastManagerDelegate

extension WeatherViewController: ForecastManagerDelegate {
    func didUpdateWeather(_ weatherManager: ForecastManager, weather: [WeatherModel]) {
        DispatchQueue.main.async {
            self.forecastTemp1.text = "\(weather[0].temperatureString)°C"
            self.forecastImage1.image = UIImage(systemName: weather[0].conditionName)
            self.time1.text = weather[0].timeString
            
            self.forecastTemp2.text = "\(weather[1].temperatureString)°C"
            self.forecastImage2.image = UIImage(systemName: weather[1].conditionName)
            self.time2.text = weather[1].timeString
            
            self.forecastTemp3.text = "\(weather[2].temperatureString)°C"
            self.forecastImage3.image = UIImage(systemName: weather[2].conditionName)
            self.time3.text = weather[2].timeString
            
            self.forecastTemp4.text = "\(weather[3].temperatureString)°C"
            self.forecastImage4.image = UIImage(systemName: weather[3].conditionName)
            self.time4.text = weather[3].timeString
        }
    }
    
}

//MARK: - CLLocationManagerDelegate


extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            forecastManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
