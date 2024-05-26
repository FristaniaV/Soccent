//
//  SentimentAnalyzer.swift
//  Soccent
//
//  Created by Fristania Verenita on 20/05/24.
//

import Foundation
import CoreML

func analyzeSentiments(comments: [String], model: SentimentClassifier) -> [String: Int] {
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

func analyzeEmotions(comments: [String], model: EmotionClassifier) -> [String: Int] {
    var emotions: [String: Int] = ["anger": 0, "joy": 0, "anticipation": 0, "optimism": 0, "disgust": 0, "sadness": 0, "fear": 0, "surprise": 0]
    
    for comment in comments {
        do {
            let prediction = try model.prediction(text: comment)
            print(prediction.label)
            emotions[prediction.label, default: 0] += 1
        } catch {
            print("Error analyzing emotion for comment: \(comment). Error: \(error)")
        }
    }
    
    return emotions
}

func calculatePercentagesS(sentimentCounts: [String: Int], total: Int) -> [String: Double] {
    var percentages: [String: Double] = [:]
    for (sentiment, count) in sentimentCounts {
        percentages[sentiment] = (Double(count) / Double(total)) * 100
    }
    return percentages
}

func calculatePercentagesE(emotionCounts: [String: Int], total: Int) -> [String: Double] {
    var percentages: [String: Double] = [:]
    for (emotion, count) in emotionCounts {
        percentages[emotion] = (Double(count) / Double(total)) * 100
    }
    return percentages
}
