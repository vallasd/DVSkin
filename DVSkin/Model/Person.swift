//
//  Person.swift
//  PhotoApp
//
//  Created by David Vallas on 5/6/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import Foundation
import DVNetwork

struct Person: DVCodable {
    
    let name: String
    let description: String
    let url: String
    let image: String
    
    var descriptionURL: URL {
        return URL(string: url) ?? URL(string: "https://css-tricks.com/thispagedoesntexist")!
    }
    
    var imageURL: URL? {
        return URL(string: image)
    }
    
    // MARK: - HGCodable
    
    var encode: Any {
        var dict = DVDICT()
        dict["name"] = name
        dict["description"] = description
        dict["url"] = url
        dict["image"] = image
        return dict
    }
    
    static func decode(object: Any) -> Person {
        let dict = DVDecode.decode(dvdict: object, decoder: Person.self)
        let name = dict["Result"].characterName
        let description = dict["Text"].string
        let url = dict["FirstURL"].string
        let image = dict["Icon"].dict["URL"].string
        return Person(name: name,
                     description: description,
                     url: url,
                     image: image)
    }
    
    static func decode(object: Any) -> [Person] {
        let dict = DVDecode.decode(dvdict: object, decoder: Person.self)
        let photos = dict["RelatedTopics"].array
        let array: [Person] = photos.map { decode(object: $0) }
        return array
    }
}
