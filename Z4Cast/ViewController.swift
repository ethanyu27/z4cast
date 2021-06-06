//
//  ViewController.swift
//  Z4Cast
//
//  Created by Ethan Yu on 6/2/21.
//  Copyright © 2021 Yutopia Productions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var errMsg: UILabel!
    @IBOutlet var unit: UISwitch!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var infoD1: UILabel!
    @IBOutlet weak var infoD2: UILabel!
    @IBOutlet weak var infoD3: UILabel!
    @IBOutlet weak var infoD4: UILabel!
    @IBOutlet weak var infoD5: UILabel!
    @IBOutlet var icon1: UIImageView!
    @IBOutlet var icon2: UIImageView!
    @IBOutlet var icon3: UIImageView!
    @IBOutlet var icon4: UIImageView!
    @IBOutlet var icon5: UIImageView!

    var city = "Danville"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize the unit switch based on user default
        if (UnitSetting().getUnit() == "C") {
            unit.setOn(false, animated: false)
            unitLabel.text = "Unit: C"
        } else {
            unit.setOn(true, animated: false)
            unitLabel.text = "Unit: F"
        }
        
    }
    
    
    //Handle submission of city
    @IBAction func onButtonTap() {
        getCity()
        city = city.replacingOccurrences(of: " ", with: "%20")
        let weather = Weather()
        weather.fetchCoords(city: city)
        
        //Wait until API search is complete
        while(weather.isSearching()) {}
        if !weather.globEmpty() {
            printForecast(data: weather.getGWData()!, loc: weather.getGLoc()!)
        } else {
            errMsg.text = "Error finding data"
        }
    }

    //set city variable and clear city field/error message
    @IBAction func getCity() {
        city = cityField.text!
        cityField.text = ""
        errMsg.text = ""
    }
    
    // Change unit if switch is toggled (ON: Farenheit, OFF: Celsius)
    @IBAction func switchUnit(_ unit: UISwitch!) {
        if unit.isOn {
            unitLabel.text = "Unit: F"
            UnitSetting().setUnit(unit: "F")
        } else {
            unitLabel.text = "Unit: C"
            UnitSetting().setUnit(unit: "C")
        }
    }
    
    func printForecast(data: Weather.WData, loc: Weather.Loc) {
        
        //create arrays for looping through UI elements
        let days: [UILabel] = [infoD1, infoD2, infoD3, infoD4, infoD5]
        let icons: [UIImageView] = [icon1, icon2, icon3, icon4, icon5]
        
        //Set City Name
        infoTitle.text = "City: " + loc.name + ", " + loc.country
        
        //Day Counter: limit to 5 entries
        var dayCt = 0
        
        for item in data.daily {
            
            //Increment/Check day counter
            dayCt += 1
            if dayCt > 5 {
                break
            }
            
            //Convert date to day of the week
            let date = Date(timeIntervalSince1970: item.dt)
            let cal = Calendar(identifier: .gregorian)
            let day = cal.component(.weekday, from: date)
            
            //Write weather info
            days[dayCt - 1].text = "-" + Weather().dayToStr(dInt: day) + "- T: " + String(item.temp.day) + ", " + item.weather[0].description
            
            //Paste icon
            let url = URL(string: "http://openweathermap.org/img/wn/" + item.weather[0].icon + "@2x.png")!
            if let data = try? Data(contentsOf: url) {
                icons[dayCt - 1].image = UIImage(data: data)
            }
        }
        
    }
    
    
   
    

}

