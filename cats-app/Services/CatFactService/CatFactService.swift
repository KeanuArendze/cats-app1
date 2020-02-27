//
//  CatFactsService.swift
//  CatInaApp
//
//  Created by Keanu on 2020/02/17.
//  Copyright © 2020 Keanu. All rights reserved.
//

import Foundation

class CatFactsService : CatProtocol {
    
    func fetchCatFacts(numberOfFacts: Int,
                       success: @escaping FetchedCatFactsSuccess) {
        let url = URL(string:  "https://cat-fact.herokuapp.com/facts/random?animal_type=cat&amount=\(numberOfFacts)")
        
        if let url = url {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    print("Error with fetching cat facts: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        print("Error with the response, unexpected status code: \(String(describing: response))")
                        return
                }
                
                var catFacts = [CatFactsDataModel]()
                if let usableData = data {
                    do {
                        let jsonArray = try JSONSerialization.jsonObject(with: usableData, options: .allowFragments)  as! [[String:Any]]
                        print(jsonArray[0])
                        for item in jsonArray {
                            catFacts.append(CatFactsDataModel(with: item))
                        }
                        success(catFacts)
                    } catch {
                        print("JSON Processing Failed")
                    }
                }
            })
            task.resume()
        } else {
            success([CatFactsDataModel]())
        }
    }
}
