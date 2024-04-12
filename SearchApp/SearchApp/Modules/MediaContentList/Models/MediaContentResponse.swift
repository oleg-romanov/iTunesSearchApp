//
//  MediaContentResponse.swift
//  SearchApp
//
//  Created by Олег Романов on 06.04.2024.
//

import Foundation

struct MediaContentResponse: Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let wrapperType: String?
    let kind: String
    let artistId: Int?
    let collectionId: Int?
    let trackId: Int?
    let artistName: String
    let collectionName: String?
    let trackName: String?
    let collectionCensoredName: String?
    let trackCensoredName: String?
    let collectionArtistId: Int?
    let collectionArtistViewUrl: String?
    let artistViewUrl: String?
    let collectionViewUrl: String?
    let trackViewUrl: String?
    let previewUrl: String?
    let artworkUrl30: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let collectionPrice: Float?
    let trackPrice: Float?
    let trackRentalPrice: Float?
    let collectionHdPrice: Float?
    let trackHdPrice: Float?
    let trackHdRentalPrice: Float?
    let releaseDate: String?
    let collectionExplicitness: String?
    let trackExplicitness: String?
    let discCount: Int?
    let discNumber: Int?
    let trackCount: Int?
    let trackNumber: Int?
    let trackTimeMillis: Int?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let contentAdvisoryRating: String?
    let longDescription: String?
    let hasITunesExtras: Bool?
    let isStreamable: Bool?
    let artistIds: [Int]?
    let genres: [String]?
    let price: Float?
    let genreIds: [String]?
    let description: String?
    let fileSizeBytes: Int?
    let formattedPrice: String?
    let averageUserRating: Float?
    let userRatingCount: Int?
    let copyright: String?
}
