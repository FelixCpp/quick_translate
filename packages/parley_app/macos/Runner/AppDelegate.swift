import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  private var menuBarManager: MenuBarManager?

  override func applicationDidFinishLaunching(_ notification: Notification) {
    // No super call: FlutterAppDelegate declares but does not implement this
    // method, so calling super throws `doesNotRecognizeSelector`.
    // Accessory app: no Dock icon, no main window. LSUIElement in Info.plist
    // already covers this; setting it here keeps `flutter run` consistent.
    NSApp.setActivationPolicy(.accessory)
    menuBarManager = MenuBarManager()
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    // The popover is not a window the user "closes"; the app lives in the
    // menu bar until quit explicitly.
    return false
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
