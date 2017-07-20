import Foundation

struct TotalHours {
    static func daily(workDay: WorkDay) -> Hours {
        let inTime = Time(string: workDay.inTime)
        let outTime = Time(string: workDay.outTime)
        let ptoHours = Hours(string: workDay.ptoHours)
        let adjustHours = Hours(string: workDay.adjustHours)

        let workedHours = outTime - inTime
        let totalHours = workedHours + ptoHours - adjustHours
        return totalHours
    }

    static func weekly(dailyTotals: [String]) -> Hours {
        return dailyTotals.map(Hours.init).reduce(Hours.zero, +)
    }
}
