//
//  NetworkManager.swift
//  FakeNews
//
//  Created by Alexandr Gerasimov on 06.01.2022.
//https://newsapi.org/v2/top-headlines?country=en&apiKey=c8b5a9c5a9b84505aa31702e5373d532
//https://newsapi.org/v2/everything?q=Apple&from=2022-01-06&sortBy=popularity&apiKey=API_KEY

import Foundation
import UIKit
final class NetworkManager{
    static let instance = NetworkManager()
    
    
    struct ApiParameters{
        static let apiKey = "c8b5a9c5a9b84505aa31702e5373d532"
        static let scheme = "https"
        static let defaultLanguage = "us"
        static let host = "newsapi.org"
        static let topNewsPath = "/v2/top-headlines"
        static let searchNewsPath = "/v2/everything"
        static var topNewsURL: URL?{
             let locale = NSLocale.current.languageCode ?? ApiParameters.defaultLanguage
             var components = URLComponents()
             components.scheme = ApiParameters.scheme
             components.host = ApiParameters.host
             components.path = ApiParameters.topNewsPath
            components.queryItems = [URLQueryItem(name: "country", value: "us"), URLQueryItem(name: "apiKey", value: ApiParameters.apiKey)]
             
             guard let url = components.url else{
                 preconditionFailure("Incorrect components: \(components)")
             }
             return url
         }
        static var searchNewsUrl: String?{
             
             var components = URLComponents()
             components.scheme = ApiParameters.scheme
             components.host = ApiParameters.host
             components.path = ApiParameters.searchNewsPath
            components.queryItems = [URLQueryItem(name: "apiKey", value: ApiParameters.apiKey), URLQueryItem(name: "sortBy", value: "popularity"), URLQueryItem(name: "language", value: "en")]
             
             guard let url = components.url else{
                 preconditionFailure("Incorrect components: \(components)")
             }
            return url.absoluteString
         }

    }
    public func getTopNews(completion: @escaping (Result<[Article], Error>) -> Void){
        guard let url = ApiParameters.topNewsURL else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
                
        )
        task.resume()
    }
    public func searchNews(with query: String,completion: @escaping (Result<[Article], Error>) -> Void){
        guard var url = ApiParameters.searchNewsUrl else{
            return
        }
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        url += "&q=\(query)"
        print(url)
        guard let searchUrl = URL(string: url) else{
            return
        }
        let task = URLSession.shared.dataTask(with: searchUrl, completionHandler: {data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
                
        )
        task.resume()
    }
    private init(){}
    
    
}
