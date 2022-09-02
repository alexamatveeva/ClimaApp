//
//  WeatherData.swift
//  ClimaApp
//
//  Created by Alexandra on 02.09.2022.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}
