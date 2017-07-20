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

    func testUnderPace() {
        let monday = dateFromString(string: "2017-01-02")
        let week = WorkWeek(delegate: MockWorkWeekDelegate(), date: monday)
        XCTAssertEqual(week.pace(date: monday), "-8:00")
    }

    func testEvenPace() {
        let monday = dateFromString(string: "2017-01-02")
        let workDay = WorkDay(id: 1, date: Date(), adjustHours: nil, inTime: nil, outTime: nil, ptoHours: "8:00")
        let week = WorkWeek(delegate: MockWorkWeekDelegate(), date: monday)
        week.workDays.append(workDay)
        XCTAssertEqual(week.pace(date: monday), "even")
    }

    func testOverPace() {
        let monday = dateFromString(string: "2017-01-02")
        let workDay = WorkDay(id: 1, date: Date(), adjustHours: nil, inTime: "8:00", outTime: "17:00", ptoHours: nil)
        let week = WorkWeek(delegate: MockWorkWeekDelegate(), date: monday)
        week.workDays.append(workDay)
        XCTAssertEqual(week.pace(date: monday), "1:00")
    }

    func testEvenPaceWithFullWeek() {
        let friday = dateFromString(string: "2017-01-06")
        let workDays = [
            WorkDay(id: 1, date: Date(), adjustHours: nil, inTime: "9:00", outTime: "17:00", ptoHours: nil),
            WorkDay(id: 2, date: Date(), adjustHours: nil, inTime: "9:00", outTime: "17:00", ptoHours: nil),
            WorkDay(id: 3, date: Date(), adjustHours: nil, inTime: "9:00", outTime: "17:00", ptoHours: nil),
            WorkDay(id: 4, date: Date(), adjustHours: nil, inTime: "9:00", outTime: "17:00", ptoHours: nil),
            WorkDay(id: 5, date: Date(), adjustHours: nil, inTime: "9:00", outTime: "17:00", ptoHours: nil)
            ]
        let week = WorkWeek(delegate: MockWorkWeekDelegate(), date: friday)
        week.workDays = workDays
        XCTAssertEqual(week.pace(date: friday), "even")
    }

    func testEvenPaceWithWeekInPast() {
        let friday = dateFromString(string: "2017-01-06")
        let workDays = [
            WorkDay(id: 1, date: Date(), adjustHours: nil, inTime: "9:00", outTime: "17:00", ptoHours: nil),
            WorkDay(id: 2, date: Date(), adjustHours: nil, inTime: "9:00", outTime: "17:00", ptoHours: nil),
            WorkDay(id: 3, date: Date(), adjustHours: nil, inTime: "9:00", outTime: "17:00", ptoHours: nil),
            WorkDay(id: 4, date: Date(), adjustHours: nil, inTime: "9:00", outTime: "17:00", ptoHours: nil),
            WorkDay(id: 5, date: Date(), adjustHours: nil, inTime: "9:00", outTime: "17:00", ptoHours: nil)
        ]
        let week = WorkWeek(delegate: MockWorkWeekDelegate(), date: friday)
        week.workDays = workDays
        let omg = dateFromString(string: "2017-01-10")
        XCTAssertGreaterThan(omg, friday)
        XCTAssertEqual(week.pace(date: omg), "even")
    }
}
