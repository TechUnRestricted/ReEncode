//
//  ReEncodeApp.swift
//  ReEncode
//
//  Created on 02.05.2021.
//

import SwiftUI

@main
struct ReEncodeApp: App {
    
    var body: some Scene {
        WindowGroup {
            
            ContentView().frame(maxWidth: 450)
            
        } .commands {
            CommandGroup(replacing: .newItem, addition: { })
            CommandGroup(replacing: .help, addition: { })
            CommandGroup(replacing: .windowSize, addition: { })

            
        }
        
        
    }
    
    
}
