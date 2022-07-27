import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { _ in
        HTTPStatus.ok
    }
    
    try app.register(collection: MealController())
}
