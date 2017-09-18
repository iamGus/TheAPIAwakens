//
//  SwapiError.swift
//  The API Awakens
//
//  Created by Angus Muller on 11/09/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation

// Network errors

enum SwapiError: Error {
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case jsonConversionFailure
    case jsonParsingFailure(message: String)
}
