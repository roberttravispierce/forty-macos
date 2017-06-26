import Foundation

func +(lhs: Hours, rhs: Hours) -> Hours {
    guard let lhsHours = lhs.hours,
        let lhsMinutes = lhs.minutes,
        let rhsHours = rhs.hours,
        let rhsMinutes = rhs.minutes
        else { return lhs.isValid ? lhs : Hours.zero }

    var hours = lhsHours + rhsHours
    var minutes = lhsMinutes + rhsMinutes

    if minutes >= 60 {
        let extra = minutes / 60
        hours += extra
        minutes = minutes % 60
    }

    return Hours(hours: hours, minutes: minutes)
}

func -(lhs: Hours, rhs: Hours) -> Hours {
    guard let lhsHours = lhs.hours,
        let lhsMinutes = lhs.minutes,
        let rhsHours = rhs.hours,
        let rhsMinutes = rhs.minutes
        else { return lhs.isValid ? lhs : Hours.zero }

    var hours = lhsHours - rhsHours
    guard hours > 0 else { return Hours.zero }

    var minutes = lhsMinutes - rhsMinutes

    if minutes < 0 {
        hours -= 1
        minutes = minutes + 60
    }

    return Hours(hours: hours, minutes: minutes)
}

class Time: Hours {}

class Hours {
    let hours: Int?
    let minutes: Int?

    static var zero: Hours {
        return Hours(string: nil)
    }

    var isValid: Bool {
        return hours != nil && minutes != nil
    }

    var asString: String {
        guard let hours = hours,
            let minutes = minutes
            else { return Hours.zero.asString }

        let minuteString = minutes < 10 ? "0\(minutes)" : String(minutes)
        return "\(hours):\(minuteString)"
    }

    init(hours: Int?, minutes: Int?) {
        self.hours = hours
        self.minutes = minutes
    }

    convenience init(string: String?) {
        let hours = string?.hours ?? 0
        let minutes = string?.minutes ?? 0
        self.init(hours: hours, minutes: minutes)
    }
}

private extension String.CharacterView.SubSequence {
    var asInt: Int? {
        return Int(String(self))
    }
}

private extension String {
    var timeParts: [String.CharacterView.SubSequence] {
        return characters.split(separator: ":")
    }

    var hours: Int? {
        guard let hoursPlace = timeParts.first,
            let hoursAsInt = hoursPlace.asInt
            else { return nil }
        return hoursAsInt
    }

    var minutes: Int? {
        guard let minutesPlace = timeParts.last,
            let minutesAsInt = minutesPlace.asInt
            else { return nil }
        return minutesAsInt
    }
}
