//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Peter Molnar on 14/10/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Text("1")
                Text("2")
                Text("3")
            }
            HStack(spacing: 20) {
                Text("4")
                Text("5")
                Text("6")
            }
            HStack(spacing: 20) {
                Text("7")
                Text("8")
                Text("8")
            }
        }
        ZStack {
            Color.red.edgesIgnoringSafeArea(.all)
            LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)

//            RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 20, endRadius: 200)

            //AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
            Text("Your Content")
        }
        Button {
            print("Button was tapped")
            self.showingAlert = true
        } label: {
            Image(systemName: "pencil").renderingMode(.original)
            Text("Edit")
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Hello SwiftUI!"), message: Text("This is some details message"), dismissButton: .default(Text("OK")))
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
