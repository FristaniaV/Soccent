//
//  YouTubeAPIService.swift
//  Soccent
//
//  Created by Fristania Verenita on 20/05/24.
//

import Foundation


func extractVideoID(from url: String) -> String? {
    let patterns = [
        "v=([\\w-]+)",           // Matches 'v=VIDEO_ID' in the query parameters
        "youtu\\.be/([\\w-]+)",  // Matches 'youtu.be/VIDEO_ID'
        "youtube\\.com/embed/([\\w-]+)",  // Matches 'youtube.com/embed/VIDEO_ID'
        "youtube\\.com/v/([\\w-]+)"       // Matches 'youtube.com/v/VIDEO_ID'
    ]
    
    for pattern in patterns {
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: url.count)
        if let match = regex?.firstMatch(in: url, options: [], range: range) {
            if let swiftRange = Range(match.range(at: 1), in: url) {
                let videoID = String(url[swiftRange])
                print("Extracted Video ID: \(videoID)")  // Debugging line
                return videoID
            }
        }
    }
    
    print("Failed to extract video ID") // Debugging line
    return nil
}




struct YouTubeCommentSnippet: Decodable {
    let textDisplay: String
}

struct YouTubeTopLevelComment: Decodable {
    let snippet: YouTubeCommentSnippet
}

struct YouTubeCommentThreadSnippet: Decodable {
    let topLevelComment: YouTubeTopLevelComment
}

struct YouTubeCommentThread: Decodable {
    let snippet: YouTubeCommentThreadSnippet
}

struct YouTubeCommentResponse: Decodable {
    let items: [YouTubeCommentThread]
}

func fetchComments(for videoID: String, apiKey: String, completion: @escaping ([String]) -> Void) {
    let urlString = "https://www.googleapis.com/youtube/v3/commentThreads?part=snippet&videoId=\(videoID)&key=\(apiKey)&maxResults=30"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error fetching comments: \(error)")
            return
        }
        
        guard let data = data else {
            print("No data received")
            return
        }
        
        do {
            let response = try JSONDecoder().decode(YouTubeCommentResponse.self, from: data)
            let comments = response.items.map { $0.snippet.topLevelComment.snippet.textDisplay }
            completion(comments)
        } catch {
            print("Error decoding response: \(error)")
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                print("Received JSON: \(json)")
            }
        }
    }.resume()
}
