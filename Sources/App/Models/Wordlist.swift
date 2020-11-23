//
//  WordList.swift
//  
//
//  Created by Floris Fredrikze on 20/11/2020.
//

import Fluent
import Vapor

enum Language: String, Codable, CaseIterable {
    static let schema = "language"

    case english
    case russian
    case dutch
    case french
    case spanish
    case chinese
    case japanese
    case german
    case polish
    case finish
    case czech
    case portuguese
    case greek
    case latin
}

final class Wordlist: Model, Content {
    static let schema = "wordlist"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Enum(key: "language_from")
    var langFrom: Language

    @Enum(key: "language_to")
    var langTo: Language

    @Children(for: \.$wordlist)
    var translations: [Translation]

    init() { }

    init(id: UUID? = nil, title: String, langFrom: Language, langTo: Language) {
        self.id = id
        self.title = title
        self.langFrom = langFrom
        self.langTo = langTo
    }
}
