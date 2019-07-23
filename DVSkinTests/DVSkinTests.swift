//
//  DVSkinTests.swift
//  DVSkinTests
//
//  Created by David Vallas on 7/23/19.
//  Copyright © 2019 David Vallas. All rights reserved.
//

import XCTest
@testable import DVSkin

class DVSkinTests: XCTestCase {

    // attributes for first Character returned in GetCharacters
    let personName = "Apu Nahasapeemapetilon"
    let personNameData = "<a href=\"https://duckduckgo.com/Apu_Nahasapeemapetilon\">Apu Nahasapeemapetilon</a><br>Apu Nahasapeemapetilon is a fictional character in the animated TV series The Simpsons. He is the Indian immigrant proprietor of the Kwik-E-Mart, a popular convenience store in Springfield, and is best known for his catchphrase, \"Thank you, come again.\""
    let personDescription = "Apu Nahasapeemapetilon - Apu Nahasapeemapetilon is a fictional character in the animated TV series The Simpsons. He is the Indian immigrant proprietor of the Kwik-E-Mart, a popular convenience store in Springfield, and is best known for his catchphrase, \"Thank you, come again.\""
    let url = "https://duckduckgo.com/Apu_Nahasapeemapetilon"
    let image = "https://duckduckgo.com/i/99b04638.png"
    
    // an example of an incorrect PHOTO dictionary to decode
    var incorrectModel: Any {
        return []
    }
    
    // an example of an correct PHOTO dictionary to decode
    var correctModel: Any {
        var model = HGDICT()
        model["Result"] = personNameData
        model["Text"] = personDescription
        model["FirstURL"] = url
        var icon = HGDICT()
        icon["URL"] = image
        model["Icon"] = icon
        return model
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // checks if model
    func assertPerson(person: Person) {
        XCTAssertEqual(person.name, personName)
        XCTAssertEqual(person.description, personDescription)
        XCTAssertEqual(person.url, url)
        XCTAssertEqual(person.image, image)
    }
    
    // tests a correct Photo Dictionary
    func testCorrectPhotoModel() {
        let person: Person = Person.decode(object: correctModel)
        assertPerson(person: person)
    }
    
    // tests a photo dictionary that is actually a array
    func testEmptyPhotoModel() {
        let person: Person = Person.decode(object: incorrectModel)
        XCTAssertEqual(person.name, "")
        XCTAssertEqual(person.description, "")
        XCTAssertEqual(person.url, "")
        XCTAssertEqual(person.image, "")
    }
    
    // tests a URL that has a typo in it.
    func testBadURL() {
        let expectation = XCTestExpectation(description: "Attempt to download bad url")
        let url = "https://jsonplaceholder.ERROR.typicode.com"
        let requestData = RequestData(baseURL: url,
                                      method: HttpMethod.get,
                                      headers: [:],
                                      parameters: [:])
        HGNetwork.shared.performRequest(requestData: requestData) { (results: Result<[Person]>) in
            switch results {
            case let .value(result):
                XCTAssertEqual("Error", "Result \(result) returned data")
            case let .error(error):
                let nsError = error as NSError
                XCTAssertEqual("The request timed out.", nsError.localizedDescription)
            }
            expectation.fulfill()
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }
    
    // tests GetPhotos (from network), also tests the first created Photo dictionary to make sure it was sent
    func testGetPhotos() {
        let expectation = XCTestExpectation(description: "Attempt to download good url")
        PersonNetwork.shared.getPersons() { [weak self] (result: Result<[Person]>) in
            switch result {
            case let .value(result):
                if (result.count > 0) {
                    let person  = result[0]
                    self?.assertPerson(person: person)
                } else {
                    XCTAssertEqual("Error", "Result \(result) returned invalid data")
                }
            case let .error(error):
                let nsError = error as NSError
                XCTAssertEqual("Error", nsError.localizedDescription)
            }
            expectation.fulfill()
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }

}
