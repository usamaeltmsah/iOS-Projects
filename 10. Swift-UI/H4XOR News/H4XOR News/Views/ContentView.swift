//
//  ContentView.swift
//  H4XOR News
//
//  Created by Usama Fouad on 04/10/2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var networkManager = NetworkManager() // Setup the property as the listener
    
    var body: some View {
        NavigationView {
            List(networkManager.posts) { post in
                NavigationLink(
                    destination: DetailView(url: post.url),
                    label: {
                        HStack {
                            Text("\(post.points)")
                            Text(post.title)
                        }
                    })
            }
            .navigationBarTitle("H4XOR News")
        }
        .onAppear(perform: {
            self.networkManager.fetchData()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
