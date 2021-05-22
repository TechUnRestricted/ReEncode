//
//  AppDelegate.swift
//  ReEncode
//
//  Created on 21.05.2021.
//

import Cocoa
import SwiftUI

extension Bundle {
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
    var appName: String {
        return (Bundle.main.infoDictionary?["CFBundleName"] as! String)
    }
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func showAlert(messageText : String, informativeText : String = "") {
        let alert = NSAlert.init()
        alert.messageText = messageText
        alert.informativeText = informativeText
        alert.addButton(withTitle: "Close")
        alert.beginSheetModal(for: window)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 200),
            styleMask: [.titled, .closable, .miniaturizable,  .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = true
        window.center()
        window.titlebarAppearsTransparent = true
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        window.isMovableByWindowBackground = true
        window.title = Bundle.main.appName

    }

    @IBAction func onClickAboutApp(_ sender: Any) {
        
            showAlert(messageText: "ReEncode v\(Bundle.main.releaseVersionNumber)", informativeText:
                        """
                        This application is distributed for free use.
                        ReEncode is sandboxed, so some functionality such as manual path entry may not be available.
                        The author of this application is not responsible for anything.
                        If you find bugs - feel free to report me.
                        Source Code: github.com/TechUnRestricted/ReEncode
                        """)
       
    }
  
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
            return true
        }

}

