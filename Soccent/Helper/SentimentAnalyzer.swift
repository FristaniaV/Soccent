//
//  SentimentAnalyzer.swift
//  Soccent
//
//  Created by Fristania Verenita on 20/05/24.
//

import Foundation
import CoreML

func analyzeSentiments(comments: [String], model: SentimentClassifierNew) -> [String: Int] {
    var sentiments: [String: Int] = ["positive": 0, "neutral": 0, "negative": 0]
    
    for comment in comments {
        do {
            let prediction = try model.prediction(text: comment)
            print(prediction.label)
            sentiments[prediction.label, default: 0] += 1
        } catch {
            print("Error analyzing sentiment for comment: \(comment). Error: \(error)")
        }
    }
    
    return sentiments
}


