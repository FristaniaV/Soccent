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
    @State private var emotions: [String: Double] = ["Anger": 0.0, "Joy": 0.0, "Anticipation": 0.0, "Optimism": 0.0, "Disgust": 0.0, "Sadness": 0.0, "Fear": 0.0, "Surprise": 0.0]
    @State private var isAnalyzeSentiment = true
    
    let apiKey = "AIzaSyA1bZad7QO376-RgndxkOsEN9TQw6DBWPQ"
    
    var body: some View {
        VStack(spacing: 20) {
            
            Image("LogoWithText")
                .resizable()
                .scaledToFit()
                .frame(width: 229, height: 84.81)
            
            Text("Insights in Every Comment.")
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(Color("BlackSc"))
                .padding()
                .font(
                    Font.custom("SF Pro", size: 22)
                )
            
            HStack {
                HStack {
                    TextField("Type your post URL", text: $urlInput)
                        .foregroundColor(Color(hex: "ACB5BD"))
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.leading)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
                .padding()
                .background(Color(hex: "FEFEFE"))
                .cornerRadius(16)
                .frame(width: 806, height: 64)
                
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

                            let modelS = try! SentimentClassifier(configuration: MLModelConfiguration())
                            let modelE = try! EmotionClassifier(configuration: MLModelConfiguration())
                            let sentimentCounts = analyzeSentiments(comments: fetchedComments, model: modelS)
                            let emotionCounts = analyzeEmotions(comments: fetchedComments, model: modelE)
                            self.totalComments = fetchedComments.count
                            self.sentiments = calculatePercentagesS(sentimentCounts: sentimentCounts, total: self.totalComments)
                            self.emotions = calculatePercentagesE(emotionCounts: emotionCounts, total: self.totalComments)
                        }
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("DarkPinkSc"))
                            .frame(width: 169, height: 56.0)
                        Text("Analyze")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                    }
                }
                .padding(.leading)
                
                
                //                if !urlInput.isEmpty {
                //                    Button(action: {
                //                        urlInput = ""
                //                    }) {
                //                        Image(systemName: "xmark.circle.fill")
                //                            .foregroundColor(.gray)
                //                    }
                //                    .padding(.trailing, 10)
                //                }
            }
            .padding(.bottom, 40)
            
            //            Text("Sentiment")
            //              .font(
            //                Font.custom("SF Pro", size: 20)
            //                  .weight(.semibold)
            //              )
            //              .foregroundColor(Color(red: 0.63, green: 0.6, blue: 0.6))
            //
            //            Text("Emotion")
            //              .font(
            //                Font.custom("SF Pro", size: 20)
            //                  .weight(.semibold)
            //              )
            //              .foregroundColor(Color(red: 0.11, green: 0.06, blue: 0.07))
            //
            //            Rectangle()
            //              .foregroundColor(.clear)
            //              .frame(width: 92, height: 6)
            //              .background(Color(red: 0.95, green: 0.32, blue: 0.32))
            //              .cornerRadius(16)
            
        
            
            
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
            
            
            if showComments {
                // Tab Menu
                HStack {
                    Button(action: {
                        isAnalyzeSentiment = true
                    }) {
                        VStack {
                            Text("Sentiment")
                                .font(Font.custom("SF Pro", size: 20).weight(.semibold))
                                .foregroundColor(isAnalyzeSentiment ? Color(red: 0.11, green: 0.06, blue: 0.07) : Color(red: 0.63, green: 0.6, blue: 0.6))
                            Rectangle()
                                .frame(width: 92, height: 6)
                                .foregroundColor(isAnalyzeSentiment ? Color(red: 0.95, green: 0.32, blue: 0.32) : .clear)
                                .cornerRadius(16)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                        .frame(width: 96)
                    
                    Button(action: {
                        isAnalyzeSentiment = false
                    }) {
                        VStack {
                            Text("Emotion")
                                .font(Font.custom("SF Pro", size: 20).weight(.semibold))
                                .foregroundColor(!isAnalyzeSentiment ? Color(red: 0.11, green: 0.06, blue: 0.07) : Color(red: 0.63, green: 0.6, blue: 0.6))
                            Rectangle()
                                .frame(width: 92, height: 6)
                                .foregroundColor(!isAnalyzeSentiment ? Color(red: 0.95, green: 0.32, blue: 0.32) : .clear)
                                .cornerRadius(16)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.bottom, 8)
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(comments, id: \.self) { comment in
                            Text(comment)
                                .padding()
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(
                        Color.white
                            .opacity(0.4)
                    )
                }
                .frame(width: 1623, height: 517)
                .cornerRadius(32)
                
                
                
                //                    Text("Sentiment Analysis Results")
                //                        .font(.largeTitle)
                //                        .padding()
                if isAnalyzeSentiment {
                    HStack {
                        //                        Text("Positive: \(sentiments["positive"] ?? 0)")
                        //                        Text("Neutral: \(sentiments["neutral"] ?? 0)")
                        //                        Text("Negative: \(sentiments["negative"] ?? 0)")
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 188, height: 96)
                                .background(Color(red: 1, green: 1, blue: 1))
                                .cornerRadius(24)
                            
                            Text("\(String(format: "%.0f", sentiments["positive"] ?? 0.0))%")
                                .fontWeight(.bold)
                                .font(
                                    Font.custom("SF Pro", size: 36)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color("BlackSc"))
                                .padding(.leading, 80)
                            
                            Text("☺️")
                                .font(
                                    Font.custom("SF Pro", size: 128)
                                        .weight(.bold)
                                )
                                .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                .padding(.trailing, 152)
                        }
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 188, height: 96)
                                .background(Color(red: 1, green: 1, blue: 1))
                                .cornerRadius(24)
                            
                            Text("\(String(format: "%.0f", sentiments["neutral"] ?? 0.0))%")
                                .fontWeight(.bold)
                                .font(
                                    Font.custom("SF Pro", size: 36)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color("BlackSc"))
                                .padding(.leading, 80)
                            
                            Text("😐")
                                .font(
                                    Font.custom("SF Pro", size: 128)
                                        .weight(.bold)
                                )
                                .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                .padding(.trailing, 152)
                        }
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 188, height: 96)
                                .background(Color(red: 1, green: 1, blue: 1))
                                .cornerRadius(24)
                            
                            Text("\(String(format: "%.0f", sentiments["negative"] ?? 0.0))%")
                                .fontWeight(.bold)
                                .font(
                                    Font.custom("SF Pro", size: 36)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color("BlackSc"))
                                .padding(.leading, 80)
                            
                            Text("😡")
                                .font(
                                    Font.custom("SF Pro", size: 128)
                                        .weight(.bold)
                                )
                                .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                .padding(.trailing, 152)
                        }
                        
                        //                    Text("Positive: \(String(format: "%.2f", sentiments["positive"] ?? 0.0))%")
                        //                    Text("Neutral: \(String(format: "%.2f", sentiments["neutral"] ?? 0.0))%")
                        //                    Text("Negative: \(String(format: "%.2f", sentiments["negative"] ?? 0.0))%")
                    }
                    .font(.title2)
                    .padding()
                } else {
                    HStack {
                        VStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 119.56799, height: 61.05599)
                                    .background(Color(red: 1, green: 1, blue: 1))
                                    .cornerRadius(15.264)
                                
                                Text("\(String(format: "%.0f", emotions["anger"] ?? 0.0))%")
                                    .fontWeight(.bold)
                                    .font(
                                        Font.custom("SF Pro", size: 22)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("BlackSc"))
                                    .padding(.leading, 40)
                                
                                Text("😡")
                                    .font(
                                        Font.custom("SF Pro", size: 81.40799)
                                            .weight(.bold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                    .padding(.trailing, 96)
                            }
                            
                            Text("Anger")
                                .font(
                                    Font.custom("SF Pro", size: 18)
                                        .weight(.semibold)
                                )
                                .foregroundColor(Color(red: 0.63, green: 0.6, blue: 0.6))
                        }
                        
                        VStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 119.56799, height: 61.05599)
                                    .background(Color(red: 1, green: 1, blue: 1))
                                    .cornerRadius(15.264)
                                
                                Text("\(String(format: "%.0f", emotions["joy"] ?? 0.0))%")
                                    .fontWeight(.bold)
                                    .font(
                                        Font.custom("SF Pro", size: 22)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("BlackSc"))
                                    .padding(.leading, 40)
                                
                                Text("😆")
                                    .font(
                                        Font.custom("SF Pro", size: 81.40799)
                                            .weight(.bold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                    .padding(.trailing, 96)
                            }
                            
                            Text("Joy")
                                .font(
                                    Font.custom("SF Pro", size: 18)
                                        .weight(.semibold)
                                )
                                .foregroundColor(Color(red: 0.63, green: 0.6, blue: 0.6))
                        }
                        
                        VStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 119.56799, height: 61.05599)
                                    .background(Color(red: 1, green: 1, blue: 1))
                                    .cornerRadius(15.264)
                                
                                Text("\(String(format: "%.0f", emotions["anticipation"] ?? 0.0))%")
                                    .fontWeight(.bold)
                                    .font(
                                        Font.custom("SF Pro", size: 22)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("BlackSc"))
                                    .padding(.leading, 40)
                                
                                Text("🧐")
                                    .font(
                                        Font.custom("SF Pro", size: 81.40799)
                                            .weight(.bold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                    .padding(.trailing, 96)
                            }
                            
                            Text("Anticipation")
                                .font(
                                    Font.custom("SF Pro", size: 18)
                                        .weight(.semibold)
                                )
                                .foregroundColor(Color(red: 0.63, green: 0.6, blue: 0.6))
                        }
                        
                        VStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 119.56799, height: 61.05599)
                                    .background(Color(red: 1, green: 1, blue: 1))
                                    .cornerRadius(15.264)
                                
                                Text("\(String(format: "%.0f", emotions["optimism"] ?? 0.0))%")
                                    .fontWeight(.bold)
                                    .font(
                                        Font.custom("SF Pro", size: 22)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("BlackSc"))
                                    .padding(.leading, 40)
                                
                                Text("😎")
                                    .font(
                                        Font.custom("SF Pro", size: 81.40799)
                                            .weight(.bold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                    .padding(.trailing, 96)
                            }
                            
                            Text("Optimism")
                                .font(
                                    Font.custom("SF Pro", size: 18)
                                        .weight(.semibold)
                                )
                                .foregroundColor(Color(red: 0.63, green: 0.6, blue: 0.6))
                        }
                        
                        VStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 119.56799, height: 61.05599)
                                    .background(Color(red: 1, green: 1, blue: 1))
                                    .cornerRadius(15.264)
                                
                                Text("\(String(format: "%.0f", emotions["disgust"] ?? 0.0))%")
                                    .fontWeight(.bold)
                                    .font(
                                        Font.custom("SF Pro", size: 22)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("BlackSc"))
                                    .padding(.leading, 40)
                                
                                Text("🤢")
                                    .font(
                                        Font.custom("SF Pro", size: 81.40799)
                                            .weight(.bold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                    .padding(.trailing, 96)
                            }
                            
                            Text("Disgust")
                                .font(
                                    Font.custom("SF Pro", size: 18)
                                        .weight(.semibold)
                                )
                                .foregroundColor(Color(red: 0.63, green: 0.6, blue: 0.6))
                        }
                        
                        VStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 119.56799, height: 61.05599)
                                    .background(Color(red: 1, green: 1, blue: 1))
                                    .cornerRadius(15.264)
                                
                                Text("\(String(format: "%.0f", emotions["sadness"] ?? 0.0))%")
                                    .fontWeight(.bold)
                                    .font(
                                        Font.custom("SF Pro", size: 22)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("BlackSc"))
                                    .padding(.leading, 40)
                                
                                Text("🥲")
                                    .font(
                                        Font.custom("SF Pro", size: 81.40799)
                                            .weight(.bold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                    .padding(.trailing, 96)
                            }
                            
                            Text("Sadness")
                                .font(
                                    Font.custom("SF Pro", size: 18)
                                        .weight(.semibold)
                                )
                                .foregroundColor(Color(red: 0.63, green: 0.6, blue: 0.6))
                        }
                        
                        VStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 119.56799, height: 61.05599)
                                    .background(Color(red: 1, green: 1, blue: 1))
                                    .cornerRadius(15.264)
                                
                                Text("\(String(format: "%.0f", emotions["fear"] ?? 0.0))%")
                                    .fontWeight(.bold)
                                    .font(
                                        Font.custom("SF Pro", size: 22)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("BlackSc"))
                                    .padding(.leading, 40)
                                
                                Text("😖")
                                    .font(
                                        Font.custom("SF Pro", size: 81.40799)
                                            .weight(.bold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                    .padding(.trailing, 96)
                            }
                            
                            Text("Fear")
                                .font(
                                    Font.custom("SF Pro", size: 18)
                                        .weight(.semibold)
                                )
                                .foregroundColor(Color(red: 0.63, green: 0.6, blue: 0.6))
                        }
                        
                        VStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 119.56799, height: 61.05599)
                                    .background(Color(red: 1, green: 1, blue: 1))
                                    .cornerRadius(15.264)
                                
                                Text("\(String(format: "%.0f", emotions["surprise"] ?? 0.0))%")
                                    .fontWeight(.bold)
                                    .font(
                                        Font.custom("SF Pro", size: 22)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("BlackSc"))
                                    .padding(.leading, 40)
                                
                                Text("🤯")
                                    .font(
                                        Font.custom("SF Pro", size: 81.40799)
                                            .weight(.bold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                    .padding(.trailing, 96)
                            }
                            
                            Text("Surprise")
                                .font(
                                    Font.custom("SF Pro", size: 18)
                                        .weight(.semibold)
                                )
                                .foregroundColor(Color(red: 0.63, green: 0.6, blue: 0.6))
                        }
                        
                    }
                }
            }
        }
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //        .background(Color("LightPinkSc"))
        .background(
            Image("HomeBg")
                .resizable()
                .scaledToFill()
                .scaleEffect()
        )
        .ignoresSafeArea(.all)
    }
}

struct FetchCommentView_Previews: PreviewProvider {
    static var previews: some View {
        FetchCommentView()
    }
}

