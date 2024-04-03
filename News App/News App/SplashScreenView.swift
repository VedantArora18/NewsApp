//
//  SpalshScreenView.swift
//  News App
//
//  Created by Vedant Arora on 01/04/24.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit


struct SplashScreenView: View {
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var isLoggedIn = false  

    var body: some View {
        if isLoggedIn {
           ContentView()
            
        } else {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack{
                    VStack{
                        Image("NEWS")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 375, height: 375)
                            .font(.system(size: 50))
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .background(.white)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)){
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
                }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        withAnimation {
                            self.isLoggedIn = true // Set isLoggedIn to true after splash screen
                        }
                    }
                }
            }
        }
    }
}

        


struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}



