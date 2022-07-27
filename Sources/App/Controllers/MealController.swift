//
//  MealController.swift
//
//
//  Created by Zachary Morden on 2022-07-25.
//

import Foundation
import Vapor
import Fluent

final class MealController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let meals = routes.grouped("meals")
        meals.on(.GET, use: get)
        meals.on(.POST, use: create)
        meals.on(.DELETE, use: delete)
        meals.get(":id", use: find)
    }
    
    private func allMeals(on database: Database) -> EventLoopFuture<[Meal]> {
        Meal.query(on: database).all()
    }
    
    private func find(_ req: Request) throws -> Meal {
        if let idString = req.parameters.get("id"), let id = UUID(uuidString: idString) {
            let meals = try allMeals(on: req.db).wait()
            if let meal = meals.first(where: {
                $0.id == id
            }) {
                return meal
            }
        }
        
        throw Abort(HTTPStatus.notFound)
    }
    
    private func get(_ req: Request) throws -> EventLoopFuture<[Meal]> {
        return allMeals(on: req.db)
    }
    
    private func create(_ req: Request) async throws -> HTTPStatus {
        try req.content
            .decode([Meal].self)
            .forEach { meal in
            _ = meal.save(on: req.db)
        }
        
        return .ok
    }
    
    private func delete(_ req: Request) async throws -> HTTPStatus {
        let meals = try await Meal.query(on: req.db).all()
        
        try req.content.decode([String].self).forEach { id in
            if let meal = meals.first(where: { meal in
                meal.id?.uuidString == id.uppercased()
            }) {
                try meal.delete(on: req.db).wait()
                return
            }
            
            throw Abort(.badRequest)
        }
        
        return .ok
    }
}
