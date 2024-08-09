//
//  Search.swift
//  iTunesSearchApp
//
//  Created by 박다현 on 8/8/24.
//

import Foundation

struct Search: Decodable {
    let resultCount:Int
    let results: [SearchResults]
}

struct SearchResults: Decodable {
    let collectionId: Int?
    let artistName: String?
    let collectionName: String?
    let artworkUrl100: String?
    let shortDescription: String?
    let longDescription: String?
}
