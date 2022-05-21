
import Foundation
struct JsonResponseParser {
    func convertJson<T: Codable>(data : Data?, type: T.Type, completion : (T?, ArticlesError?)->Void) {
        if let responseData = data {
            do {
                let dataArray  = try JSONDecoder().decode(T.self, from: responseData)
                completion(dataArray,nil)
            } catch let error {
                completion(nil,ArticlesError.jsonConversionError)
                print("Error isoccured \(error.localizedDescription)")
            }
            
        }
        else {
            completion(nil, ArticlesError.emptyResponseError)
        }
    }
}
