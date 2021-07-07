//
//  WeatherModel.swift
//  MyWeather
//
//  Created by Alexander Ehrlich on 05.07.21.
//

import Foundation

struct WeatherModel{
    
    let conditionID: Int
    let city: String
    let temp: Double
    
    var tempString: String {
        return String(format: "%.1f", temp)
    }
    
    var conditionImageName: String {
        
        switch conditionID{
        
        case 200...231: return "tropicalstrom"
        case 300...321: return "cloud.drizzle"
        case 500...531: return "cloud.heavyrain"
        case 600...621: return "cloud.snow"
        case 701...781: return "sund.dust.fill"
        case 800: return "sun.max"
        case 801...804: return "cloud"
        default: return "clear"
        }
    }
}
