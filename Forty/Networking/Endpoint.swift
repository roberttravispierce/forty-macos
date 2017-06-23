import Foundation

enum Endpoint {
    case showWorkWeek(year: Int, number: Int)
    case updateWorkDay(workDay: WorkDay)

    var data: Data? {
        switch self {
        case .updateWorkDay(let workDay):
            return try? JSONEncoder().encode(workDay)
        default:
            return nil
        }
    }

    var method: String {
        switch self {
        case .showWorkWeek:
            return "GET"
        case .updateWorkDay:
            return "PATCH"
        }
    }

    var path: String {
        switch self {
        case .showWorkWeek(let year, let number):
            return "/work_weeks/\(year)/\(number)"
        case .updateWorkDay(let workDay):
            return "/work_days/\(workDay.id)"
        }
    }
}
