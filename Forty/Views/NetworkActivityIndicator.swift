import Cocoa

class NetworkActivityIndicator: NSBox {
    var activity = false {
        didSet {
            if activity {
                animateDown()
            }
        }
    }

    var heightConstraint: NSLayoutConstraint {
        return constraints.first!
    }

    private func animateDown() {
        guard activity == true else { return }
        animateHeight(to: 4, then: pulseDown)
    }

    private func pulseDown() {
        if activity {
            animateHeight(to: 6, then: pulseUp)
        } else {
            animateUp()
        }
    }

    private func pulseUp() {
        if activity {
            animateHeight(to: 4, then: pulseDown)
        } else {
            animateUp()
        }
    }

    private func animateUp() {
        animateHeight(to: 0)
    }

    private func animateHeight(to: CGFloat, then: (() -> Void)? = nil) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.1
            heightConstraint.animator().constant = to
        }, completionHandler: then)
    }
}
