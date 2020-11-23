import Fluent
import Vapor

struct TranslationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let translation = routes.grouped("translation")
        translation.get(use: index)
        translation.post(use: create)
        translation.group(":translation") { translation in
            translation.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Translation]> {
        return Translation.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Translation> {
        let translation = try req.content.decode(Translation.self)
        return translation.save(on: req.db).map { translation }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Translation.find(req.parameters.get("translationID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
