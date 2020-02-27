//
//  CatProtocol.swift
//  CatInaApp
//
//  Created by Keanu on 2020/02/17.
//  Copyright © 2020 Keanu. All rights reserved.
//

import Foundation

typealias FetchedCatFactsSuccess = (_ catFactsList: [CatFactsDataModel]) -> Void

protocol CatProtocol {
    func fetchCatFacts(numberOfFacts: Int,
                      success: @escaping FetchedCatFactsSuccess)
}
