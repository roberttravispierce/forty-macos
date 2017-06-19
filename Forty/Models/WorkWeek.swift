import Cocoa

protocol WorkWeekDelegate {
    func didFetch()
}

class WorkWeek {
    private static let formatter: DateIntervalFormatter = {
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    // i'm suspicious of this property - seems like the only reason i need it now
    // is to help asString work out what should be returned and that could easily
    // come another way
    private let dates: [Date]

    private var monday: Date {
        return dates.first!
    }

    private var friday: Date {
        return dates.last!
    }

    static func thisWeek(delegate: WorkWeekDelegate) -> WorkWeek {
        return WorkWeek(delegate: delegate, date: Date())
    }

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
        dates = Calendar.current.weekdays(lol: date)
    }

    func fetch() {
        let number = Calendar.current.component(.weekOfYear, from: monday)
        let year = Calendar.current.component(.year, from: monday)

        let endpoint = Endpoint.showWorkWeek(year: year, number: number)
        Router.hit(endpoint, handler: handleResponse)
    }

    func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard let data = data,
            let object = try? JSONSerialization.jsonObject(with: data),
            let json = object as? [String: Any],
            let workDayAttrs = json["work_days"] as? [[String: Any]]
            else { return }

        workDays = workDayAttrs.flatMap { WorkDay($0) }
        delegate.didFetch()
    }

    func updateWeek(workDay: WorkDay) {
        Router.hit(.updateWorkDay(workDay: workDay))
    }
}

private extension Calendar {
    func weekdays(lol: Date) -> [Date] {
        var components = dateComponents([.year, .weekOfYear], from: lol)

        components.hour = 0
        components.minute = 0
        components.second = 0

        let weekdays = [2, 3, 4, 5, 6]

        return weekdays.flatMap { weekday in
            components.weekday = weekday
            return date(from: components)
        }
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
}
