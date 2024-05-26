//
//  SentimentCardView.swift
//  Soccent
//
//  Created by Fristania Verenita on 20/05/24.
//

import SwiftUI

struct SentimentCardView: View {
    var sentiments: [String: Int]
    var total: Int
    
    
    var body: some View {
        VStack {
            Text("Sentiment Analysis Results")
                .font(.largeTitle)
                .padding()
            
            HStack {
                
                Text("Positive: \(sentiments["positive"] ?? 0)")
                Text("Neutral: \(sentiments["neutral"] ?? 0)")
                Text("Negative: \(sentiments["negative"] ?? 0)")
            }
            .font(.title2)
            .padding()
        }
    }
}

