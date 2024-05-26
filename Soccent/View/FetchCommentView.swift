//
//  FetchCommentView.swift
//  Soccent
//
//  Created by Fristania Verenita on 21/05/24.
//


import SwiftUI
import CoreML

struct FetchCommentView: View {
    @State private var urlInput: String = ""
    @State private var comments: [String] = []
    @State private var sentiments: [String: Double] = ["Positive": 0.0, "Neutral": 0.0, "Negative": 0.0]
    @State private var showComments = false
    @State private var totalComments = 0

    let apiKey = "AIzaSyA1bZad7QO376-RgndxkOsEN9TQw6DBWPQ" 
    
    var body: some View {
        VStack(spacing: 20) {
            
            Image("LogoWithText")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            
            HStack {
                TextField("Enter YouTube video URL", text: $urlInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if !urlInput.isEmpty {
                    Button(action: {
                        urlInput = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 10)
                }
            }
            
//            Button(action: {
//                print("URL input: \(urlInput)") // Debugging line
//                guard let videoID = extractVideoID(from: urlInput) else {
//                    print("Invalid video ID")  // Debugging line
//                    return
//                }
//                print("Valid video ID: \(videoID)")  // Debugging line
//                fetchComments(for: videoID, apiKey: apiKey) { fetchedComments in
//                    DispatchQueue.main.async {
//                        self.comments = fetchedComments
//                        self.showComments = true
//                        let model = try! SentimentClassifierNew(configuration: MLModelConfiguration())
//                        self.sentiments = analyzeSentiments(comments: fetchedComments, model: model)
//                    }
//                }
//            }) {
//                Text("Analyze")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
            
            Button(action: {
                 print("URL input: \(urlInput)") // Debugging line
                 guard let videoID = extractVideoID(from: urlInput) else {
                     print("Invalid video ID")  // Debugging line
                     return
                 }
                 print("Valid video ID: \(videoID)")  // Debugging line
                 fetchComments(for: videoID, apiKey: apiKey) { fetchedComments in
                     DispatchQueue.main.async {
                         self.comments = fetchedComments
                         self.showComments = true
                         let model = try! SentimentClassifierNew(configuration: MLModelConfiguration())
                         let sentimentCounts = analyzeSentiments(comments: fetchedComments, model: model)
                         self.totalComments = fetchedComments.count
                         self.sentiments = calculatePercentages(sentimentCounts: sentimentCounts, total: self.totalComments)
                     }
                 }
             }) {
                 Text("Analyze")
                     .padding()
                     .background(Color.blue)
                     .foregroundColor(.white)
                     .cornerRadius(8)
             }
            
            
            if showComments {
                List(comments, id: \.self) { comment in
                    Text(comment)
                }
                .frame(height: 300)
                
                VStack {
                    Text("Sentiment Analysis Results")
                        .font(.largeTitle)
                        .padding()
                    
                    HStack {
//                        Text("Positive: \(sentiments["positive"] ?? 0)")
//                        Text("Neutral: \(sentiments["neutral"] ?? 0)")
//                        Text("Negative: \(sentiments["negative"] ?? 0)")
                        Text("Positive: \(String(format: "%.2f", sentiments["positive"] ?? 0.0))%")
                        Text("Neutral: \(String(format: "%.2f", sentiments["neutral"] ?? 0.0))%")
                        Text("Negative: \(String(format: "%.2f", sentiments["negative"] ?? 0.0))%")
                    }
                    .font(.title2)
                    .padding()
                }
            }
        }
        .padding()
    }
}

struct FetchCommentView_Previews: PreviewProvider {
    static var previews: some View {
        FetchCommentView()
    }
}
