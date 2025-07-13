//
//  TapServerUITests.swift
//  TapServerUITests
//
//  Created by Abhijeet Pate on 11/07/25.
//

import XCTest
import GCDWebServer

final class TapServerUITests: XCTestCase {
    
    var server: GCDWebServer!
    var startTime: Date!
    var requestCount = 0
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        server = GCDWebServer()
                startTime = Date()
                setupHandlers()
                try? server.start(options: [
                    GCDWebServerOption_Port: 8100,
                    GCDWebServerOption_BindToLocalhost: true
                ])
                print("✅ Server started at http://localhost:8100")
                RunLoop.main.run() // Keep test alive
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func setupHandlers() {
            server.addHandler(forMethod: "POST", path: "/tap", request: GCDWebServerDataRequest.self) { request, completion in
                self.requestCount += 1
                guard let dataRequest = request as? GCDWebServerDataRequest else {
                    return completion(self.errorResponse(code: "INVALID_JSON", message: "Invalid request format"))
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: dataRequest.data) as? [String: Any]
                    guard let x = json?["x"] as? CGFloat,
                          let y = json?["y"] as? CGFloat else {
                        return completion(self.errorResponse(code: "MISSING_COORDINATES", message: "x or y missing"))
                    }
                    let app = XCUIApplication()
                    app.launch()
                    let coordinate = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
                        .withOffset(CGVector(dx: x, dy: y))
                    coordinate.tap()
                    completion(GCDWebServerDataResponse(jsonObject: [
                        "status": "success",
                        "message": "Tap executed at coordinates (\(x), \(y))",
                        "timestamp": ISO8601DateFormatter().string(from: Date())
                    ]))
                } catch {
                    return completion(self.errorResponse(code: "INVALID_JSON", message: "Malformed JSON"))
                }
            }

            server.addHandler(forMethod: "GET", path: "/health", request: GCDWebServerRequest.self) { _, completion in
                let uptime = Int(Date().timeIntervalSince(self.startTime))
                completion(GCDWebServerDataResponse(jsonObject: [
                    "status": "running",
                    "uptime_seconds": uptime,
                    "requests_handled": self.requestCount
                ]))
            }

            server.addHandler(forMethod: "GET", path: "/info", request: GCDWebServerRequest.self) { _, completion in
                completion(GCDWebServerDataResponse(jsonObject: [
                    "server_version": "1.0.0",
                    "supported_endpoints": ["/tap", "/health", "/info"],
                    "screen_dimensions": [
                        "width": UIScreen.main.bounds.width,
                        "height": UIScreen.main.bounds.height
                    ]
                ]))
            }
        }
        
        private func errorResponse(code: String, message: String) -> GCDWebServerDataResponse {
            return GCDWebServerDataResponse(jsonObject: [
                "status": "error",
                "error_code": code,
                "message": message,
                "timestamp": ISO8601DateFormatter().string(from: Date())
            ])!
        }
    
    /*@MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }*/
    func testServerRunner() {
        do {
            try setUpWithError()
        } catch {
            XCTFail("Failed to start server")
        }
    }


    /*@MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }*/
}
