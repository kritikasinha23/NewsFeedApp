//
//  NetworkService.swift
//  NewsUpdate
//
//  Created by kritika sinha on 20/05/22.
//

import Foundation


class NetworkService {
    
    private init(){
        
    }
    static let shared : NetworkService = NetworkService()
    func readData(completion : @escaping (_ news: ArticlesModel?, _ error: Error?)->Void, fromURLStr : String) {
        
        guard let url : URL = URL(string: fromURLStr) else {
            print("Unable to create url from string -->> \(fromURLStr)")
            return
        }
        
        let urlRequest = URLRequest(url: url)

        let session = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            if let errorExist = error {
                print(errorExist.localizedDescription)
                completion(nil, error)
                return
            }
            if let response = urlResponse as? HTTPURLResponse {
                
                if let responseData = data {
                    
                    let resultStr = String(data: responseData, encoding: .utf8)
                    print(resultStr)
                
                do {
                    let dataArray : ArticlesModel = try JSONDecoder().decode(ArticlesModel.self, from: responseData)
                    completion(dataArray,nil)
                } catch let error {
                    completion(nil,error)
                    print("Error isoccured \(error.localizedDescription)")
                }
                    
                }
                else {
                    print("No data")
                    completion(nil, nil)
                }
            
        }
            

        }
        session.resume()
        
    }
}
