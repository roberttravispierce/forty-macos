import XCTest
@testable import Forty

class MockWorkWeekDelegate: WorkWeekDelegate {
    func didFetch() {}
}

class WorkWeekTests: XCTestCase {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private func dateFromString(string: String) -> Date {
        return WorkWeekTests.formatter.date(from: string)!
    }

    func testAsString() {
        let date = dateFromString(string: "2016-05-26")
        let week = WorkWeek(delegate: MockWorkWeekDelegate(), date: date)
        XCTAssertEqual(week.asString, "May 23 - 27, 2016")
    }

    func testAsStringAcrossMonth() {
        let date = dateFromString(string: "2016-06-02")
        let week = WorkWeek(delegate: MockWorkWeekDelegate(), date: date)
        XCTAssertEqual(week.asString, "May 30 - Jun 3, 2016")
    }

    func testAsStringAcrossYear() {
        let date = dateFromString(string: "2016-01-01")
        let week = WorkWeek(delegate: MockWorkWeekDelegate(), date: date)
        XCTAssertEqual(week.asString, "Dec 28, 2015 - Jan 1, 2016")
    }

    func testLastWeek() {
        let date = dateFromString(string: "2016-05-26")
        let lastWeekDate = dateFromString(string: "2016-05-19")
        let week = WorkWeek(delegate: MockWorkWeekDelegate(), date: date)
        XCTAssertEqual(week.lastWeek.asString, WorkWeek(delegate: MockWorkWeekDelegate(), date: lastWeekDate).asString)
    }

    func testNextWeek() {
        let date = dateFromString(string: "2016-05-19")
        let nextWeekDate = dateFromString(string: "2016-05-26")
        let week = WorkWeek(delegate: MockWorkWeekDelegate(), date: date)
        XCTAssertEqual(week.nextWeek.asString, WorkWeek(delegate: MockWorkWeekDelegate(), date: nextWeekDate).asString)
    }
}
