//
//  ViewController.swift
//  MyWeather
//
//  Created by Alexander Ehrlich on 04.07.21.
//

import UIKit

class WeatherViewController: UIViewController {
    
    var weatherManager = WeatherManager()

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
    }
    
    
    
    //MARK: IBActions
    @IBAction func determineLocationPressed(_ sender: UIButton) {
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        if let city = searchTextField.text {
            
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
//    private func makeAttributedTemperaturLabel(of string: String) -> NSAttributedString{
//        
//        
//        
//    }
    

}

extension WeatherViewController: UITextFieldDelegate{
    
}

extension WeatherViewController: WeatherManagerDelegate{
    func didReceiveWeather() {
        
        DispatchQueue.main.async {
            self.weatherIcon.alpha = 1
            self.cityLabel.alpha = 1
            self.temperatureLabel.alpha = 1
            self.spinner.stopAnimating()
        }
    }
}



