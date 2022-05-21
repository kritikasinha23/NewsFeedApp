//
//  NetworkService.swift
//  NewsUpdate
//
//  Created by kritika sinha on 20/05/22.
//

import Foundation

enum ArticlesError : Error{
    case invalidUrlError
    case networkError
    case jsonConversionError
    case emptyResponseError
}

class NetworkService {
    
    
    static let shared : NetworkService = NetworkService()
    func readData<T: Codable>(fromURLStr : String,type: T.Type, completion : @escaping (_ news: T?, _ error: ArticlesError?)->Void) {
        
        guard let url : URL = URL(string: fromURLStr) else {
            print("Unable to create url from string -->> \(fromURLStr)")
            completion(nil, ArticlesError.invalidUrlError)
            return
        }
        
        let urlRequest = URLRequest(url: url)

        let session = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            if let errorExist = error {
                print(errorExist.localizedDescription)
                completion(nil, ArticlesError.networkError)
                return
            }
            let jsonParser = JsonResponseParser()
            jsonParser.convertJson(data: data, type: T.self, completion: completion)
        }
        session.resume()
        
    }
}
