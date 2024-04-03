//
//  ArticleView.swift
//  News App
//
//  Created by Vedant Arora on 02/04/24.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit

struct ArticleView: View {
    var article: Article
    var isBookmarked: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing : 10){
                Text(article.title).fontWeight(.heavy)
                Text(article.description).lineLimit(2)
            }
            if let imageUrl = URL(string: article.imageURL) {
                WebImage(url: imageUrl, options: .highPriority, context: nil)
                    .resizable().frame(width: 110, height: 110).cornerRadius(10)
            } else {
                Image(systemName: "globe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }
            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                .foregroundColor(isBookmarked ? .blue : .gray)
        }.padding(.vertical, 15)
    }
}
struct HorizontalArticleView: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: URL(string: article.imageURL))
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 100)
                .cornerRadius(8)
            
            Text(article.title)
                .font(.headline)
                .lineLimit(2)
                .padding(.top, 4)
        }
    }
}

