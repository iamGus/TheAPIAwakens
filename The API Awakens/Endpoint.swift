//
//  Endpoint.swift
//  The API Awakens
//
//  Created by Angus Muller on 11/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var scheme: String { get }
}

extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = base
        components.path = path
        
        print(components)
        
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}

enum StarWars {
    case character
    case starship
    case vehicles
}

extension StarWars: Endpoint {
    
    var scheme: String {
        return "https"
    }
    
    var base: String {
        return "swapi.co"  // Base root url
    }
    
    // Three possible recources
    var path: String {
        switch self {
        case .character: return "/api/people/"
        case .starship: return "/api/starships/"
        case .vehicles: return "/api/vehicles/"
        }
    }
}
