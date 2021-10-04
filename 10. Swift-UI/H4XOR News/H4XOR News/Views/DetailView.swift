//
//  DetailView.swift
//  H4XOR News
//
//  Created by Usama Fouad on 04/10/2021.
//

import SwiftUI

struct DetailView: View {
    
    let url: String?
    var body: some View {
        WebView(urlString: url)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: "https://www.google.com")
    }
}
