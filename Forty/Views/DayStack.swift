import Cocoa

protocol AttrTextField {
    var attrKey: WorkDay.CodingKeys { get }
    var attrValue: String? { get }
    var stringValue: String { get set }
}

extension AttrTextField {
    var attrValue: String? {
        return stringValue == "" ? nil : stringValue
    }
}

class TimeEntryTextField: NSTextField {
    func redraw(string: String?) {
        stringValue = string ?? ""
    }
}

class InTextField: TimeEntryTextField, AttrTextField {
    var attrKey = WorkDay.CodingKeys.inTime
}

class OutTextField: TimeEntryTextField, AttrTextField {
    var attrKey = WorkDay.CodingKeys.outTime
}

class PtoTextField: TimeEntryTextField, AttrTextField {
    var attrKey = WorkDay.CodingKeys.ptoHours
}

class AdjustTextField: TimeEntryTextField, AttrTextField {
    var attrKey = WorkDay.CodingKeys.adjustHours
}

class TotalTextField: NSTextField {}

class DayStack: NSStackView {
    var workDay: WorkDay! {
        didSet {
            redraw()
        }
    }

    var attrs: [String: String?] {
        let fields = timeEntryTextFields.flatMap { $0 as? AttrTextField }
        var fieldAttrs = [String: String?]()
        fields.forEach { fieldAttrs[$0.attrKey] = $0.attrValue }

        return fieldAttrs
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
