//
//  HomeViewModel.swift
//  CatInaApp
//
//  Created by Keanu on 2020/02/17.
//  Copyright © 2020 Keanu. All rights reserved.
//

import Foundation

class HomeViewModel {
    var catFactsService: CatFactsService
    weak var delegate: CatDelegate?
    var catFacts: [CatFactsDataModel]
    
    init(with catFactsService: CatFactsService,
         delegate: CatDelegate) {
        self.delegate = delegate
        self.catFactsService = catFactsService
        self.catFacts = [CatFactsDataModel]()
    }
    
    func fecthCatFacts() {
        self.catFactsService.fetchCatFacts(numberOfFacts: 10) { [weak self] (response) in
            self?.catFacts = response
            self?.delegate?.updateTableWithData()
        }
    }
}
