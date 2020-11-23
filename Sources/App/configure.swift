import Vapor
import Fluent
import FluentPostgresDriver

extension Application {
    static let databaseUrl = URL(string: Environment.get("DB_URL")!)!
}

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    try app.databases.use(.postgres(url: Application.databaseUrl), as: .psql)

    app.migrations.add(CreateTranslation())
    app.migrations.add(CreateWordList())

    // register routes
    try routes(app)
}
