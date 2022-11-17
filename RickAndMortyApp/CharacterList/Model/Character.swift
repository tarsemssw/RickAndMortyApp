//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Tarsem Singh on 16/11/22.
//

struct APIResponse:Decodable{
    var results: [Character]
}

struct Character: Decodable{
    var id: Int
    var name: String
    var status: String
    var species: String
    var gender: String
    var image: String
    var location: Location
    var episode: [String]
}

struct Location: Decodable {
    var name: String
    var url: String
}
