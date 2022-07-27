import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    //
    // Commands to run from project dir.
    //
    // Create server directory:
    // mkdir ./Server
    //
    // Create the Postgres instance:
    // pg_ctl -D ./Server initdb
    //
    // Start server:
    // pg_ctl -D ./server -l db-log.txt start
    //
    // Connect to server as "postgres" admin user:
    // psql postgres
    //
    // Create user for Vapor:
    // CREATE USER vapor WITH ENCRYPTED PASSWORD 'vapor';
    //
    // Create database:
    // CREATE DATABASE foodtracker;
    //
    // Make Vapor a superuser on the database:
    // GRANT ALL PRIVILEGES ON DATABASE foodtracker TO vapor;
    //
    
    let hostname: String
    
    if app.environment == .production {
        // Change hostname to 'db' if spun up from Docker Compose.
        hostname = "db"
    } else {
        hostname = "localhost"
    }
    
    app.databases.use(.postgres(
        hostname: hostname,
        port: 5432,
        username: "vapor",
        password: "vapor",
        database: "foodtracker"
    ), as: .psql)
    
    app.migrations.add(CreateMeal())
    
    try app.autoMigrate().wait()
    
    // register routes
    try routes(app)
    
    // Change the port away from the default web port, if needed.
    // This would allow a separate front end app to be served which
    // can call on the Vapor backend.
//    app.http.server.configuration.port = 8090
}
