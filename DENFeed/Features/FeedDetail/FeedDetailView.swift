//
//  FeedDetailView.swift
//  DENFeed
//
//  Created by DENAZMI on 10/12/25.
//


import SwiftUI

struct FeedDetailView: View {
    
    let title: String
    let bodyString: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(bodyString)
                .font(.body)
        }
        .padding()
    }
}

#Preview {
    FeedDetailView(title: "Title", bodyString: "Body")
}
