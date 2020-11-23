import Fluent

struct CreateTranslation: Migration {
    // Prepares the database for storing Galaxy models.
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        var enumBuilder = db.enum(Language.schema.description)
        for option in Language.allCases {
            enumBuilder = enumBuilder.case(option.rawValue)
        }
        return enumBuilder.create()
            .flatMap { enumType in
                db.schema(Wordlist.schema)
                    .id()
                    .field("language_from", enumType, .required)
                    .field("language_to", enumType, .required)
                    .create()
            }
    }

    // Optionally reverts the changes made in the prepare method.
    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.schema(Wordlist.schema).delete().flatMap {
            db.enum(Language.schema).delete()
        }
    }
}

struct CreateWordList: Migration {
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.schema(Translation.schema)
            .id()
            .field("title", .string, .required)
            .field("original", .string, .required)
            .field("translation", .string, .required)
            .field(.string(Wordlist.schema + "_id"), .uuid, .required, .references(Wordlist.schema, "id"))
            .create()
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.schema(Translation.schema).delete()
    }
}
