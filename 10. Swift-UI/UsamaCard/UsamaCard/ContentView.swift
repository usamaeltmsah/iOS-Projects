//
//  ContentView.swift
//  UsamaCard
//
//  Created by Usama Fouad on 26/09/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.09, green: 0.63, blue: 0.52)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("usama")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 5)
                )
                Text("Usama Fouad")
                    .font(Font.custom("Pacifico-Regular", size: 40)).bold().foregroundColor(.white)
                Text("iOS Developer").foregroundColor(.white).font(.system(size: 25))
                
                Divider()
                
                InfoView(text: "+20 100 877 5435", imageName: "phone.fill")
                
                InfoView(text: "usamaeltmsah@gmail.com", imageName: "envelope.fill")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
