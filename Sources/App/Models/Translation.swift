
import Fluent
import Vapor

final class Translation: Model, Content {
    static let schema = "translation"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "original")
    var original: String

    @Field(key: "translation")
    var translation: String

    @Parent(key: .string(Wordlist.schema + "_id"))
    var wordlist: Wordlist

    init() { }

    init(id: UUID? = nil, original: String, translation: String) {
        self.id = id
        self.original = original
        self.translation = translation
    }
}
