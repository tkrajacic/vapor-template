import Vapor

@main
enum App {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        let app = Application(env)
        app.logger.logLevel = .info
        
        defer { app.shutdown() }
        try await configure(app)
        try app.run()
    }
}
