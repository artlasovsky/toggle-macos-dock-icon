//
//  App.swift
//  toggle-dock-icon
//
//  Created by Art Lasovsky on 25/08/2024.
//

import SwiftUI

@main
struct ToggleDockIconApp: App {
    @NSApplicationDelegateAdaptor private var delegate: ApplicationDelegate
    
    var body: some Scene {
        MenuBarExtra("ToggleDock") {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var counter: Int = 0
    var body: some View {
        VStack {
            Button("Hide or Show Dock Icon") {
                NSApplication.toggleActivationPolicy()
            }
            /// The app's window should remain active even when the dock icon is hidden or shown.
            /// Keyboard events will continue to function.
            HStack {
                Text(counter.description)
                Button("⌥ + b") { counter += 1 }
                    .keyboardShortcut("b", modifiers: .option)
            }
        }
    }
}
