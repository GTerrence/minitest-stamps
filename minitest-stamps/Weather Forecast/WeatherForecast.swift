//
//  Network.swift
//  minitest-stamps
//
//  Created by Terrence Pramono on 10/11/23.
//

import Foundation

/// Custom error for API Calls
enum APIError : LocalizedError {
    case invalidUrl
    case invalidResponse
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Url is invalid!"
        case .invalidResponse:
            return "Failed to get successful response!"
        case .invalidData:
            return "Failed to parse data!"
        }
    }
}


/// struct for "Menampilkan ramalan cuaca kota Jakarta untuk 5 hari kedepan" Mini Test
struct WeatherForecast {
    let apiKey = "c116efd669f6e29d42d13e5b689a37f0"
    let cityName = "Jakarta"
    let countryCode = "ID"
    let units = "metric"
    let forecastEndpoint : String
    
    init() {
        self.forecastEndpoint = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName),\(countryCode)&units=\(units)&appid=\(apiKey)"
    }
    
    func execute() async {
        do {
            let data = try await getData(endPoint: forecastEndpoint)
            let objects = try decodeJSON(data, type: BaseResponseModel.self)
            
            
        //    To save displayed date
            var visited : Set<String> = [convertToDateTime(Date().timeIntervalSince1970, timeZone: objects.city.timezone)]

            
            for forecast in objects.list {
                let date = convertToDateTime(TimeInterval(forecast.date), timeZone: objects.city.timezone)
                if !visited.contains(date) {
                    print("\(date): \(forecast.main.temp)°C")
                    visited.insert(date)
                }
            }
        } catch let error as APIError {
            print("API Error : \(error.localizedDescription)")
        } catch let error {
            print("General error : \(error.localizedDescription)")
        }
    }
    
    /// For API calls
    /// - Parameter endPoint: API endpint to GET Request from
    /// - Throws: If URL or Response is invalid
    /// - Returns: Data from API calls
    func getData(endPoint:String) async throws -> Data {
        print("Start get data")
        guard let url = URL(string: endPoint) else {
            throw APIError.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        return data
    }
    
    /// To change unix time stamp format to Date Time String
    /// - Parameters:
    ///   - unixTimeStamp: Date time in unix time stamp format
    ///   - timeZone: timezone of location
    /// - Returns: Date Time in string format
    func convertToDateTime(_ unixTimeStamp: TimeInterval, timeZone: Int) -> String {
        let date = Date(timeIntervalSince1970: unixTimeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timeZone)
        return dateFormatter.string(from: date)
    }
    
    /// Function to decode JSON data to expected type
    /// - Parameters:
    ///   - data: JSON data from API
    ///   - type: Type of object to be convert to
    /// - Throws: Invalid Data
    /// - Returns: Object with type specified in `type` argument
    func decodeJSON<T:Codable>(_ data: Data, type: T.Type) throws -> T {
        do {
            let decoder = JSONDecoder()
            let objects = try decoder.decode(T.self, from: data)
            return objects
        } catch let error {
            print("Decoding JSON Error : \(error)")
            throw APIError.invalidData
        }
    }
}






