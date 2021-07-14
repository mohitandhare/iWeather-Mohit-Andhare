//
//  WeatherManager.swift
//  iWeather
//
//  Created by Mohit Andhare on 13/07/21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=8012d843418fb5686ce3c9e974408edb&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
              let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                      let id = decodedData.weather[0].id
                      let temp = decodedData.main.temp
                      let name = decodedData.name
                      let sunrise = decodedData.sys.sunrise
                      let sunset = decodedData.sys.sunset
                      let feels_like = decodedData.main.feels_like
                      let humidity = decodedData.main.humidity
                      
                      let currentTime = Int(Date().timeIntervalSince1970)
            
            var weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, time: currentTime)
            weather.sunrise = sunrise
            weather.sunset = sunset
            weather.feels_like = feels_like
            weather.humdidity = humidity
                      return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
