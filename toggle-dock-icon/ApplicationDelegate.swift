//
//  ApplicationDelegate.swift
//  toggle-dock-icon
//
//  Created by Art Lasovsky on 25/08/2024.
//

import SwiftUI

/// # Note: Xcode Debug Mode Behavior
/// When running the app in debug mode, Xcode windows will take precedence over the app's windows. 
/// As a result, even after calling `NSApp.activate()` or `NSWindow.makeKeyAndOrderFront()`, the app's windows will remain behind the Xcode windows.
///
/// However, this issue only occurs when Xcode is the active application behind our app. 
/// If a different application is in the background, the app's windows will behave as expected.


/// # Info.plist
/// Property `Application is agent (UIElement)` with the value `YES` should be added to `info.plist`

class ApplicationDelegate: NSObject, NSApplicationDelegate {
    /// This could be stored in `UserDefaults`
    let defaultActivationPolicy: NSApplication.ActivationPolicy = .regular
    
    /// Setting activation policy to `.prohibited` to prevent it from stealing the current app's focus
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(.prohibited)
    }
    /// Setting desired activation policy (`.regular` or `.accessory`) and showing app's windows
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(defaultActivationPolicy)
        WindowManager.shared.show()
    }
}

extension NSApplication {
    private static var isSettingActivationPolicy = false
    
    static func toggleActivationPolicy() {
        if isSettingActivationPolicy {
            return
        }
        isSettingActivationPolicy = true

        let currentActivationPolicy = NSApp.activationPolicy()
        let newActivationPolicy: NSApplication.ActivationPolicy = currentActivationPolicy == .regular ? .accessory : .regular
        
        NSApp.setActivationPolicy(newActivationPolicy)
        /// After setting `.accessory` mode the app is deactivating itself, so we need to make it active again.
        if newActivationPolicy == .accessory {
            NSApp.activate()
        }
        /// Wait until the dock icon's appearance/disappearance animation completes before allowing to toggle it again.
        /// Otherwise, there is a chance of having multiple app icons in the dock :)
        Task {
            try? await Task.sleep(nanoseconds: NSEC_PER_MSEC * 150)
            isSettingActivationPolicy = false
        }
    }
}


/// Basic Window Manager
///
/// Given the `.prohibited` activation policy, SwiftUI won't open windows defined in App upon launch.
/// Nonetheless, you can define windows using `WindowGroup` and `Window`, then open them manually post-launch.
///
/// In this example, I utilized a basic `WindowManager` and displayed the window during the `applicationDidFinishLaunching` phase.
class WindowManager {
    let window: NSWindow
    
    static var shared = WindowManager()
    
    init() {
        window = NSWindow()
        window.styleMask = [.closable, .titled]
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: ContentView().frame(width: 300, height: 300))
        window.center()
    }
    
    func show() {
        window.makeKeyAndOrderFront(nil)
    }
    
    func close() {
        window.close()
    }
}
