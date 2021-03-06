//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Olajide Osho on 05/05/2021.
//

import Foundation

enum EndPoint: String {
    case interestingPhotos = "flickr.interestingness.getList"
}

struct FlickrResponse: Codable {
    let photosInfo: FlickrPhotosResponse
    
    enum CodingKeys: String, CodingKey {
        case photosInfo = "photos"
    }
}

struct FlickrPhotosResponse: Codable {
    let photos: [FlickrPhoto]
    
    enum CodingKeys: String, CodingKey {
        case photos = "photo"
    }
}

struct FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "cfc784c620efbcddbfd6356340d0053f"
    
    static var interestingPhotosURL: URL {
        return flickrURL(endpoint: .interestingPhotos, parameters: ["extras":"url_z,date_taken"])
    }
    
    private static func flickrURL(endpoint: EndPoint, parameters: [String:String]?) -> URL {
        
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method":endpoint.rawValue,
            "format":"json",
            "nojsoncallback": "1",
            "api_key":apiKey
        ]
        
        for(key, value) in baseParams{
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for(key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.url!
    }
    
    static func photos(fromJSON data: Data) -> Result<[FlickrPhoto], Error> {
        do{
            let decoder = JSONDecoder()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let flickrRespone = try decoder.decode(FlickrResponse.self, from: data)
            let photos = flickrRespone.photosInfo.photos.filter{$0.remoteURL != nil}
            
            return .success(photos)
        } catch {
            return .failure(error)
        }
    }
}
