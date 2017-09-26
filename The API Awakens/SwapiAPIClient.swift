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
    
    func getData(type: StarWarsEndpoint, completion: @escaping ([StarWarsTypes], SwapiError?) -> Void) {
        let endpoint = type
        
        // Perform request to JSONDownloader
        print("endpoint: \(endpoint)")
        print(endpoint.request)
        let task = downloader.jsonTask(with: endpoint.request) { json, error in
            DispatchQueue.main.async {
                guard let json = json else { // Check if JSON nil, if it is return error
                    completion([], error)
                    return
                }
                
                guard let results = json["results"] as? [[String: Any]] else { // Check if JSON file contains results, if it does not return error
                    completion([], .jsonParsingFailure(message: "JSON data does not contain results"))
                    return
                }
               
                if type == .character { // If type was characters then init Json through Characters class
                    let starwarsType = results.flatMap { Characters(json: $0) }
                    
                    // Get Planet name: To get planet data from swapi for each character
                    // Note: I wanted to see if this way was possible which it is but I don't think this is the best way of retrieving the planet name due to calling a new network request over a for loop.
                    // A much better way might be to try and use operations and operation queues.
                    for eachCharacter in starwarsType {
                        
                        let planetTask = self.downloader.jsonTask(with: eachCharacter.homeUrl) { json, error in
                            DispatchQueue.main.async {
                                guard let json = json else { // Check if JSON nil, if it is return error
                                    completion([], error)
                                    return
                            }
                                guard let planetName = json["name"] as? String else { // check if JSON file contains the name key, if it does not then return error
                                    completion([], .jsonParsingFailure(message: "JSON data does not contain results"))
                                    return
                                }
                                eachCharacter.homeName = planetName // add planet name to each Star Wars Character
                                
                        }
                    }
                        planetTask.resume()
                    }
                    completion(starwarsType, nil)
                } else { // else type will be . starship or .vehicles so init Json through Hardware class
                    let starwarsType = results.flatMap { Hardware(json: $0, hardwareType: type) }
                    completion(starwarsType, nil)
                }
                
                
            }
        }
        
        task.resume()
        
    }
}










