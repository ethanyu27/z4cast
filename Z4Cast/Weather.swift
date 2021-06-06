//
//  Weather.swift
//  Z4Cast
//
//  Created by Ethan Yu on 6/3/21.
//  Copyright © 2021 Yutopia Productions. All rights reserved.
//

import Foundation
import UIKit

class Weather {
    
    var globLoc: Loc? = nil
    var globWData: WData? = nil
    var searching: Bool = false
    
    //API Key for OpenWeatherMap
    let key = "5ae222e07a8e6b76557f1d269dff5e80"
    
    //Location Struct
    struct Loc: Codable {
        let name: String
        let lat: Double
        let lon: Double
        let country: String
    }
    
    //Weather Data struct
    struct WData: Codable {
        struct Daily: Codable {
            let dt: Double
            struct Temp: Codable {
                let day: Double
                let min: Double
                let max: Double
            }
            let temp: Temp
            struct Weather: Codable {
                let description: String
                let icon: String
            }
            let weather: [Weather]
        }
        let daily: [Daily]
    }
    
    //Fetches location data of input city and calls fetchForecast with the output
    func fetchCoords(city: String) {
        searching = true
        guard let urlFull = URL(string: "http://api.openweathermap.org/geo/1.0/direct?q=" + city + "&limit=1&appid=" + key)
            else {
                searching = false
                return
            }
        URLSession.shared.dataTask(with: urlFull) { (data, response, error) in
            if let error = error {
                print("API Access Error (Location): \(error)\n")
                self.searching = false
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
              print("HTTP Access Error (Location): \(response)")
              self.searching = false
              return
            }
            let posts = try! JSONDecoder().decode([Loc].self, from: data!)
            self.fetchForecast(loc: posts[0])
        }.resume()
    }
    
    //Fetches weather forecast data and sets global data structs
    func fetchForecast(loc: Loc) {
        var units = "metric"
        if UnitSetting().getUnit() == "F" {
            units = "imperial"
        }
        guard let urlFull = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=" + String(loc.lat) + "&lon=" + String(loc.lon) + "&exclude=current,minutely,hourly,alerts&units=" + units + "&appid=" + key)
            else {
                searching = false
                return
            }
        URLSession.shared.dataTask(with: urlFull) { (data, response, error) in
            if let error = error {
                print("API Access Error (Weather Data): \(error)\n")
                self.searching = false
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
              print("HTTP Access Error (Weather Data): \(response)")
              self.searching = false
              return
            }
            let posts = try! JSONDecoder().decode(WData.self, from: data!)
            self.setGLoc(loc: loc)
            self.setGWData(data: posts)
            self.searching = false
        }.resume()
    }
  
    //Converts integer for day to string
    func dayToStr(dInt: Int) -> String {
        switch dInt {
            case 1: return "Sun"
            case 2: return "Mon"
            case 3: return "Tue"
            case 4: return "Wed"
            case 5: return "Thu"
            case 6: return "Fri"
            case 7: return "Sat"
            default: return "---"
        }
    }
    
    //Returns true if API data is being retrieved
    func isSearching() -> Bool {
        return searching
    }
    
    //Resets global structs to nil
    func resetGlob() {
        globLoc = nil
        globWData = nil
    }
    
    //Returns true of any global struct is nil (for error prevention)
    func globEmpty() -> Bool {
        if globLoc == nil || globWData == nil {
            return true
        }
        return false
    }
    
    //Global Location struct accessor
    func getGLoc() -> Loc? {
        return globLoc
    }
    
    //Global Weather Data struct accessor
    func getGWData() -> WData? {
        return globWData
    }
    
    //Global Location struct mutator
    func setGLoc(loc: Loc) {
        globLoc = loc
    }
    
    //Global Weather Data struct mutator
    func setGWData(data: WData) {
        globWData = data
    }
}
