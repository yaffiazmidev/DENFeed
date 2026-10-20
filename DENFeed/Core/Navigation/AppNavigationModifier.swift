import SwiftUI

struct AppNavigationModifier: ViewModifier {
    var dependencies: AppDependencies
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .list:
                    let vm = dependencies.makeFeedViewModel()
                    FeedView(viewModel: vm)
                    
                case let .detail(title, body):
                    FeedDetailView(title: title, bodyString: body)
                }
            }
    }
}

extension View {
    func withAppRouter(dependencies: AppDependencies) -> some View {
        self.modifier(AppNavigationModifier(dependencies: dependencies))
    }
}
