//
//  Response.swift
//  Pokedex
//
//  Created by Riandro Proença on 24/09/22.
//

import Foundation

struct Pokemon: Decodable {
    struct FrontDefault: Decodable {
        let urlImage: String

        enum CodingKeys: String, CodingKey {
            case urlImage = "front_shiny"
        }
    }

    struct Other: Decodable {
        let official: FrontDefault

        enum CodingKeys: String, CodingKey {
            case official = "home"
        }
    }

    struct Sprite: Decodable {
        let other: Other
    }

    let name: String
    let sprites: Sprite

}
