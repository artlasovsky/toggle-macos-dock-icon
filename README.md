# Toggle Dock Icon App

## Overview
This SwiftUI app demonstrates how to dynamically toggle the visibility of the dock icon in macOS.

## Features
- Toggle dock icon visibility
- Persist app window even when dock icon is hidden

## Important
Do not forget to add `Application is agent (UIElement)` property with value `YES` to `Info.plist`

## Note
When running the app in debug mode, Xcode windows will take precedence over the app's windows.
As a result, even after calling NSApp.activate() or NSWindow.makeKeyAndOrderFront(), the app's windows will remain behind the Xcode windows.

However, this issue only occurs when Xcode is the active application behind our app.
If a different application is in the background, the app's windows will behave as expected.

## Usage
- Use "Hide/Show Dock Icon" button to toggle dock icon visibility
- Try to use Option + B shortcut to increment the counter, to make sure that window still handle keyboard events
