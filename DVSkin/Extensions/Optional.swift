//
//  Optional.swift
//  SkinningDemo
//
//  Created by David Vallas on 7/20/19.
//  Copyright © 2019 David Vallas. All rights reserved.
//

import Foundation
import HGCodable
import HGReport

extension Optional {
    
    // Skinning Demo specific
    
    var characterName: String {
        if let s = self.checkString { return s.components(separatedBy: ">")[1].components(separatedBy: "<")[0] }
        HGReport.shared.optionalFailed(String.self, object: self, returning: "")
        return ""
    }
}
