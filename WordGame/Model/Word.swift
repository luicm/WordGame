//
//  Word.swift
//  WordGame
//
//  Created by Luisa Cruz Molina on 07.12.20.
//

import Foundation

struct Word: Decodable, Equatable {
    let english: String
    let spanish: String
    
    private enum CodingKeys: String, CodingKey {
    case english = "text_eng"
    case spanish = "text_spa"
    }
}
