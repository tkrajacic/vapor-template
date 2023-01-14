import Vapor

// See https://github.com/vapor/template/pull/78#issuecomment-1106832185
extension Application {
  private static let runQueue = DispatchQueue(label: "Run")

  /// We need to avoid blocking the main thread, so spin this off to a separate queue
  func run() async throws {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
      Self.runQueue.async { [self] in
        do {
          try run()
          continuation.resume()
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }
}

@main
enum App {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        let app = Application(env)
        app.logger.logLevel = .info
        
        defer { app.shutdown() }
        try await configure(app)
        try await app.run()
    }
}
