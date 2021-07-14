//
//  WeatherForecastData.swift
//  iWeather
//
//  Created by Mohit Andhare on 13/07/21.
//

import Foundation

struct WeatherForecastData: Codable {
    let list: [List]
    let city: City
}

struct City: Codable {
    let name: String
}

struct List: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
}
