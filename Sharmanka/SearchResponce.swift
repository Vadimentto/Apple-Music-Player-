//
//  SearchResponce.swift
//  Sharmanka
//
//  Created by Vadym Potapov on 12.01.2023.
//

import Foundation

struct SearchResponce: Decodable {
    
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    
    var trackName: String
    var collectionName: String?
    var artistName: String
    var artworkUrl100: String?
    var previewUrl: String?
}
