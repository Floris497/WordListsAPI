import Fluent
import Vapor

struct WordlistController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let wordlists = routes.grouped("wordlists")
        wordlists.get(use: index)
        wordlists.post(use: create)
        wordlists.group(":wordlist") { wordlist in
            wordlist.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Wordlist]> {
        return Wordlist.query(on: req.db).with(\.$translations).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Wordlist> {
        let wordlist = try req.content.decode(Wordlist.self)
        return wordlist.save(on: req.db).map { wordlist }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Wordlist.find(req.parameters.get("wordlistID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
