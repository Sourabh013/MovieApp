//
//  GetMovieList.swift
//  MovieApp
//
//  Created by Sourabh Modi on 18/10/24.
//

import Foundation

class GetMovieList {
    
    private let strAPI = "http://www.omdbapi.com/?s=guardians&apikey=18f292d6"
        
        func getMovieList(completion: @escaping (Result<GetMovieAPIResponse, Error>) -> Void) {
            guard let url = URL(string: strAPI) else {
                completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let movieResponse = try decoder.decode(GetMovieAPIResponse.self, from: data)
                    completion(.success(movieResponse))
                    
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
}
