//
//  ComcastCore.swift
//  ComcastCore
//
//  Created by David Vallas on 7/18/19.
//  Copyright © 2019 David Vallas. All rights reserved.
//

import Foundation
import DVNetwork

public class DVSkin {
    
    public static let shared = DVSkin()
    
    // changeable variables
    
    // URL used by the app
    public var baseURL = "https://api.duckduckgo.com"
    
    // parameters for Requests
    public var getPersonsParameters: RequestDict = [
        "q" : "simpsons+characters",
        "format" : "json"
    ]
}
