//
//  FeedRowView.swift
//  DENFeed
//
//  Created by DENAZMI on 11/12/25.
//


import SwiftUI

struct FeedRowView: View {
    let feed: FeedItemViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading) {
                Text(feed.title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray.opacity(0.8))
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
