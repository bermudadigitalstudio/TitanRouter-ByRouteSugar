import XCTest
import TitanRouterMethodSugar
import TitanCore

extension String: ResponseType {
  public var body: String {
    return self
  }

  public var code: Int {
    return 200
  }

  public var headers: [Header] {
    return []
  }
}

extension Int: ResponseType {
  public var code: Int { return self }
  public var body: String { return "" }
  public var headers: [Header] { return [] }
}

class TitanRouter_ByRouteSugarTests: XCTestCase {
  var app: Titan!
  override func setUp() {
    app = Titan()
  }

  func testBasicGet() {
    app.get(path: "/username") { req, _ in
      return (req, "swizzlr")
    }
    XCTAssertEqual(app.app(request: Request("GET", "/username")).body, "swizzlr")
  }

  func testTitanEcho() {
    app.get(path: "/echoMyBody") { req, _ in
      return (req, req.body)
    }
    XCTAssertEqual(app.app(request: Request("GET", "/echoMyBody", "hello, this is my body")).body,
                   "hello, this is my body")
  }

  func testMultipleRoutes() {
    app.get(path: "/username") { req, _ in
      return (req, "swizzlr")
    }

    app.get(path: "/echoMyBody") { req, _ in
      return (req, req.body)
    }
    XCTAssertEqual(app.app(request: Request("GET", "/echoMyBody", "hello, this is my body")).body,
                   "hello, this is my body")
    XCTAssertEqual(app.app(request: Request("GET", "/username")).body, "swizzlr")
  }

  func testDifferentMethods() {
    app.get(path: "/getSomething") { req, _ in
      return (req, "swizzlrGotSomething!")
    }

    app.post(path: "/postSomething") { req, _ in
      return (req, "something posted")
    }

    app.put(path: "/putSomething") { req, _ in
      return (req, "i can confirm that stupid stuff is now on the server")
    }

    app.patch(path: "/patchSomething") { req, _ in
      return (req, "i guess we don't have a flat tire anymore?")
    }

    app.delete(path: "/deleteSomething") { req, _ in
      return (req, "error: could not find the USA or its principles")
    }

    app.options(path: "/optionSomething") { req, _ in
      return (req, "I sold movie rights!")
    }

    app.head(path: "/headSomething") { req, _ in
      return (req, "OWN GOAL!!")
    }

  }

  func testSamePathDifferentiationByMethod() {
    var username = ""

    app.get(path: "/username") { req, _ in
      return (req, username)
    }

    app.post(path: "/username") { req, _ in
      username = req.body
      return (req, 201)
    }

    let resp = app.app(request: Request("POST", "/username", "Lisa"))
    XCTAssertEqual(resp.code, 201)
    XCTAssertEqual(app.app(request: Request("GET", "/username")).body, "Lisa")
  }

}
