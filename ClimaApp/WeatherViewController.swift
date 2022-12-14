//
//  ViewController.swift
//  ClimaApp
//
//  Created by Alexandra on 31.08.2022.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    let backgroungView = UIImageView()
    
    let rootStackView = UIStackView()
    
    //search
    let searchStackView = UIStackView()
    var locationButton = UIButton()
    var searchButton = UIButton()
    var searchTextField = UITextField()
    
    //weather
    var conditionImageView = UIImageView()
    var temperatureLabel = UILabel()
    var cityLabel = UILabel()
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
    }
}

extension WeatherViewController {
    private func setup() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
    private func style() {
        backgroungView.translatesAutoresizingMaskIntoConstraints = false
        backgroungView.image = UIImage(named: "background")
        backgroungView.contentMode = .scaleAspectFill
        
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        rootStackView.axis = .vertical
        rootStackView.spacing = 10
        rootStackView.alignment = .trailing
        
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        searchStackView.axis = .horizontal
        searchStackView.spacing = 8
        
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.setBackgroundImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        locationButton.tintColor = appColor
        locationButton.addTarget(self, action: #selector(locationButtonPressed), for: .primaryActionTriggered)
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = appColor
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .primaryActionTriggered)
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.font = UIFont.preferredFont(forTextStyle: .title1)
        searchTextField.placeholder = "Search city"
        searchTextField.textAlignment = .right
        searchTextField.borderStyle = .roundedRect
        searchTextField.backgroundColor = .systemFill
        searchTextField.autocapitalizationType = .words
        searchTextField.returnKeyType = .go
        
        conditionImageView.translatesAutoresizingMaskIntoConstraints = false
        conditionImageView.image = UIImage(systemName: "sun.max")
        conditionImageView.tintColor = appColor
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.systemFont(ofSize: 80)
        temperatureLabel.textAlignment = .right
        temperatureLabel.textColor = appColor
        temperatureLabel.text = "20"
        
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        cityLabel.textAlignment = .right
        cityLabel.textColor = appColor
        cityLabel.text = "Some city"
        
    }
    
    private func layout() {
        view.addSubview(backgroungView)
        
        view.addSubview(rootStackView)
        
        rootStackView.addArrangedSubview(searchStackView)
        searchStackView.addArrangedSubview(locationButton)
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(searchButton)
        
        rootStackView.addArrangedSubview(conditionImageView)
        rootStackView.addArrangedSubview(temperatureLabel)
        rootStackView.addArrangedSubview(cityLabel)
        
        NSLayoutConstraint.activate([
            backgroungView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroungView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroungView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroungView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            rootStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.trailingAnchor, multiplier: 1),
            
            searchStackView.widthAnchor.constraint(equalTo: rootStackView.widthAnchor),
            
            
            locationButton.widthAnchor.constraint(equalToConstant: 40),
            locationButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            
            conditionImageView.widthAnchor.constraint(equalToConstant: 120),
            conditionImageView.heightAnchor.constraint(equalToConstant: 120),
            
        ])
        
    }
    
    @objc func searchButtonPressed() {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    @objc func locationButtonPressed() {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!) //???????????????????? ?????? ?????? ???????????? ?? ?????????? ??????????, ???? ?????????????? ???????????? ???? ????????????????????
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Type someting here"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = "" //???????????????? ?????????? ?? ????????????????????
    }
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempetureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("lat: \(latitude), lon: \(longitude)")
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }
    
}


