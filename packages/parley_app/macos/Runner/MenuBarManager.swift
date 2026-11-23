import Cocoa
import FlutterMacOS

/// Owns the menu bar icon (`NSStatusItem`) and the popover that hosts the
/// Flutter UI.
///
/// The `FlutterEngine` is created once at launch and lives as long as the app.
/// Closing the popover only hides the view; Dart state (blocs, a loaded model)
/// survives closing and reopening.
///
/// Platform channel `parley/menu_bar`:
///
/// Dart → Swift
/// - `show`                                     opens the popover
/// - `hide`                                     closes the popover
/// - `toggle`                                   toggles the popover
/// - `isShown`            → bool                whether the popover is open
/// - `setContentSize`     {width, height}       resizes the popover (logical px)
/// - `quit`                                     quits the app
///
/// Swift → Dart
/// - `popoverDidShow`     popover is visible and key; focus the input here
/// - `popoverDidClose`    popover was closed (outside click, hide, toggle)
final class MenuBarManager: NSObject {
  static let channelName = "parley/menu_bar"
  static let defaultContentSize = NSSize(width: 420, height: 320)

  let engine: FlutterEngine
  private let flutterViewController: FlutterViewController
  private let channel: FlutterMethodChannel
  private let statusItem: NSStatusItem
  private let popover: NSPopover
  private lazy var contextMenu: NSMenu = makeContextMenu()

  override init() {
    engine = FlutterEngine(name: "parley", project: nil)
    engine.run(withEntrypoint: nil)

    flutterViewController = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    flutterViewController.backgroundColor = .clear
    RegisterGeneratedPlugins(registry: engine)

    channel = FlutterMethodChannel(
      name: MenuBarManager.channelName,
      binaryMessenger: engine.binaryMessenger
    )

    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    popover = NSPopover()

    super.init()

    configurePopover()
    configureStatusItem()
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
  }

  // MARK: - Setup

  private func configurePopover() {
    popover.contentViewController = flutterViewController
    popover.contentSize = MenuBarManager.defaultContentSize
    popover.behavior = .transient
    popover.animates = true
    popover.delegate = self
  }

  private func configureStatusItem() {
    guard let button = statusItem.button else { return }
    let image = NSImage(
      systemSymbolName: "character.bubble",
      accessibilityDescription: "Parley"
    )
    image?.isTemplate = true
    button.image = image
    button.toolTip = "Parley"
    button.target = self
    button.action = #selector(statusItemClicked(_:))
    button.sendAction(on: [.leftMouseUp, .rightMouseUp])
  }

  private func makeContextMenu() -> NSMenu {
    let menu = NSMenu()
    let quitItem = NSMenuItem(
      title: "Parley beenden",
      action: #selector(quit),
      keyEquivalent: "q"
    )
    quitItem.target = self
    menu.addItem(quitItem)
    return menu
  }

  // MARK: - Status item

  @objc private func statusItemClicked(_ sender: NSStatusBarButton) {
    let event = NSApp.currentEvent
    let isSecondaryClick =
      event?.type == .rightMouseUp || event?.modifierFlags.contains(.control) == true

    if isSecondaryClick {
      hidePopover()
      // Temporarily attach the menu so it drops down from the icon like a
      // native status menu, then detach so left clicks reach the action again.
      statusItem.menu = contextMenu
      sender.performClick(nil)
      statusItem.menu = nil
    } else {
      togglePopover()
    }
  }

  // MARK: - Popover

  var isPopoverShown: Bool { popover.isShown }

  func showPopover() {
    guard !popover.isShown, let button = statusItem.button else { return }

    if #available(macOS 14.0, *) {
      NSApp.activate()
    } else {
      NSApp.activate(ignoringOtherApps: true)
    }
    popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    popover.contentViewController?.view.window?.makeKey()
  }

  func hidePopover() {
    guard popover.isShown else { return }
    popover.performClose(nil)
  }

  func togglePopover() {
    popover.isShown ? hidePopover() : showPopover()
  }

  @objc private func quit() {
    NSApp.terminate(nil)
  }

  // MARK: - Channel

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "show":
      showPopover()
      result(nil)
    case "hide":
      hidePopover()
      result(nil)
    case "toggle":
      togglePopover()
      result(nil)
    case "isShown":
      result(popover.isShown)
    case "setContentSize":
      guard
        let args = call.arguments as? [String: Any],
        let width = (args["width"] as? NSNumber)?.doubleValue,
        let height = (args["height"] as? NSNumber)?.doubleValue,
        width > 0, height > 0
      else {
        result(
          FlutterError(
            code: "invalid_arguments",
            message: "setContentSize expects {width: num, height: num} > 0",
            details: call.arguments
          )
        )
        return
      }
      popover.contentSize = NSSize(width: width, height: height)
      result(nil)
    case "quit":
      result(nil)
      quit()
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

// MARK: - NSPopoverDelegate

extension MenuBarManager: NSPopoverDelegate {
  func popoverDidShow(_ notification: Notification) {
    channel.invokeMethod("popoverDidShow", arguments: nil)
  }

  func popoverDidClose(_ notification: Notification) {
    channel.invokeMethod("popoverDidClose", arguments: nil)
  }
}
