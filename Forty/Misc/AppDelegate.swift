import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let mainWindow = NSApplication.shared.mainWindow else { fatalError() }
        mainWindow.titleVisibility = .hidden
        mainWindow.titlebarAppearsTransparent = true
    }
}
