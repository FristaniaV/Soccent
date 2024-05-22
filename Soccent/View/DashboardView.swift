//
//  DashboardView.swift
//  Soccent
//
//  Created by Fristania Verenita on 20/05/24.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject private var viewModel = URLInputViewModel()
    
    var body: some View {
        
        VStack {
            HStack {
                Image("LogoWithText")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 99, height: 36.86)
                
                Spacer()
                
                HStack {
                    RoundedRectangle(cornerRadius: 14)
                        .frame(width: 212, height: 49)
                        .foregroundColor(.white)
                        .overlay{
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 22))
                                    .foregroundColor(.gray)
                                //                                .padding()
                                TextField("Type your post URL", text: $viewModel.urlInput)
                                    .padding()
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .font(.system(size: 14))
                            }
                            .padding()
                        }
                    
                    RoundedRectangle(cornerRadius: 14)
                        .frame(width: 49, height: 49)
                        .foregroundColor(.white)
                        .overlay{
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 22))
                                .foregroundColor(.gray)
                        }
                    
                    RoundedRectangle(cornerRadius: 14)
                        .frame(width: 49, height: 49)
                        .foregroundColor(.white)
                        .overlay{
                            Image(systemName: "house")
                                .font(.system(size: 22))
                                .foregroundColor(.gray)
                        }
                    
                }
            }
            .padding(.horizontal, 40)
            
            HStack {
                VStack {
                    RoundedRectangle(cornerRadius: 28)
                        .frame(width: 377, height: 324)
                        .foregroundColor(.white)
                        .overlay{
                            Text("WORDCLOUD")
                        }
                    
                    RoundedRectangle(cornerRadius: 28)
                        .frame(width: 377, height: 333)
                        .foregroundColor(.white)
                        .overlay{
                            Text("EMOTION")
                        }
                }
                
                VStack {
                    RoundedRectangle(cornerRadius: 28)
                        .frame(width: 384, height: 400)
                        .foregroundColor(.white)
                        .overlay{
                            Text("SENTIMENTS")
                        }
                    
                    RoundedRectangle(cornerRadius: 28)
                        .frame(width: 380, height: 361)
                        .foregroundColor(.white)
                        .overlay{
                            Text("TOP 10 OCCURING WORD")
                        }
                }
                
                VStack {
                    RoundedRectangle(cornerRadius: 28)
                        .frame(width: 359, height: 601)
                        .foregroundColor(.white)
                        .overlay{
                            Text("COMMENTS")
                        }
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 14)
                            .frame(width: 295, height: 49)
                            .foregroundColor(.white)
                            .overlay{
                                Text("5678 comments")
                                    .padding()
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                        
                        RoundedRectangle(cornerRadius: 14)
                            .frame(width: 49, height: 49)
                            .foregroundColor(.red)
                            .overlay{
                                Image(systemName: "arrow.down.circle")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                            }
                    }
                }
            }
        }
        .background(
            Image("HomeBg")
                .resizable()
                .scaledToFit()
                .scaleEffect()
        )
        .ignoresSafeArea()
        
        
        
        
    }
}

#Preview {
    DashboardView()
}
