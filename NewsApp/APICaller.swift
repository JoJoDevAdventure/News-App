//
//  APICaller.swift
//  NewsApp
//
//  Created by Youssef Bhl on 29/12/2021.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlineURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=5bc7f4f986974f7b9b6939e26a1ada32")
    }
    
    private init(){}
    
    public func getTopStoriees(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadlineURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

//models

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct source: Codable {
    let name: String
}
