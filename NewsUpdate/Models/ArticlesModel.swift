//
//  Welcome.swift
//  NewsUpdate
//
//  Created by kritika sinha on 20/05/22.
//

import Foundation

struct ArticlesModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
