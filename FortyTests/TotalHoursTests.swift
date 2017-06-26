import XCTest
@testable import Forty

class TotalHoursTests: XCTestCase {
    func testNormalDay() {
        let workDay = WorkDay(
            id: 1,
            date: Date(),
            adjustHours: nil,
            inTime: "9:00",
            outTime: "17:00",
            ptoHours: nil
        )

        let totalHours = TotalHours.daily(workDay: workDay)

        XCTAssertEqual(totalHours, "8:00")
    }

    func testEarlyOut() {
        let workDay = WorkDay(
            id: 1,
            date: Date(),
            adjustHours: nil,
            inTime: "9:00",
            outTime: "11:00",
            ptoHours: nil
        )

        let totalHours = TotalHours.daily(workDay: workDay)

        XCTAssertEqual(totalHours, "2:00")
    }

    func testLateIn() {
        let workDay = WorkDay(
            id: 1,
            date: Date(),
            adjustHours: nil,
            inTime: "15:00",
            outTime: "17:00",
            ptoHours: nil
        )

        let totalHours = TotalHours.daily(workDay: workDay)

        XCTAssertEqual(totalHours, "2:00")
    }

    func testInvalidTimes() {
        let workDay = WorkDay(
            id: 1,
            date: Date(),
            adjustHours: "lol",
            inTime: "asdf",
            outTime: "qwer",
            ptoHours: "omg"
        )

        let totalHours = TotalHours.daily(workDay: workDay)

        XCTAssertEqual(totalHours, "0:00")
    }

    func testInvalidOut() {
        let workDay = WorkDay(
            id: 1,
            date: Date(),
            adjustHours: nil,
            inTime: "9:00",
            outTime: "5:00",
            ptoHours: nil
        )

        let totalHours = TotalHours.daily(workDay: workDay)

        XCTAssertEqual(totalHours, "0:00")
    }

    func testPTO() {
        let workDay = WorkDay(
            id: 1,
            date: Date(),
            adjustHours: nil,
            inTime: "10:00",
            outTime: "17:00",
            ptoHours: "1:00"
        )

        let totalHours = TotalHours.daily(workDay: workDay)

        XCTAssertEqual(totalHours, "8:00")
    }

    func testAdjustment() {
        let workDay = WorkDay(
            id: 1,
            date: Date(),
            adjustHours: "0:30",
            inTime: "9:00",
            outTime: "17:30",
            ptoHours: nil
        )

        let totalHours = TotalHours.daily(workDay: workDay)

        XCTAssertEqual(totalHours, "8:00")
    }

    func testExtraMinutes() {
        let workDay = WorkDay(
            id: 1,
            date: Date(),
            adjustHours: "2:00",
            inTime: "9:00",
            outTime: "19:45",
            ptoHours: "0:15"
        )

        let totalHours = TotalHours.daily(workDay: workDay)

        XCTAssertEqual(totalHours, "9:00")
    }

    func testNegativeMinutes() {
        let workDay = WorkDay(
            id: 1,
            date: Date(),
            adjustHours: "0:45",
            inTime: "8:15",
            outTime: "16:00",
            ptoHours: "0:30"
        )

        let totalHours = TotalHours.daily(workDay: workDay)

        XCTAssertEqual(totalHours, "7:30")
    }

    func testVacationDay() {
        let workDay = WorkDay(
            id: 1,
            date: Date(),
            adjustHours: nil,
            inTime: nil,
            outTime: nil,
            ptoHours: "8:00"
        )

        let totalHours = TotalHours.daily(workDay: workDay)

        XCTAssertEqual(totalHours, "8:00")
    }
}
