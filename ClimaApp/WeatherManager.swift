//
//  WeatherManager.swift
//  ClimaApp
//
//  Created by Alexandra on 01.09.2022.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=6aec6f7a0f7e05b0a27efc71dcb459c7&lang=ru&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //Create a URL
        if let url = URL(string: urlString) {
            //Create a URLSession
            let session = URLSession(configuration: .default)
            
            //Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            
            //start the task
            task.resume()
        }
        
        
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decidedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decidedData.name)
            print(decidedData.main.temp)
            print(decidedData.weather[0].description)
            print(decidedData.main.temp_max)
            let weatherConditionName = getContidionName(weatherID: decidedData.weather[0].id)
            print(weatherConditionName)
            
        } catch {
            print(error)
        }
        
        
        
    }
    
    func getContidionName(weatherID: Int) -> String {
        switch weatherID {
        case 200...232:
            return "cloud.bolt"
            
        case 300...321:
            return "cloud.drizzle"
            
        case 500...531:
            return "cloud.rain"
            
        case 600...622:
            return "cloud.snow"
            
        case 701...781:
            return "cloud.fog"
            
        case 800:
            return "sun.max"
            
        case 801...804:
            return "cloud.bolt"
            
        default:
            return "cloud"
        }
        
    }
    
}
