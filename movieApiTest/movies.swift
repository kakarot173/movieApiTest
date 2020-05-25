//
//  movies.swift
//  movieAssignment
//
//  Created by Animesh Mohanty on 25/05/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

struct detail:Codable,Hashable{
    var vote_count: Int?
    var id: Int?
    var video: Bool?
    var vote_average: Float?
    var title: String?
    var poster_path: String?
    var originalTitle: String?
    var genreIds: [Int]?
    var backdrop_path: String?
    var adult: Bool?
    var overview: String?
    var release_date: String?
    
    var dateAddedToFavorites: Date?
    var isFavorite: Bool?
}
struct movie : Codable,Hashable{
    let results:[detail]?
    var dataArray:[detail]{
        var arr = [detail]()
        if let users = results {
            for item in users {
                arr.append(item)
            }
        }
        return arr
    }
}
