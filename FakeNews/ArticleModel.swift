//
//  ArticleModel.swift
//  FakeNews
//
//  Created by Alexandr Gerasimov on 06.01.2022.
//

import Foundation

//Model

struct APIResponse: Codable{
    let articles: [Article]
}
struct Article:Codable{
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}
struct Source:Codable{
    let name: String
    
}
