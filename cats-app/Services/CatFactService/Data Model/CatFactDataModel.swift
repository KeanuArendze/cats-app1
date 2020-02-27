//
//  CatFactDataModel.swift
//  CatInaApp
//
//  Created by Keanu on 2020/02/17.
//  Copyright © 2020 Keanu. All rights reserved.
//

import Foundation

struct CatFactsDataModel {
    var catFact: String?
    
    init(with dictionary: [String:Any]) {
        catFact = dictionary["text"] as? String
    }
}
