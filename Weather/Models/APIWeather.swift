//
//  APIWeather.swift
//  Weather
//
//  Created by Саша Тихонов on 14/12/2023.
//

import Foundation
import Alamofire

struct HourlyForecastResponse: Decodable {
    let list: [HourlyForecastItem]?
}

struct HourlyForecastItem: Decodable {
    let main: Main
    let weather: [Weather]
    let dt: Int
}

struct WeatherResponse: Decodable {
    let main: Main
    let weather: [Weather]
    let sys: Sys
    let wind: Wind
}

struct Main: Decodable {
    let temp: Double
    let feelsLike: Double
    let humidity: Int
    let pressure: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case humidity = "humidity"
        case pressure = "pressure"
    }
}

struct Weather: Decodable {
    let description: String
    let main: String
}

struct Sys: Decodable {
    let sunrise: Int
    let sunset: Int
}

struct Wind: Decodable {
    let speed: Double
}

class WeatherManager {
    var temperature: String?
    var weatherDescription: String?
    var feelsLike: String?
    var sunsetApi: Int?
    var sunriseApi: Int?
    var humidityProperty: String?
    var windSpeedProperty: String?
    var pressureProperty: String?
    var hourlyTemperatures: [Double]?
    var hourlyDescriptions: [String]?
    
    
    func getWeather(in city: String, completion: @escaping () -> Void) {
        AF.request("https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=999b95349fee0adb073d6820fd490d18").responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let weatherResponse):
                self.temperature = String(format:"%.0f°C",round(weatherResponse.main.temp - 273.15))
                self.feelsLike = String(format:"%.0f°C",round(weatherResponse.main.feelsLike - 273.15))
                self.weatherDescription = weatherResponse.weather.first?.main
                self.sunriseApi = weatherResponse.sys.sunrise
                self.sunsetApi = weatherResponse.sys.sunset
                self.humidityProperty = String(weatherResponse.main.humidity)
                self.windSpeedProperty = String(round(weatherResponse.wind.speed))
                self.pressureProperty = String(weatherResponse.main.pressure)
                
                print(weatherResponse)
                completion()
                
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    func getHourlyForecast(in city: String, completion: @escaping () -> Void) {
        AF.request("https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=999b95349fee0adb073d6820fd490d18").responseDecodable(of: HourlyForecastResponse.self) { response in
            switch response.result {
            case .success(let forecastResponse):
                if let hourlyItems = forecastResponse.list {
                    self.hourlyTemperatures = hourlyItems.map { $0.main.temp }
                    self.hourlyDescriptions = hourlyItems.map { $0.weather.first?.main ?? "N/A" }
                }
                completion()
                
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
}






