//
//  WeatherData.swift
//  iWeather
//
//  Created by Mohit Andhare on 13/07/21.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let sys: Sys
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let humidity: Int
}

struct Weather: Codable {
    let description: String
    let id: Int
}

struct Sys: Codable {
    let sunrise: Int
    let sunset: Int
}

