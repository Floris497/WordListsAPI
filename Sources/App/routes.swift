import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "Server is running!"
    }

    try app.register(collection: WordlistController())
    try app.register(collection: TranslationController())
}
