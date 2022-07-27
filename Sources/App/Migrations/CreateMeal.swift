//
//  CreateMeal.swift
//  
//
//  Created by Zachary Morden on 2022-07-25.
//

import Foundation
import Fluent

struct CreateMeal: Migration {
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("meals")
            .id()
            .field("name", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("meals")
            .delete()
    }
}
