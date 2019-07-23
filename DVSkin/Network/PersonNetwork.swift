//
//  FlickrNetwork.swift
//  PhotoApp
//
//  Created by David Vallas on 5/5/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import Foundation
import HGCodable
import DVNetwork

class PersonNetwork {
    
    /// Gets photos from Network.
    static func getPersons<A: HGCodable>(completion: @escaping (DVResult<[A]>) -> ()) {
        let requestData = RequestData(baseURL: DVSkin.shared.baseURL,
                                      method: HttpMethod.get,
                                      headers: [:],
                                      parameters: DVSkin.shared.getPersonsParameters)
        DVNetwork.shared.performRequest(requestData: requestData) { (results) in
            completion(results)
        }
    }

}
