//
//  Meal.swift
//  
//
//  Created by Zachary Morden on 2022-07-25.
//

import Foundation
import Fluent
import Vapor

final class Meal: Model, Content {
    static var schema: String = "meals"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    init() { }
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
