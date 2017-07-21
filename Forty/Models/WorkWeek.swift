import Cocoa

protocol WorkWeekDelegate {
    func didFetch()
    func didUpdate()
}

class WorkWeek {
    private static let formatter: DateIntervalFormatter = {
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static func thisWeek(delegate: WorkWeekDelegate) -> WorkWeek {
        return WorkWeek(delegate: delegate, date: Date())
    }

    private let monday: Date
    private let friday: Date

    var delegate: WorkWeekDelegate
    var workDays = [WorkDay]()

    var asString: String {
        return WorkWeek.formatter.string(from: monday, to: friday)
    }

    var lastWeek: WorkWeek {
        return WorkWeek(delegate: delegate, date: monday.lastWeek)
    }

    var nextWeek: WorkWeek {
        return WorkWeek(delegate: delegate, date: monday.nextWeek)
    }

    init(delegate: WorkWeekDelegate, date: Date) {
        self.delegate = delegate
        (monday, friday) = Calendar.current.workWeek(from: date)
    }

    func fetch() {
        let number = Calendar.current.component(.weekOfYear, from: monday)
        let year = Calendar.current.component(.year, from: monday)

        let endpoint = Endpoint.showWorkWeek(year: year, number: number)
        Router.hit(endpoint, handler: handleResponse)
    }

    func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard let workDayList = WorkDayList.decode(from: data) else { return }
        workDays = workDayList.workDays
        delegate.didFetch()
    }

    func updateDay(index: Int, attrs: [String: String?]) {
        guard let adjustHours = attrs[.adjustHours],
            let inTime = attrs[.inTime],
            let outTime = attrs[.outTime],
            let ptoHours = attrs[.ptoHours]
            else { fatalError() }

        var workDay = workDays[index]
        workDay.adjustHours = adjustHours
        workDay.inTime = inTime
        workDay.ptoHours = ptoHours
        workDay.outTime = outTime

        Router.hit(.updateWorkDay(workDay: workDay), handler: handleUpdateResponse)
        workDays[index] = workDay
    }

    func handleUpdateResponse(data: Data?, response: URLResponse?, error: Error?) {
        delegate.didUpdate()
    }

    func dayTotal(index: Int) -> String {
        let workDay = workDays[index]
        return TotalHours.daily(workDay: workDay).asString
    }

    func grandTotal() -> String {
        let dailyTotals = workDays.map { TotalHours.daily(workDay: $0).asString }
        return TotalHours.weekly(dailyTotals: dailyTotals).asString
    }

    func pace(date: Date) -> String {
        let relativeTo = date > friday ? friday : date

        let dailyTotals = workDays.map { TotalHours.daily(workDay: $0).asString }
        let grandTotalHours = TotalHours.weekly(dailyTotals: dailyTotals)

        let paceTarget = relativeTo.workWeekDay * 8

        let diff = grandTotalHours - Hours(hours: paceTarget, minutes: 0)

        if diff.asString == Hours.zero.asString {
            return "even"
        } else {
            return diff.asString
        }
    }
}

private extension Calendar {
    func workWeek(from: Date) -> (monday: Date, friday: Date) {
        var components = dateComponents([.year, .weekOfYear], from: from)

        components.hour = 0
        components.minute = 0
        components.second = 0

        let weekdayComponents = [2, 6]

        let days: [Date] = weekdayComponents.flatMap { weekdayComponent in
            components.weekday = weekdayComponent
            return date(from: components)
        }

        return (days.first!, days.last!)
    }
}

private extension Date {
    private static let secondsInWeek = 604800.0

    var lastWeek: Date {
        return addingTimeInterval(-Date.secondsInWeek)
    }

    var nextWeek: Date {
        return addingTimeInterval(Date.secondsInWeek)
    }

    var workWeekDay: Int {
        return Calendar.current.component(.weekday, from: self) - 1
    }
}
