//
//  FindingBeautyApp.swift
//  FindingBeauty
//
//  Created by Tiago Pereira on 29/10/25.
//

import SwiftUI

@main
struct FindingBeautyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Used for taking screenshots and do screenrecordings
                .frame(
                    minWidth: 1920,
                    maxWidth: 1920,
                    minHeight: 1080,
                    maxHeight: 1080
                )
        }
        .windowResizability(.contentSize)
    }
    
}


