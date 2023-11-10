//
//  Response.swift
//  minitest-stamps
//
//  Created by Terrence Pramono on 10/11/23.
//

import Foundation

struct BaseResponseModel : Codable {
    let code : String
    let message : Int
    let count : Int
    let list : [WeatherForecastModel]
    let city : City
    
    private enum CodingKeys: String, CodingKey {
        case code = "cod"
        case message = "message"
        case count = "cnt"
        case list = "list"
        case city = "city"
    }
}

struct WeatherForecastModel : Codable {
    let date :Int
    let main : WeatherSummary
    
    private enum CodingKeys: String, CodingKey {
        case date = "dt"
        case main = "main"
    }
}

struct WeatherSummary : Codable {
    let temp : Float
}

struct City : Codable {
    let id : Int
    let name : String
    let timezone : Int
    
}
