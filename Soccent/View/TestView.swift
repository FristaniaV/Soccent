//
//  TestView.swift
//  Soccent
//
//  Created by Fristania Verenita on 20/05/24.
//

import SwiftUI
import CoreML

func testModel(inputText: String) -> String {
    do {
        let config = MLModelConfiguration()
        let model = try SentimentClassifier(configuration: config)
        let prediction = try model.prediction(text: inputText)

        return prediction.label
    } catch {
        print("Error during model prediction: \(error)")
        return "Error"
    }
}

struct TestView: View {
    @State private var userInput: String = ""
    @State private var sentimentType: String = "Enter a comment to analyze its sentiment"

    private func analyzeSentiment() {
        guard !userInput.isEmpty else {
            sentimentType = "Please enter a comment"
            return
        }

        sentimentType = testModel(inputText: userInput)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Sentiment Analysis")
                .font(.largeTitle)
                .padding()

            TextField("Enter your comment", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                analyzeSentiment()
            }) {
                Text("Analyze")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Text(sentimentType)
                .padding()
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    TestView()
}
