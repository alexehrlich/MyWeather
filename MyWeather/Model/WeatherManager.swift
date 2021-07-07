//
//  WeatherManager.swift
//  MyWeather
//
//  Created by Alexander Ehrlich on 04.07.21.
//

import Foundation

protocol WeatherManagerDelegate {
    func didReceiveWeather(_ weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let apikey = "928469f16d799b63d91e78e2c5c64820"
    let baseCityURL = "https://api.openweathermap.org/data/2.5/weather?appid=928469f16d799b63d91e78e2c5c64820&units=metric&q="
    let locationURL = "https://api.openweathermap.org/data/2.5/weather?appid=928469f16d799b63d91e78e2c5c64820&units=metric&"
    
    var delegate: WeatherManagerDelegate!
    
    func fetchWeather(for city: String){
        
        let finalURL = "\(baseCityURL)" + city
        performRequest(for: finalURL)
    }
    
    func fetchWeather(for location: (lon: Double, lat: Double)){
        let finalURL = "\(locationURL)" + "lon=\(location.lon)&lat=\(location.lat)"
        performRequest(for: finalURL)
    }
    
    private func performRequest(for urlString: String){
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil { return }
                
                if let safeData = data{
                    if let weather = parseJSON(for: safeData){
                        delegate.didReceiveWeather(weather)
                    }
                }
            }
            task.resume()
            
        }
    }
    
    private func parseJSON(for data: Data) -> WeatherModel?{
        
        let decoder = JSONDecoder()
        
        do{
           let decodedData = try decoder.decode(WeatherData.self, from: data)
            return WeatherModel(conditionID: decodedData.weather[0].id, city: decodedData.name, temp: decodedData.main.temp)
        }catch{
            delegate.didFailWithError(error: error)
            return nil
        }
    }
}
