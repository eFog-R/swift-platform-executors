import Testing
import XCTest
@testable import Win32NativeExecutors

@Suite(.serialized) struct Win32ExecutorTests {
  @Test func testEventLoopExecutor() async {
    let eventLoopOK
      = await ExecutorFixture.test(executor: Win32EventLoopExecutor())
    #expect(eventLoopOK)
  }

  @Test func testThreadPoolExecutor() async {
    let threadPoolOK
      = await ExecutorFixture.test(executor: Win32ThreadPoolExecutor())
    #expect(threadPoolOK)
  }
}
