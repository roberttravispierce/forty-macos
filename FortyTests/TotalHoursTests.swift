import XCTest
@testable import Forty

class TotalHoursTests: XCTestCase {
    func testNormalDay() {
        let inTime = "9:00"
        let outTime = "17:00"

        let totalHours = TotalHours.daily(
            inTimeString: inTime,
            outTimeString: outTime,
            ptoHoursString: "",
            adjustHoursString: ""
        )

        XCTAssertEqual(totalHours, "8:00")
    }

    func testEarlyOut() {
        let inTime = "9:00"
        let outTime = "11:00"

        let totalHours = TotalHours.daily(
            inTimeString: inTime,
            outTimeString: outTime,
            ptoHoursString: "",
            adjustHoursString: ""
        )

        XCTAssertEqual(totalHours, "2:00")
    }

    func testLateIn() {
        let inTime = "15:00"
        let outTime = "17:00"

        let totalHours = TotalHours.daily(
            inTimeString: inTime,
            outTimeString: outTime,
            ptoHoursString: "",
            adjustHoursString: ""
        )

        XCTAssertEqual(totalHours, "2:00")
    }

    func testInvalidTimes() {
        let inTime = "asdf"
        let outTime = "qwer"
        let ptoTime = "omg"
        let adjustTime = "lol"

        let totalHours = TotalHours.daily(
            inTimeString: inTime,
            outTimeString: outTime,
            ptoHoursString: ptoTime,
            adjustHoursString: adjustTime
        )

        XCTAssertEqual(totalHours, "0:00")
    }

    func testInvalidOut() {
        let inTime = "9:00"
        let outTime = "5:00"

        let totalHours = TotalHours.daily(
            inTimeString: inTime,
            outTimeString: outTime,
            ptoHoursString: "",
            adjustHoursString: ""
        )

        XCTAssertEqual(totalHours, "0:00")
    }

    func testPTO() {
        let inTime = "10:00"
        let outTime = "17:00"
        let ptoTime = "1:00"

        let totalHours = TotalHours.daily(
            inTimeString: inTime,
            outTimeString: outTime,
            ptoHoursString: ptoTime,
            adjustHoursString: ""
        )

        XCTAssertEqual(totalHours, "8:00")
    }

    func testAdjustment() {
        let inTime = "9:00"
        let outTime = "17:30"
        let ptoTime = ""
        let adjustTime = "0:30"

        let totalHours = TotalHours.daily(
            inTimeString: inTime,
            outTimeString: outTime,
            ptoHoursString: ptoTime,
            adjustHoursString: adjustTime
        )

        XCTAssertEqual(totalHours, "8:00")
    }

    func testExtraMinutes() {
        let inTime = "9:00"
        let outTime = "19:45"
        let ptoTime = "0:15"
        let adjustTime = "2:00"

        let totalHours = TotalHours.daily(
            inTimeString: inTime,
            outTimeString: outTime,
            ptoHoursString: ptoTime,
            adjustHoursString: adjustTime
        )

        XCTAssertEqual(totalHours, "9:00")
    }

    func testNegativeMinutes() {
        let inTime = "8:15"
        let outTime = "16:00"
        let ptoTime = "0:30"
        let adjustTime = "0:45"

        let totalHours = TotalHours.daily(
            inTimeString: inTime,
            outTimeString: outTime,
            ptoHoursString: ptoTime,
            adjustHoursString: adjustTime
        )

        XCTAssertEqual(totalHours, "7:30")
    }

    func testVacationDay() {
        let inTime = ""
        let outTime = ""
        let ptoTime = "8:00"
        let adjustTime = ""

        let totalHours = TotalHours.daily(
            inTimeString: inTime,
            outTimeString: outTime,
            ptoHoursString: ptoTime,
            adjustHoursString: adjustTime
        )

        XCTAssertEqual(totalHours, "8:00")
    }
}
