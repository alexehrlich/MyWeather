//
//  WeatherManager.swift
//  MyWeather
//
//  Created by Alexander Ehrlich on 04.07.21.
//

import Foundation

protocol WeatherManagerDelegate {
    func didReceiveWeather()
}

struct WeatherManager {
    
    let apikey = "928469f16d799b63d91e78e2c5c64820"
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=928469f16d799b63d91e78e2c5c64820&units=metric&q="
    
    var delegate: WeatherManagerDelegate!
    
    func fetchWeather(for city: String){
        
        let finalURL = "\(baseURL)" + city
        performRequest(for: finalURL)
    }
    
    private func performRequest(for urlString: String){
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil { return }
                
                if let safeData = data{
                    parseJSON(for: safeData)
                    delegate.didReceiveWeather()
                }
            }
            task.resume()
            
        }
    }
    
    private func parseJSON(for data: Data){
        
        let decoder = JSONDecoder()
        
        do{
           let decodedData = try decoder.decode(WeatherData.self, from: data)
        }catch{
            print(error)
        }
    }
}
