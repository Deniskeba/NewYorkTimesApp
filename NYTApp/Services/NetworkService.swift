//
//  NetworkService.swift
//  NYTApp
//
//  Created by Denis Kobylkov on 16.05.2023.
//

import Foundation
import Alamofire
import CoreData

class NetworkService {
    
    func fetchData(url: String, complition: @escaping (Result<NewsResponse, Error>) -> () ){
        AF.request(url)
            .validate()
            .response { response in
                guard let data = response.data else {
                    if let error = response.error {
                        complition(.failure(error))
                    }
                    return
                }
                JSONDecoder().keyDecodingStrategy = .convertFromSnakeCase
                guard let newsResponse = try? JSONDecoder().decode(NewsResponse.self, from: data)
                else { return}
                complition(.success(newsResponse))
            }
    }
}
