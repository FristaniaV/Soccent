//
//  HomeView.swift
//  Soccent
//
//  Created by Fristania Verenita on 20/05/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = URLInputViewModel()
    
    var body: some View {
        VStack {
            
            Spacer()
            
            // Logo at the top
            Image("LogoWithText")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.bottom, -40)
            
            // Tagline
            Text("Insights in Every Comment.")
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .padding()
            
            // Search bar
            
            HStack {
                TextField("Type your post URL", text: $viewModel.urlInput)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.leading, 10)
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.trailing, 10)
            }
            .padding()
            .background(Color.white)  // Solid white background
            .cornerRadius(8)
            .frame(width: 500, height: 50)
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //        .background(
        //            LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.2), Color.white]),
        //                           startPoint: .topLeading,
        //                           endPoint: .bottomTrailing)
        //        )
        .background(
            Image("HomeBg")
                .resizable()
                .scaledToFit()
                .scaleEffect()
        )
        .ignoresSafeArea()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
