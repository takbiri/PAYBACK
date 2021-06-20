//
//  Feeds.swift
//  PAYBACK
//
//  Created by Mohammad Takbiri on 6/16/21.
//

import Foundation

struct Tiles: Codable {
    let tiles: [Tile]
}

struct Tile: Codable {
    
    let name: String
    let headline: String?
    let subline: String?
    let data: String?
    let score: Int
    var dataType: DataType?
    
}

enum DataType: String, Codable{
    case image
    case video
    case website
    case shopping_List
}
