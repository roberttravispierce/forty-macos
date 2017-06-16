import Foundation

struct TotalHours {
    static func daily(inTimeString: String, outTimeString: String, ptoHoursString: String, adjustHoursString: String) -> String {
        let inTime = Time(string: inTimeString)
        let outTime = Time(string: outTimeString)
        let ptoHours = Hours(string: ptoHoursString)
        let adjustHours = Hours(string: adjustHoursString)

        let workedHours = outTime - inTime
        let totalHours = workedHours + ptoHours - adjustHours
        return totalHours.asString
    }

    static func weekly(dailyTotals: [String]) -> String {
        return dailyTotals.map(Hours.init).reduce(Hours.zero, +).asString
    }
}
