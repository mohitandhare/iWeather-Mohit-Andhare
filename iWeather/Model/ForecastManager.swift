//
//  ForecastManager.swift
//  iWeather
//
//  Created by Mohit Andhare on 13/07/21.
//

import Foundation
import CoreLocation

protocol ForecastManagerDelegate {
    func didUpdateWeather(_ weatherManager: ForecastManager, weather: [WeatherModel])
    func didFailWithError(error: Error)
}

struct ForecastManager {
    let forecastURL = "https://api.openweathermap.org/data/2.5/forecast?appid=8012d843418fb5686ce3c9e974408edb&units=metric"
    
    var delegate: ForecastManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(forecastURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(forecastURL)&lat=\(latitude)&lon=\(longitude)"
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
    
    func parseJSON(_ weatherData: Data) -> [WeatherModel]? {
        let decoder = JSONDecoder()
        do {
                let decodedForecastData = try decoder.decode(WeatherForecastData.self, from: weatherData)
            
                let name = decodedForecastData.city.name
            
                let forecastID1 = decodedForecastData.list[0].weather[0].id
                let forecastTemp1 = decodedForecastData.list[0].main.temp
                let forecastTime1 = decodedForecastData.list[0].dt
                
                let forecastID2 = decodedForecastData.list[1].weather[0].id
                let forecastTemp2 = decodedForecastData.list[1].main.temp
                let forecastTime2 = decodedForecastData.list[1].dt
            
                let forecastID3 = decodedForecastData.list[2].weather[0].id
                let forecastTemp3 = decodedForecastData.list[2].main.temp
                let forecastTime3 = decodedForecastData.list[2].dt
            
                let forecastID4 = decodedForecastData.list[3].weather[0].id
                let forecastTemp4 = decodedForecastData.list[3].main.temp
                let forecastTime4 = decodedForecastData.list[3].dt
            
                let forecast1 = WeatherModel(conditionId: forecastID1, cityName: name, temperature: forecastTemp1, time: forecastTime1)
                let forecast2 = WeatherModel(conditionId: forecastID2, cityName: name, temperature: forecastTemp2, time: forecastTime2)
                let forecast3 = WeatherModel(conditionId: forecastID3, cityName: name, temperature: forecastTemp3, time: forecastTime3)
                let forecast4 = WeatherModel(conditionId: forecastID4, cityName: name, temperature: forecastTemp4, time: forecastTime4)
                

                let forecasts = [forecast1, forecast2, forecast3, forecast4]
                return forecasts
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}



