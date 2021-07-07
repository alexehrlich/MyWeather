//
//  ViewController.swift
//  MyWeather
//
//  Created by Alexander Ehrlich on 04.07.21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()

    //MARK: IBOutlets
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Textfield Delegation
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        //LocationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.text = "Paris"
    }
    
    
    
    //MARK: IBActions
    @IBAction func determineLocationPressed(_ sender: UIButton) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.locationManager.requestLocation()
            DispatchQueue.main.async {
                self.weatherIcon.alpha = 0
                self.cityLabel.alpha = 0
                self.temperatureLabel.alpha = 0
                self.spinner.startAnimating()
            }
        }
        
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
    
        if let city = searchTextField.text, searchTextField.text != "" {
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.weatherManager.fetchWeather(for: city)
                DispatchQueue.main.async {
                    self.weatherIcon.alpha = 0
                    self.cityLabel.alpha = 0
                    self.temperatureLabel.alpha = 0
                    self.spinner.startAnimating()
                }
            }
            
        }
    }
    
    //MARK: Helper-Functions
    private func makeAttributedTemperaturLabel(of number: String) -> NSMutableAttributedString{
        
        let combined = NSMutableAttributedString(string: number + "°C")
        combined.addAttributes([.font : UIFont(name: "Helvetica Neue Bold", size: 50)!], range: NSRange(location: 0, length: number.count))
        combined.addAttributes([.font : UIFont(name: "Helvetica Neue", size: 50)!], range: NSRange(location: number.count, length: 2))

        return combined
    }
    

}

extension WeatherViewController: UITextFieldDelegate{
    
}

extension WeatherViewController: WeatherManagerDelegate{
    func didReceiveWeather(_ weather: WeatherModel) {
            
        DispatchQueue.main.async {
            
            self.weatherIcon.image = UIImage(systemName: weather.conditionImageName)
            self.temperatureLabel.attributedText = self.makeAttributedTemperaturLabel(of: weather.tempString)
            self.cityLabel.text = weather.city
            self.searchTextField.text = ""
            self.weatherIcon.alpha = 1
            self.cityLabel.alpha = 1
            self.temperatureLabel.alpha = 1
            self.spinner.stopAnimating()
        }
    }
    
    func didFailWithError(error: Error) {
        print("OOPS something went wrong")
    }
}

extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let longitude = locations[0].coordinate.longitude
        let latidude = locations[0].coordinate.latitude
        weatherManager.fetchWeather(for: (longitude, latidude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}



