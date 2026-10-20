//
//  FeedView.swift
//  DENFeed
//
//  Created by DENAZMI on 10/12/25.
//


import SwiftUI

struct FeedView: View {
    @Environment(AppRouter.self) var router
    @State var viewModel: FeedViewModel
    
    var body: some View {
        VStack {
            Text("Feed")
            ScrollView(showsIndicators: false) {
                if viewModel.isLoading {
                    loadingView()
                } else if let message = viewModel.errorMessage {
                    errorView(with: message)
                } else if viewModel.feeds.isEmpty {
                    emptyView()
                } else {
                    ForEach(viewModel.feeds) { feed in
                        Button {
                            router.push(.detail(title: feed.title, body: feed.body))
                        } label: {
                            FeedRowView(feed: feed)
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.loadData()
            }
        }
        .padding()
        .task {
            await viewModel.loadData()
        }
    }
    
    private func loadingView() -> some View {
        ProgressView("Load feeds...")
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowSeparator(.hidden)
    }
    
    private func emptyView() -> some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "tray")
                .font(.system(size: 32))
                .foregroundStyle(.gray)
            Text("No posts yet")
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
    
    private func errorView(with message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 32))
                .foregroundStyle(.red)
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
            Button("Try Again") {
                Task { await viewModel.loadData() }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
}



#Preview {
    let dependencies = AppDependencies()
    let viewModel = dependencies.makeFeedViewModel()
    FeedView(viewModel: viewModel)
        .environment(AppRouter())
}
