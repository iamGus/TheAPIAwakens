//
//  SwapiAPIClient.swift
//  The API Awakens
//
//  Created by Angus Muller on 11/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation


class SwapiAPIClient {
    let downloader = JSONDownloader()
    
    func getData(type: StarWars, completion: @escaping ([Characters], SwapiError?) -> Void) {
        let endpoint = type
        print(endpoint.request)
        
        // Perform request
        
        let task = downloader.jsonTask(with: endpoint.request) { json, error in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion([], error)
                    return
                }
                
                guard let results = json["results"] as? [[String: Any]] else {
                    completion([], .jsonParsingFailure(message: "JSON data does not contain results"))
                    return
                }
               
                let starwarsType = results.flatMap { Characters(json: $0) }
                completion(starwarsType, nil)
                
            }
        }
        
        task.resume()
        
    }
}










