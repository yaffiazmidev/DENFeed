//
//  DENFeedApp.swift
//  DENFeed
//
//  Created by DENAZMI on 10/12/25.
//

import SwiftUI

@main
struct DENFeedApp: App {
    @State private var router = AppRouter()
    @State private var dependencies = AppDependencies()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                let viewModel = dependencies.makeFeedViewModel()
                FeedView(viewModel: viewModel)
                    .withAppRouter(dependencies: dependencies)
            }
            .environment(router)
        }
    }
}
