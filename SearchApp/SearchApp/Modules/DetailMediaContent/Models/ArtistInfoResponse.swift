//
//  ArtistInfoResponse.swift
//  SearchApp
//
//  Created by Олег Романов on 10.04.2024.
//

import Foundation

struct ArtistInfoResponse: Decodable {
    let resultCount: Int
    let results: [ArtistResult]
}

// MARK: - Result
struct ArtistResult: Decodable {
    let wrapperType: String?
    let artistType: String?
    let artistName: String?
    let artistLinkUrl: String?
    let artistId: Int?
    let amgArtistId: Int?
    let primaryGenreName: String?
    let primaryGenreId: Int?
}
