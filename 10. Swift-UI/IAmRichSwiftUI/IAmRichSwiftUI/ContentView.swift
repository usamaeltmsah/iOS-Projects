//
//  ContentView.swift
//  IAmRichSwiftUI
//
//  Created by Usama Fouad on 26/09/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(.systemTeal).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Text("I Am Rich").fontWeight(.bold).padding().font(.system(size: 40)).foregroundColor(.white)
                Image("diamond").resizable(capInsets: EdgeInsets()).aspectRatio(contentMode: .fit).frame(width: 200.0, height: 200.0, alignment: .center)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
