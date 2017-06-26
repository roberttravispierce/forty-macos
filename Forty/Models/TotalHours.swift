import Foundation

struct TotalHours {
    static func daily(workDay: WorkDay) -> String {
        let inTime = Time(string: workDay.inTime)
        let outTime = Time(string: workDay.outTime)
        let ptoHours = Hours(string: workDay.ptoHours)
        let adjustHours = Hours(string: workDay.adjustHours)

        let workedHours = outTime - inTime
        let totalHours = workedHours + ptoHours - adjustHours
        return totalHours.asString
    }

    static func weekly(dailyTotals: [String]) -> String {
        return dailyTotals.map(Hours.init).reduce(Hours.zero, +).asString
    }
}
