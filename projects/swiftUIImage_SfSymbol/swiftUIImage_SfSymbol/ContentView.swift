//
//  ContentView.swift
//  swiftUIImage_SfSymbol
//
//  Created by kunguma-14252 on 09/06/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "wifi.router.fill")
                .renderingMode(.original)
                .font(.largeTitle)
                .padding()
                .background(.white)
                .clipShape(Circle())
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
