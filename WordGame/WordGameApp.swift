//
//  WordGameApp.swift
//  WordGame
//
//  Created by Luisa Cruz Molina on 07.12.20.
//

import SwiftUI
import ComposableArchitecture

@main
struct WordGameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: AppState(),
                    reducer: appReducer,
                    environment: AppEnvironment(
                        wordClient: .local,
                        mainQueue:  DispatchQueue.main.eraseToAnyScheduler()
                    )
                )
            )
        }
    }
}
