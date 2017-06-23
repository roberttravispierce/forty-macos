import Cocoa

class TimeEntryTextField: NSTextField {
    func redraw(string: String?) {
        stringValue = string ?? ""
    }
}

class InTextField: TimeEntryTextField {}
class OutTextField: TimeEntryTextField {}
class PtoTextField: TimeEntryTextField {}
class AdjustTextField: TimeEntryTextField {}
class TotalTextField: NSTextField {}

class DayStack: NSStackView {
    var workDay: WorkDay! {
        didSet {
            redraw()
        }
    }

    var timeEntryTextFields: [TimeEntryTextField] {
        return subviews.flatMap { $0 as? TimeEntryTextField }
    }

    var inTextField: InTextField {
        guard let field = subviews.flatMap({ $0 as? InTextField }).first
            else { fatalError() }
        return field
    }

    var outTextField: OutTextField {
        guard let field = subviews.flatMap({ $0 as? OutTextField }).first
            else { fatalError() }
        return field
    }

    var ptoTextField: PtoTextField {
        guard let field = subviews.flatMap({ $0 as? PtoTextField }).first
            else { fatalError() }
        return field
    }

    var adjustTextField: AdjustTextField {
        guard let field = subviews.flatMap({ $0 as? AdjustTextField }).first
            else { fatalError() }
        return field
    }

    var totalTextField: TotalTextField {
        guard let field = subviews.flatMap({ $0 as? TotalTextField }).first
            else { fatalError() }
        return field
    }

    func redraw() {
        inTextField.redraw(string: workDay.inTime)
        outTextField.redraw(string: workDay.outTime)
        ptoTextField.redraw(string: workDay.ptoHours)
        adjustTextField.redraw(string: workDay.adjustHours)
    }
}
