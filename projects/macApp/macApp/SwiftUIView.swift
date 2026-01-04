//
//  SwiftUIView.swift
//  macApp
//
//  Created by kunguma-14252 on 06/04/23.
//

import SwiftUI

//struct SwiftUIView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

struct SwiftUIView: View {
    @State var onLeftSide = true
    @State var timer = Timer.publish(every: 0.4,
                                     on: .main,
                                     in: .common).autoconnect()
    
    var body: some View {
        HStack {
            Image(systemName: "hand.raised")
                .font(.system(size: 80))
                .scaledToFit()
                .foregroundColor(.white)
                .rotationEffect(.degrees(onLeftSide ? -45: 45))
                .padding(.leading, 40)
            
            Spacer()
            
            VStack {
                Text("Hello World...")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("...from a SwiftUI view!")
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundColor(.white)
            }
            .padding(.trailing, 20)
        }
        .background(Color.blue.opacity(0.75))
        .onReceive(timer) { _ in
            onLeftSide.toggle()
        }
        .onAppear {
            withAnimation(.linear(duration: 0.4).repeatForever(autoreverses: false)) {
                onLeftSide = true
            }
        }
    }
}
 
