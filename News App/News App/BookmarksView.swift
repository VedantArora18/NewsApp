//
//  BookmarksView.swift
//  News App
//
//  Created by Vedant Arora on 01/04/24.
//

import SwiftUI

struct BookmarksView: View {
    @Binding var bookmarks: Set<String>
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Text("Bookmarks: \(bookmarks.count)").padding()
                }
                List {
                    ForEach(Array(bookmarks), id: \.self) { bookmark in
                        Text(bookmark)
                    }
                }.navigationBarTitle("Bookmarks")
            }
        }
    }
}


