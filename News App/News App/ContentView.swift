//
//  ContentView.swift
//  News App
//
//  Created by Vedant Arora on 01/04/24.
//



import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit

struct ContentView: View {
    @StateObject var dataManager = DataManager()
    @StateObject var selectedCategory = SelectedCategory()
    @State private var bookmarks: Set<String> = Set<String>()
    @State private var showBookmarks = false
    @State private var trendingArticles = [Article]() // Trending articles

    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: Date())
    }

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        Text("Hi Vedant!")
                            .font(.system(size: 22, weight: .bold))
                            .padding(.leading)
                        
                        Spacer()
                        Text(getFormattedDate())
                            .font(.headline)
                            .padding(.leading)
                        Spacer()
                        
                        Button(action: {
                            self.showBookmarks.toggle()
                        }) {
                            Image(systemName: "bookmark.fill")
                                .padding()
                        }
                        
                        Image(systemName: "person.crop.circle")
                            .padding()
                            .foregroundColor(.blue)
                        
                        Spacer()
                    }
                    .background(Color(.systemGray3))
                    .navigationBarBackButtonHidden(true)

                    if !trendingArticles.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Trending News")
                                .font(.system(size: 22, weight: .bold))
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(trendingArticles) { article in
                                        TrendingArticleView(article: article)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    // News Categories Section
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(NewsCategory.allCases, id: \.self) { category in
                                Button(action: {
                                    selectedCategory.category = category
                                    refreshData()
                                }) {
                                    Text(category.rawValue.capitalized)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(selectedCategory.category == category ? Color.blue.opacity(0.5) : Color.gray.opacity(0.5))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // List of Articles
                List(dataManager.articles) { article in
                    NavigationLink(destination: webView(url: article.url)
                                    .navigationBarTitle("", displayMode: .inline)) {
                        ArticleView(article: article, isBookmarked: self.bookmarks.contains(article.url))
                            .onTapGesture {
                                if self.bookmarks.contains(article.url) {
                                    self.bookmarks.remove(article.url)
                                } else {
                                    self.bookmarks.insert(article.url)
                                }
                            }
                    }
                }
            }
        }
        .sheet(isPresented: $showBookmarks) {
            BookmarksView(bookmarks: self.$bookmarks)
        }
        .onAppear {
            // Fetch trending articles data
            fetchTrendingArticles()
        }
    }

    func refreshData() {
        Task {
            await dataManager.fetchData(category: selectedCategory.category)
        }
    }

    // Function to fetch trending articles
    func fetchTrendingArticles() {
        let apiKey = "f1a8c1e8e63b493d8d27a7c2df51ebe1"
        let trendingSource = "https://newsapi.org/v2/top-headlines?country=in&apiKey=\(apiKey)"
        
        guard let url = URL(string: trendingSource) else {
            print("Invalid URL")
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let json = try JSON(data: data)
                let articlesData = json["articles"].arrayValue
                self.trendingArticles = articlesData.map { Article(fromJSON: $0) }
            } catch {
                print("Error fetching trending articles data: \(error.localizedDescription)")
            }
        }
    }
}
struct TrendingArticleView: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: URL(string: article.imageURL))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 240, height: 120)
                .cornerRadius(8)

            Text(article.title)
                .font(.caption)
                .lineLimit(1)
                .padding(.top, 4)
        }
    }
}

class SelectedCategory: ObservableObject {
    @Published var category: NewsCategory = .general
}

enum NewsCategory: String, CaseIterable {
    case general, business, entertainment,  health, science, sports, technology
}

class DataManager: ObservableObject {
    @Published var articles = [Article]()

    func fetchData(category: NewsCategory) async {
        let apiKey = "f1a8c1e8e63b493d8d27a7c2df51ebe1"
        let source = "https://newsapi.org/v2/top-headlines?country=in&apiKey=\(apiKey)&category=\(category.rawValue)"

        guard let url = URL(string: source) else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSON(data: data)
            let articlesData = json["articles"].arrayValue
            self.articles = articlesData.map { Article(fromJSON: $0) }
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
}

struct webView : UIViewRepresentable {
    var url : String
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: self.url) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Article: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let url: String
    let imageURL: String

    init(fromJSON json: JSON) {
        title = json["title"].stringValue
        description = json["description"].stringValue
        url = json["url"].stringValue
        imageURL = json["urlToImage"].stringValue
    }
}




