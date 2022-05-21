
import XCTest
@testable import NewsUpdate

class NewsUpdateTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testInvalidUrlInNetworkService() {
        let service = NetworkService()
        let url : String = "invalidUrl"
        service.readData(fromURLStr: url, type: ArticlesModel.self) { news, error in
            XCTAssertNil(news)
            XCTAssertTrue(error == .invalidUrlError)
        }
    }
    func testNetworkServiceAPICallWithInvalidUrl()  {
        let service = NetworkService()
        let url : String = "https://www.google.com/"
        let expectation = self.expectation(
          description: "Testing Invalid Server URL")
        service.readData(fromURLStr: url, type: ArticlesModel.self) { news, error in
            XCTAssertNil(news)
            XCTAssertTrue(error == .jsonConversionError)
            expectation.fulfill()

        }
        waitForExpectations(timeout: 20, handler: nil)

    }
    func testNetworkServiceAPICallWithValidUrl()  {
        let service = NetworkService()
        let url : String = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=763537cab3ad430da1e281d41fb2d44f"
        let expectation = self.expectation(
          description: "Testing Valid Server URL")
        service.readData(fromURLStr: url, type: ArticlesModel.self) { news, error in
            XCTAssertNil(error)
            XCTAssertNotNil(news)
            let count = news?.articles.count ?? 0
            XCTAssertTrue(count > 0)
            expectation.fulfill()

        }
        waitForExpectations(timeout: 20, handler: nil)

    }
    func testModels() {
        let expectation = self.expectation(
          description: "Testing Models")
        guard let filePath = Bundle(for: type(of: self)).path(forResource: "Articles", ofType: "json") else {
            XCTAssertFalse(true)
            return
        }
        let fileUrl = URL(fileURLWithPath: filePath)
        do {
            let data = try Data(contentsOf: fileUrl)
            JsonResponseParser().convertJson(data: data, type: ArticlesModel.self) { responseData, error in
                XCTAssertNotNil(responseData)
                guard let responseData = responseData else {
                    return
                }
                XCTAssertTrue(responseData.totalResults == 10)
                XCTAssertTrue(responseData.articles.count == 10)
                XCTAssertTrue(responseData.articles[0].source?.id == "techcrunch")
                expectation.fulfill()
                
            }
        } catch let error {
            XCTAssertTrue(false)
            print(error.localizedDescription)
        }
        waitForExpectations(timeout: 20, handler: nil)

    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
