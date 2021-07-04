//
//  WeatherData.swift
//  MyWeather
//
//  Created by Alexander Ehrlich on 04.07.21.
//

import Foundation

struct WeatherData: Decodable{
    
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
}
